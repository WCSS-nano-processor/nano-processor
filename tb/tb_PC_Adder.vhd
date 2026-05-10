----------------------------------------------------------------------------------
-- Testbench for PC Adder (3-bit)
-- Using LAST 3 BITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_PC_Adder is
end tb_PC_Adder;

architecture Behavioral of tb_PC_Adder is
    component PC_Adder
        port ( current_address : in ProgramCounter;
               next_address : out ProgramCounter);
    end component;
    
    signal current_addr, next_addr : ProgramCounter;
    
begin
    UUT: PC_Adder port map (current_address => current_addr, next_address => next_addr);
    
    process
    begin
        report "Testing PC Adder with Team Index Bits";
        
        -- Test1: Member1(2) + 1 = 3
        report "Test1: 2 + 1 = 3";
        current_addr <= "010";
        wait for 20 ns;
        
        -- Test2: Member2(4) + 1 = 5
        report "Test2: 4 + 1 = 5";
        current_addr <= "100";
        wait for 20 ns;
        
        -- Test3: Member3(5) + 1 = 6
        report "Test3: 5 + 1 = 6";
        current_addr <= "101";
        wait for 20 ns;
        
        -- Test4: Member4(4) + 1 = 5
        report "Test4: 4 + 1 = 5";
        current_addr <= "100";
        wait for 20 ns;
        
        -- Test5: 7 + 1 = 0 (wrap around)
        report "Test5: 7 + 1 = 0 (wrap)";
        current_addr <= "111";
        wait for 20 ns;
        
        -- Test6: 0 + 1 = 1
        report "Test6: 0 + 1 = 1";
        current_addr <= "000";
        wait for 20 ns;
        
        report "PC_Adder Tests Complete!";
        wait;
    end process;
end Behavioral;
