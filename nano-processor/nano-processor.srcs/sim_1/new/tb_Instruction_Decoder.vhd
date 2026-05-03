----------------------------------------------------------------------------------
-- Testbench for Instruction Decoder
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity tb_Instruction_Decoder is
end tb_Instruction_Decoder;

architecture Behavioral of tb_Instruction_Decoder is
    component Instruction_Decoder
        port ( Instruction : in InstructionWord; Register_Value_For_Jump : in DataBus;
               Register_Enable : out RegisterSelect; Register_Select_A : out RegisterSelect;
               Register_Select_B : out RegisterSelect; Operation_Select : out STD_LOGIC;
               Immediate_Value : out DataBus; Jump_Enable : out STD_LOGIC;
               Jump_Address : out ProgramCounter; Load_Select : out STD_LOGIC);
    end component;
    
    signal Instruction : InstructionWord;
    signal RegValForJump : DataBus;
    signal RegEn, RegSelA, RegSelB, JumpAddr : RegisterSelect;
    signal OpSelect, JumpEn, LoadSel : STD_LOGIC;
    signal ImmVal : DataBus;
    
begin
    UUT: Instruction_Decoder port map (Instruction => Instruction, Register_Value_For_Jump => RegValForJump,
                                       Register_Enable => RegEn, Register_Select_A => RegSelA,
                                       Register_Select_B => RegSelB, Operation_Select => OpSelect,
                                       Immediate_Value => ImmVal, Jump_Enable => JumpEn,
                                       Jump_Address => JumpAddr, Load_Select => LoadSel);
    
    process
    begin
        -- Test MOVI R3, 10
        Instruction <= "100110001010";
        wait for 10 ns;
        
        -- Test ADD R1, R2
        Instruction <= "000010100000";
        wait for 10 ns;
        
        -- Test NEG R4
        Instruction <= "011000000000";
        wait for 10 ns;
        
        -- Test JZR R2, 5 (with zero condition)
        Instruction <= "110100000101";
        RegValForJump <= "0000";
        wait for 10 ns;
        
        -- Test JZR R2, 5 (with non-zero condition)
        RegValForJump <= "0101";
        wait for 10 ns;
        
        wait;
    end process;
end Behavioral;