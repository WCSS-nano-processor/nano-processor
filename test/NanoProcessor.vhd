----------------------------------------------------------------------------------
-- NANOPROCESSOR TOP MODULE
-- Complete 4-bit processor with ADD, SUB, MOVI, NEG, JZR instructions
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity NanoProcessor is
    port( Clock   : in  STD_LOGIC;
          Reset   : in  STD_LOGIC;
          Overflow: out STD_LOGIC;
          Zero    : out STD_LOGIC;
          S_7Seg  : out STD_LOGIC_VECTOR(6 downto 0);
          anode   : out STD_LOGIC_VECTOR(3 downto 0);
          Data    : out DataBus);
end NanoProcessor;

architecture Structural of NanoProcessor is
    -- Clock signals
    signal s_SlowClk : STD_LOGIC;
    signal s_Res : STD_LOGIC;
    
    -- Program counter signals
    signal s_PCCurrent   : ProgramCounter;
    signal s_PCNext      : ProgramCounter;
    signal s_JumpAddr    : ProgramCounter;
    signal s_JumpEn      : STD_LOGIC;
    signal s_SelectedAddr : ProgramCounter;
    
    -- Instruction signals
    signal s_Instruction : InstructionWord;
    signal s_RegEn       : RegisterSelect;
    signal s_RegSelA     : RegisterSelect;
    signal s_RegSelB     : RegisterSelect;
    signal s_OpSelect    : STD_LOGIC;
    signal s_ImmValue    : DataBus;
    signal s_LoadSel     : STD_LOGIC;
    
    -- Data path signals
    signal s_RegFileOutputs : RegisterFile;
    signal s_OperandA, s_OperandB : DataBus;
    signal s_ALUResult : DataBus;
    signal s_WriteData : DataBus;
    signal s_Overflow, s_Zero : STD_LOGIC;
    
    -- Components
    component Slow_Clk
        Port ( Clk_in : in STD_LOGIC; Clk_out : out STD_LOGIC);
    end component;
    
    component Program_Counter
        Port ( PC_Next : in ProgramCounter; Res : in STD_LOGIC; Clk : in STD_LOGIC;
               PC_Current : out ProgramCounter);
    end component;
    
    component PC_Adder
        port ( current_address : in ProgramCounter; next_address : out ProgramCounter);
    end component;
    
    component Address_Selector
        port ( Sequential_Address : in ProgramCounter; Jump_Address : in ProgramCounter;
               Jump_Enable : in std_logic; Selected_Address : out ProgramCounter);
    end component;
    
    component Program_ROM
        port( program_counter : in ProgramCounter; instruction_out : out InstructionWord);
    end component;
    
    component Instruction_Decoder
        port ( Instruction : in InstructionWord; Register_Value_For_Jump : in DataBus;
               Register_Enable : out RegisterSelect; Register_Select_A : out RegisterSelect;
               Register_Select_B : out RegisterSelect; Operation_Select : out STD_LOGIC;
               Immediate_Value : out DataBus; Jump_Enable : out STD_LOGIC;
               Jump_Address : out ProgramCounter; Load_Select : out STD_LOGIC);
    end component;
    
    component Load_Selector
        Port ( RegisterValue : in DataBus; ImmediateValue : in DataBus;
               LoadSelect : in STD_LOGIC; OutputData : out DataBus);
    end component;
    
    component Register_Bank
        Port ( Data : in DataBus; Reset : in STD_LOGIC; Reg_En : in RegisterSelect;
               Clock : in STD_LOGIC; Register_Outputs : out RegisterFile);
    end component;
    
    component RegisterData_Multiplexer
        Port ( DataSources : in RegisterFile; SelectAddress : in RegisterSelect;
               OutputData : out DataBus);
    end component;
    
    component Add_Sub_4bit
        Port ( Input_A : in DataBus; Input_B : in DataBus; Mode_Sel : in STD_LOGIC;
               Result : out DataBus; Zero_Flag : out STD_LOGIC; Overflow_Flag : out STD_LOGIC);
    end component;
    
    component LUT_16_7
        Port ( I : in STD_LOGIC_VECTOR (3 downto 0); O : out STD_LOGIC_VECTOR (6 downto 0));
    end component;
    
begin
    s_Res <= Reset;
    
    -- Slow clock generation (for visual observation)
    U_SlowClk: Slow_Clk port map (Clk_in => Clock, Clk_out => s_SlowClk);
    
    -- Program Counter and sequencing
    U_PC: Program_Counter port map (PC_Next => s_SelectedAddr, Res => s_Res, Clk => s_SlowClk, PC_Current => s_PCCurrent);
    U_PC_Adder: PC_Adder port map (current_address => s_PCCurrent, next_address => s_PCNext);
    U_AddrSel: Address_Selector port map (Sequential_Address => s_PCNext, Jump_Address => s_JumpAddr,
                                          Jump_Enable => s_JumpEn, Selected_Address => s_SelectedAddr);
    
    -- ROM and Decoder
    U_ROM: Program_ROM port map (program_counter => s_PCCurrent, instruction_out => s_Instruction);
    U_ID: Instruction_Decoder port map (Instruction => s_Instruction, Register_Value_For_Jump => s_OperandA,
                                        Register_Enable => s_RegEn, Register_Select_A => s_RegSelA,
                                        Register_Select_B => s_RegSelB, Operation_Select => s_OpSelect,
                                        Immediate_Value => s_ImmValue, Jump_Enable => s_JumpEn,
                                        Jump_Address => s_JumpAddr, Load_Select => s_LoadSel);
    
    -- Data path
    U_LoadSel: Load_Selector port map (RegisterValue => s_ALUResult, ImmediateValue => s_ImmValue,
                                       LoadSelect => s_LoadSel, OutputData => s_WriteData);
    U_RegBank: Register_Bank port map (Data => s_WriteData, Reset => s_Res, Reg_En => s_RegEn,
                                       Clock => s_SlowClk, Register_Outputs => s_RegFileOutputs);
    U_MuxA: RegisterData_Multiplexer port map (DataSources => s_RegFileOutputs, SelectAddress => s_RegSelA,
                                               OutputData => s_OperandA);
    U_MuxB: RegisterData_Multiplexer port map (DataSources => s_RegFileOutputs, SelectAddress => s_RegSelB,
                                               OutputData => s_OperandB);
    U_ALU: Add_Sub_4bit port map (Input_A => s_OperandA, Input_B => s_OperandB, Mode_Sel => s_OpSelect,
                                  Result => s_ALUResult, Zero_Flag => s_Zero, Overflow_Flag => s_Overflow);
    
    -- Outputs
    Data <= s_RegFileOutputs(7);
    Zero <= s_Zero;
    Overflow <= s_Overflow;
    
    -- 7-segment display (shows R7 value)
    U_7Seg: LUT_16_7 port map (I => s_RegFileOutputs(7), O => S_7Seg);
    anode <= "1110";  -- Enable only first digit
    
end Structural;