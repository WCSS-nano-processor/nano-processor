----------------------------------------------------------------------------------
-- TOP NANOPROCESSOR - 14-BIT EXTENDED ISA (COMPLETE FIXED VERSION)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Top_NanoProcessor_14bit is
    port( Clock      : in  STD_LOGIC;
          Reset      : in  STD_LOGIC;      -- BTNC
          Store_Btn  : in  STD_LOGIC;      -- BTNR (Execute)
          Toggle_Btn : in  STD_LOGIC;      -- BTNL (Toggle display)
          Switches   : in  STD_LOGIC_VECTOR(15 downto 0);
          Overflow   : out STD_LOGIC;
          Zero       : out STD_LOGIC;
          CMP_Equal  : out STD_LOGIC;
          CMP_Less   : out STD_LOGIC;
          CMP_Greater : out STD_LOGIC;
          S_7Seg     : out STD_LOGIC_VECTOR(6 downto 0);
          anode      : out STD_LOGIC_VECTOR(3 downto 0);
          Data       : out DataBus);
end Top_NanoProcessor_14bit;

architecture Structural of Top_NanoProcessor_14bit is
    signal s_Mode : STD_LOGIC;
    signal s_R7_Value : DataBus;
    signal s_Zero, s_Overflow : STD_LOGIC;
    signal s_CMP_Equal, s_CMP_Less, s_CMP_Greater : STD_LOGIC;
    signal s_DisplayValue : DataBus;
    signal s_DisplayMode : STD_LOGIC := '0';
    signal s_Toggle_prev : STD_LOGIC := '0';
    signal s_Toggle_pulse : STD_LOGIC := '0';
    
    -- Store button edge detection signals
    signal store_prev : STD_LOGIC := '0';
    signal store_pulse : STD_LOGIC := '0';
    
    -- ROM Mode signals
    signal s_SlowClk : STD_LOGIC;
    signal s_Res : STD_LOGIC;
    signal s_PCCurrent : ProgramCounter;
    signal s_PCNext : ProgramCounter;
    signal s_JumpAddr : ProgramCounter;
    signal s_JumpEn : STD_LOGIC;
    signal s_SelectedAddr : ProgramCounter;
    signal s_Instruction : InstructionWord;
    signal s_RegEn : RegisterSelect;
    signal s_RegSelA : RegisterSelect;
    signal s_RegSelB : RegisterSelect;
    signal s_ALU_Op_Sel : ALU_Op_Select;
    signal s_ImmValue : DataBus;
    signal s_LoadSel : STD_LOGIC;
    signal s_InputEn : STD_LOGIC;
    signal s_RegFileOutputs : RegisterFile;
    signal s_OperandA, s_OperandB : DataBus;
    signal s_ALUResult : DataBus;
    signal s_WriteData : DataBus;
    signal s_InputData : DataBus;
    signal rom_r7 : DataBus;
    signal rom_zero, rom_overflow : STD_LOGIC;
    signal rom_cmp_eq, rom_cmp_lt, rom_cmp_gt : STD_LOGIC;
    
    -- Manual Mode signals
    signal manual_regs : RegisterFile := (others => (others => '0'));
    signal manual_r7 : DataBus;
    
    -- Manual mode decoded signals
    signal manual_opcode : std_logic_vector(3 downto 0);
    signal manual_R1 : integer range 0 to 7;
    signal manual_R2 : integer range 0 to 7;
    signal manual_imm : integer range 0 to 15;
    signal manual_alu_op : ALU_Op_Select;
    
    -- Manual mode data to write
    signal manual_write_data : DataBus;
    signal manual_do_write : STD_LOGIC;
    
    -- Manual mode ALU results
    signal manual_alu_result : DataBus;
    signal manual_alu_zero : STD_LOGIC;
    signal manual_alu_overflow : STD_LOGIC;
    signal manual_alu_cmp_eq : STD_LOGIC;
    signal manual_alu_cmp_lt : STD_LOGIC;
    signal manual_alu_cmp_gt : STD_LOGIC;
    
    -- ? FIX: Added missing signal for manual ALU input A
    signal manual_alu_inputA : DataBus;
    
    -- Manual mode output signals
    signal manual_zero : STD_LOGIC;
    signal manual_overflow : STD_LOGIC;
    signal manual_cmp_eq : STD_LOGIC;
    signal manual_cmp_lt : STD_LOGIC;
    signal manual_cmp_gt : STD_LOGIC;
    
    -- Manual mode operand B (properly sized)
    signal manual_operandB : DataBus;
    
    -- Components
    component Slow_Clk
        Generic (SIMULATION_MODE : boolean := false);
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
    
    component Program_ROM_14bit
        port( program_counter : in ProgramCounter; instruction_out : out InstructionWord);
    end component;
    
    component Instruction_Decoder_14bit
        port ( Instruction : in InstructionWord; Register_Value_For_Jump : in DataBus;
               Register_Enable : out RegisterSelect; Register_Select_A : out RegisterSelect;
               Register_Select_B : out RegisterSelect; ALU_Op_Sel : out ALU_Op_Select;
               Immediate_Value : out DataBus; Jump_Enable : out STD_LOGIC;
               Jump_Address : out ProgramCounter; Load_Select : out STD_LOGIC;
               Input_Enable : out STD_LOGIC);
    end component;
    
    component Load_Selector_Input
        Port ( RegisterValue : in DataBus; ImmediateValue : in DataBus;
               InputValue : in DataBus; LoadSelect : in STD_LOGIC;
               InputEnable : in STD_LOGIC; OutputData : out DataBus);
    end component;
    
    component Register_Bank
        Port ( Data : in DataBus; Reset : in STD_LOGIC; Reg_En : in RegisterSelect;
               Clock : in STD_LOGIC; Register_Outputs : out RegisterFile);
    end component;
    
    component RegisterData_Multiplexer
        Port ( DataSources : in RegisterFile; SelectAddress : in RegisterSelect;
               OutputData : out DataBus);
    end component;
    
    component ALU_Extended_14bit
        Port ( Input_A : in DataBus; Input_B : in DataBus; Op_Sel : in ALU_Op_Select;
               Result : out DataBus; Zero_Flag : out STD_LOGIC; Overflow_Flag : out STD_LOGIC;
               CMP_Equal : out STD_LOGIC; CMP_Less : out STD_LOGIC; CMP_Greater : out STD_LOGIC);
    end component;
    
    component Input_Selector
        Port ( Switches : in DataBus; Input_Enable : in STD_LOGIC; OutputData : out DataBus);
    end component;
    
    component Display_Controller
        Port ( clk : in STD_LOGIC; Data_in : in DataBus;
               seg : out STD_LOGIC_VECTOR(6 downto 0); an : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
begin
    s_Mode <= Switches(15);
    s_Res <= Reset;
    
    -- Convert switches to integers for safe indexing
    manual_opcode <= Switches(13 downto 10);
    manual_R1 <= to_integer(unsigned(Switches(9 downto 7)));
    manual_R2 <= to_integer(unsigned(Switches(6 downto 4)));
    manual_imm <= to_integer(unsigned(Switches(3 downto 0)));
    
    -- Properly size manual operand B
    process(Switches, manual_regs, manual_R2, manual_imm)
    begin
        if Switches(14) = '0' then
            -- Register mode: use value from register R2
            if manual_R2 >= 0 and manual_R2 <= 7 then
                manual_operandB <= manual_regs(manual_R2);
            else
                manual_operandB <= (others => '0');
            end if;
        else
            -- Immediate mode: convert integer to 4-bit DataBus
            manual_operandB <= std_logic_vector(to_unsigned(manual_imm, 4));
        end if;
    end process;
    
    -- Check bounds for manual_R1 and assign to manual_alu_inputA
    process(manual_R1, manual_regs)
    begin
        if manual_R1 >= 0 and manual_R1 <= 7 then
            manual_alu_inputA <= manual_regs(manual_R1);
        else
            manual_alu_inputA <= (others => '0');
        end if;
    end process;
    
    -- Store button edge detection (proper style)
    process(Clock)
    begin
        if rising_edge(Clock) then
            store_prev <= Store_Btn;
            store_pulse <= Store_Btn and not store_prev;
        end if;
    end process;
    
    -- Toggle button edge detection
    process(Clock)
    begin
        if rising_edge(Clock) then
            s_Toggle_prev <= Toggle_Btn;
            s_Toggle_pulse <= Toggle_Btn and not s_Toggle_prev;
            if s_Toggle_pulse = '1' then
                s_DisplayMode <= not s_DisplayMode;
            end if;
        end if;
    end process;
    
    -- ============================================================
    -- ROM MODE (SW15 = 0)
    -- ============================================================
    
    U_SlowClk: Slow_Clk 
        generic map (SIMULATION_MODE => false)
        port map (Clk_in => Clock, Clk_out => s_SlowClk);
    
    U_PC: Program_Counter port map (PC_Next => s_SelectedAddr, Res => s_Res, Clk => s_SlowClk, PC_Current => s_PCCurrent);
    U_PC_Adder: PC_Adder port map (current_address => s_PCCurrent, next_address => s_PCNext);
    U_AddrSel: Address_Selector port map (Sequential_Address => s_PCNext, Jump_Address => s_JumpAddr,
                                          Jump_Enable => s_JumpEn, Selected_Address => s_SelectedAddr);
    
    U_ROM: Program_ROM_14bit port map (program_counter => s_PCCurrent, instruction_out => s_Instruction);
    U_ID: Instruction_Decoder_14bit port map (Instruction => s_Instruction, Register_Value_For_Jump => s_OperandA,
                                              Register_Enable => s_RegEn, Register_Select_A => s_RegSelA,
                                              Register_Select_B => s_RegSelB, ALU_Op_Sel => s_ALU_Op_Sel,
                                              Immediate_Value => s_ImmValue, Jump_Enable => s_JumpEn,
                                              Jump_Address => s_JumpAddr, Load_Select => s_LoadSel,
                                              Input_Enable => s_InputEn);
    
    U_Input: Input_Selector port map (Switches => Switches(3 downto 0), Input_Enable => s_InputEn, OutputData => s_InputData);
    
    U_LoadSel: Load_Selector_Input port map (RegisterValue => s_ALUResult, ImmediateValue => s_ImmValue,
                                             InputValue => s_InputData, LoadSelect => s_LoadSel,
                                             InputEnable => s_InputEn, OutputData => s_WriteData);
    
    U_RegBank: Register_Bank port map (Data => s_WriteData, Reset => s_Res, Reg_En => s_RegEn,
                                       Clock => s_SlowClk, Register_Outputs => s_RegFileOutputs);
    
    U_MuxA: RegisterData_Multiplexer port map (DataSources => s_RegFileOutputs, SelectAddress => s_RegSelA, OutputData => s_OperandA);
    U_MuxB: RegisterData_Multiplexer port map (DataSources => s_RegFileOutputs, SelectAddress => s_RegSelB, OutputData => s_OperandB);
    
    U_ALU: ALU_Extended_14bit port map (Input_A => s_OperandA, Input_B => s_OperandB, Op_Sel => s_ALU_Op_Sel,
                                        Result => s_ALUResult, Zero_Flag => rom_zero, Overflow_Flag => rom_overflow,
                                        CMP_Equal => rom_cmp_eq, CMP_Less => rom_cmp_lt, CMP_Greater => rom_cmp_gt);
    
    rom_r7 <= s_RegFileOutputs(7);
    
    -- ============================================================
    -- MANUAL MODE (SW15 = 1)
    -- ============================================================
    
    -- Determine ALU operation based on manual opcode
    process(manual_opcode)
    begin
        case manual_opcode is
            when "0001" => manual_alu_op <= ALU_ADD;
            when "0010" => manual_alu_op <= ALU_SUB;
            when "0011" => manual_alu_op <= ALU_NEG;
            when "0110" => manual_alu_op <= ALU_MUL;
            when "0111" => manual_alu_op <= ALU_AND;
            when "1000" => manual_alu_op <= ALU_OR;
            when "1001" => manual_alu_op <= ALU_XOR;
            when "1010" => manual_alu_op <= ALU_NOT;
            when "1011" => manual_alu_op <= ALU_CMP;
            when others => manual_alu_op <= ALU_ADD;
        end case;
    end process;
    
    -- ALU for arithmetic/logic operations
    U_Manual_ALU: ALU_Extended_14bit port map (
        Input_A => manual_alu_inputA,
        Input_B => manual_operandB,
        Op_Sel => manual_alu_op,
        Result => manual_alu_result,
        Zero_Flag => manual_alu_zero,
        Overflow_Flag => manual_alu_overflow,
        CMP_Equal => manual_alu_cmp_eq,
        CMP_Less => manual_alu_cmp_lt,
        CMP_Greater => manual_alu_cmp_gt);
    
    -- Determine what value to write based on opcode
    process(manual_opcode, manual_imm, Switches, manual_alu_result)
    begin
        -- Default values
        manual_write_data <= (others => '0');
        manual_do_write <= '0';
        
        -- MOVI: use immediate value directly (NO ALU!)
        if manual_opcode = "0000" then
            manual_write_data <= std_logic_vector(to_unsigned(manual_imm, 4));
            manual_do_write <= '1';
            
        -- IN: use switch value directly (NO ALU!)
        elsif manual_opcode = "0101" then
            manual_write_data <= Switches(3 downto 0);
            manual_do_write <= '1';
            
        -- CMP: do NOT write to register!
        elsif manual_opcode = "1011" then
            manual_write_data <= (others => '0');
            manual_do_write <= '0';
            
        -- ADD, SUB, MUL, AND, OR, XOR, NOT, etc.
        else
            manual_write_data <= manual_alu_result;
            manual_do_write <= '1';
        end if;
    end process;
    
    -- Manual mode flags (from CMP or ALU)
    process(manual_opcode, manual_alu_cmp_eq, manual_alu_cmp_lt, manual_alu_cmp_gt,
            manual_alu_zero, manual_alu_overflow)
    begin
        -- Default values
        manual_cmp_eq <= '0';
        manual_cmp_lt <= '0';
        manual_cmp_gt <= '0';
        manual_zero <= '0';
        manual_overflow <= '0';
        
        if manual_opcode = "1011" then
            -- CMP instruction: use comparison flags from ALU
            manual_cmp_eq <= manual_alu_cmp_eq;
            manual_cmp_lt <= manual_alu_cmp_lt;
            manual_cmp_gt <= manual_alu_cmp_gt;
        else
            -- Normal ALU operations: use zero/overflow flags
            manual_zero <= manual_alu_zero;
            manual_overflow <= manual_alu_overflow;
        end if;
    end process;
    
    -- Manual mode register storage (using proper edge detection)
    process(Clock, Reset)
    begin
        if Reset = '1' then
            for i in 0 to 7 loop
                manual_regs(i) <= (others => '0');
            end loop;
        elsif rising_edge(Clock) then
            if store_pulse = '1' and manual_do_write = '1' and manual_R1 >= 0 and manual_R1 <= 7 then
                manual_regs(manual_R1) <= manual_write_data;
            end if;
        end if;
    end process;
    
    manual_r7 <= manual_regs(7);
    
    -- ============================================================
    -- OUTPUTS
    -- ============================================================
    
    -- Select R7 value based on mode
    s_R7_Value <= rom_r7 when s_Mode = '0' else manual_r7;
    s_Zero <= rom_zero when s_Mode = '0' else manual_zero;
    s_Overflow <= rom_overflow when s_Mode = '0' else manual_overflow;
    s_CMP_Equal <= rom_cmp_eq when s_Mode = '0' else manual_cmp_eq;
    s_CMP_Less <= rom_cmp_lt when s_Mode = '0' else manual_cmp_lt;
    s_CMP_Greater <= rom_cmp_gt when s_Mode = '0' else manual_cmp_gt;
    
    Data <= s_R7_Value;
    Zero <= s_Zero;
    Overflow <= s_Overflow;
    CMP_Equal <= s_CMP_Equal;
    CMP_Less <= s_CMP_Less;
    CMP_Greater <= s_CMP_Greater;
    
    -- Display selection (BTNL toggles)
    s_DisplayValue <= Switches(3 downto 0) when s_DisplayMode = '1' else s_R7_Value;
    
    U_Display: Display_Controller port map (clk => Clock, Data_in => s_DisplayValue, seg => S_7Seg, an => anode);
    
end Structural;