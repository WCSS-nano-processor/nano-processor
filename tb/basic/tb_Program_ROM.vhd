----------------------------------------------------------------------------------
-- Testbench for Program ROM
-- Program: 1 + 2 + 3 = 6 stored in R7
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity tb_Program_ROM is
end tb_Program_ROM;

architecture Behavioral of tb_Program_ROM is
    component Program_ROM
        port( program_counter : in ProgramCounter;
              instruction_out : out InstructionWord);
    end component;
    
    signal addr : ProgramCounter;
    signal instr : InstructionWord;
    
begin
    UUT: Program_ROM port map (program_counter => addr, instruction_out => instr);
    
    process
    begin
        report "Testing Program ROM - 1+2+3=6 program";
        
        -- Test all addresses
        for i in 0 to 7 loop
            addr <= std_logic_vector(to_unsigned(i, 3));
            wait for 20 ns;
            report "Addr=" & integer'image(i) & " Instruction=" & 
                   std_logic'image(instr(11)) & 
                   std_logic'image(instr(10)) & 
                   std_logic'image(instr(9)) & 
                   std_logic'image(instr(8)) & 
                   std_logic'image(instr(7)) & 
                   std_logic'image(instr(6)) & 
                   std_logic'image(instr(5)) & 
                   std_logic'image(instr(4)) & 
                   std_logic'image(instr(3)) & 
                   std_logic'image(instr(2)) & 
                   std_logic'image(instr(1)) & 
                   std_logic'image(instr(0));
        end loop;
        
        report "Program_ROM Tests Complete!";
        wait;
    end process;
end Behavioral;
