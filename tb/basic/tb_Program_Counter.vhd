----------------------------------------------------------------------------------
-- Testbench for Program Counter
-- Using LAST 3 BITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Program_Counter is
end tb_Program_Counter;

architecture Behavioral of tb_Program_Counter is
    component Program_Counter
        Port ( PC_Next : in ProgramCounter;
               Res, Clk : in STD_LOGIC;
               PC_Current : out ProgramCounter);
    end component;
    
    signal PC_Next, PC_Current : ProgramCounter;
    signal Res, Clk : STD_LOGIC := '0';
    constant CLK_PERIOD : time := 20 ns;
    
begin
    UUT: Program_Counter port map (PC_Next => PC_Next, Res => Res, Clk => Clk, PC_Current => PC_Current);
    
    Clk <= not Clk after CLK_PERIOD/2;
    
    process
    begin
        report "Testing Program Counter with Team Index Bits";
        
        -- Reset test
        report "Test1: Reset -> PC=000";
        Res <= '1';
        wait for CLK_PERIOD;
        Res <= '0';
        
        -- Load Member1 value (010=2)
        report "Test2: Load Member1(010=2)";
        PC_Next <= "010";
        wait for CLK_PERIOD;
        
        -- Load Member2 value (100=4)
        report "Test3: Load Member2(100=4)";
        PC_Next <= "100";
        wait for CLK_PERIOD;
        
        -- Load Member3 value (101=5)
        report "Test4: Load Member3(101=5)";
        PC_Next <= "101";
        wait for CLK_PERIOD;
        
        -- Load Member4 value (100=4)
        report "Test5: Load Member4(100=4)";
        PC_Next <= "100";
        wait for CLK_PERIOD;
        
        -- Reset during operation
        report "Test6: Reset during operation";
        Res <= '1';
        wait for CLK_PERIOD;
        
        report "Program_Counter Tests Complete!";
        wait;
    end process;
end Behavioral;
