----------------------------------------------------------------------------------
-- Testbench for 14-bit Instruction Decoder
-- Tests all extended instructions: MOVI, ADD, SUB, NEG, JZR, IN, MUL, AND, OR, XOR, NOT, CMP
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity tb_Instruction_Decoder_14bit is
end tb_Instruction_Decoder_14bit;

architecture Behavioral of tb_Instruction_Decoder_14bit is
    component Instruction_Decoder_14bit
        port ( Instruction : in InstructionWord;
               Register_Value_For_Jump : in DataBus;
               Register_Enable : out RegisterSelect;
               Register_Select_A : out RegisterSelect;
               Register_Select_B : out RegisterSelect;
               ALU_Op_Sel : out ALU_Op_Select;
               Immediate_Value : out DataBus;
               Jump_Enable : out STD_LOGIC;
               Jump_Address : out ProgramCounter;
               Load_Select : out STD_LOGIC;
               Input_Enable : out STD_LOGIC);
    end component;
    
    signal Instruction : InstructionWord;
    signal RegValJump : DataBus;
    signal RegEn, RegSelA, RegSelB, JumpAddr : RegisterSelect;
    signal ALU_Op : ALU_Op_Select;
    signal ImmVal : DataBus;
    signal JumpEn, LoadSel, InputEn : STD_LOGIC;
    
    -- Test values from team index last 4 bits
    constant TEST_R1 : RegisterSelect := "001";  -- R1
    constant TEST_R2 : RegisterSelect := "010";  -- R2
    constant TEST_IMM : DataBus := "0010";       -- 2
    constant TEST_JUMP : ProgramCounter := "101"; -- 5
    
begin
    UUT: Instruction_Decoder_14bit port map (
        Instruction => Instruction,
        Register_Value_For_Jump => RegValJump,
        Register_Enable => RegEn,
        Register_Select_A => RegSelA,
        Register_Select_B => RegSelB,
        ALU_Op_Sel => ALU_Op,
        Immediate_Value => ImmVal,
        Jump_Enable => JumpEn,
        Jump_Address => JumpAddr,
        Load_Select => LoadSel,
        Input_Enable => InputEn
    );
    
    process
    begin
        report "==========================================================";
        report "Testing 14-bit Instruction Decoder";
        report "==========================================================";
        
        -- Test1: MOVI R1, 2 (0000 001 000 0010)
        report "Test1: MOVI R1, 2";
        Instruction <= "0000" & TEST_R1 & "000" & TEST_IMM;
        wait for 20 ns;
        
        -- Test2: ADD R1, R2 (0001 001 010 0000)
        report "Test2: ADD R1, R2";
        Instruction <= "0001" & TEST_R1 & TEST_R2 & "0000";
        wait for 20 ns;
        
        -- Test3: SUB R1, R2 (0010 001 010 0000)
        report "Test3: SUB R1, R2";
        Instruction <= "0010" & TEST_R1 & TEST_R2 & "0000";
        wait for 20 ns;
        
        -- Test4: NEG R1 (0011 001 000 0000)
        report "Test4: NEG R1";
        Instruction <= "0011" & TEST_R1 & "000" & "0000";
        wait for 20 ns;
        
        -- Test5: JZR R0, 5 (0100 000 000 0101) - with R0=0
        report "Test5: JZR R0, 5 (Jump enabled)";
        RegValJump <= "0000";
        Instruction <= "0100" & "000" & "000" & "0" & TEST_JUMP;
        wait for 20 ns;
        
        -- Test6: JZR R1, 5 (with R1/=0 - no jump)
        report "Test6: JZR R1, 5 (R1/=0, no jump)";
        RegValJump <= "0001";
        Instruction <= "0100" & TEST_R1 & "000" & "0" & TEST_JUMP;
        wait for 20 ns;
        
        -- Test7: IN R1 (0101 001 000 0000)
        report "Test7: IN R1";
        Instruction <= "0101" & TEST_R1 & "000" & "0000";
        wait for 20 ns;
        
        -- Test8: MUL R1, R2 (0110 001 010 0000)
        report "Test8: MUL R1, R2";
        Instruction <= "0110" & TEST_R1 & TEST_R2 & "0000";
        wait for 20 ns;
        
        -- Test9: AND R1, R2 (0111 001 010 0000)
        report "Test9: AND R1, R2";
        Instruction <= "0111" & TEST_R1 & TEST_R2 & "0000";
        wait for 20 ns;
        
        -- Test10: OR R1, R2 (1000 001 010 0000)
        report "Test10: OR R1, R2";
        Instruction <= "1000" & TEST_R1 & TEST_R2 & "0000";
        wait for 20 ns;
        
        -- Test11: XOR R1, R2 (1001 001 010 0000)
        report "Test11: XOR R1, R2";
        Instruction <= "1001" & TEST_R1 & TEST_R2 & "0000";
        wait for 20 ns;
        
        -- Test12: NOT R1 (1010 001 000 0000)
        report "Test12: NOT R1";
        Instruction <= "1010" & TEST_R1 & "000" & "0000";
        wait for 20 ns;
        
        -- Test13: CMP R1, R2 (1011 001 010 0000)
        report "Test13: CMP R1, R2 (No register write)";
        Instruction <= "1011" & TEST_R1 & TEST_R2 & "0000";
        wait for 20 ns;
        
        report "==========================================================";
        report "Instruction Decoder Tests Complete!";
        report "==========================================================";
        wait;
    end process;
end Behavioral;
