----------------------------------------------------------------------------------
-- Testbench for Program ROM
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity tb_Program_ROM is
end tb_Program_ROM;

architecture Behavioral of tb_Program_ROM is
    component Program_ROM
        port( program_counter : in ProgramCounter; instruction_out : out InstructionWord);
    end component;
    
    signal addr : ProgramCounter := "000";
    signal instr : InstructionWord;
    
    type expected_array is array (0 to 7) of InstructionWord;
    constant expected : expected_array := (
        "101110000000", -- MOVI R7, 0
        "100010000001", -- MOVI R1, 1
        "100100000010", -- MOVI R2, 2
        "100110000011", -- MOVI R3, 3
        "001110010000", -- ADD R7, R1
        "001110100000", -- ADD R7, R2
        "001110110000", -- ADD R7, R3
        "110000000100"  -- JZR R0, 4
    );
    
begin
    UUT: Program_ROM port map (program_counter => addr, instruction_out => instr);
    
    process
    begin
        for i in 0 to 7 loop
            addr <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
            assert instr = expected(i) report "ROM mismatch at address " & integer'image(i) severity error;
        end loop;
        wait;
    end process;
end Behavioral;