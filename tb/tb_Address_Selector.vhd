----------------------------------------------------------------------------------
-- Testbench for Address Selector (2-way 3-bit Mux)
-- Using LAST 3 BITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Address_Selector is
end tb_Address_Selector;

architecture Behavioral of tb_Address_Selector is
    component Address_Selector
        port ( Sequential_Address, Jump_Address : in ProgramCounter;
               Jump_Enable : in std_logic;
               Selected_Address : out ProgramCounter);
    end component;
    
    signal Seq_Addr, Jump_Addr, Selected : ProgramCounter;
    signal Jump_En : std_logic;
    
begin
    UUT: Address_Selector port map (
        Sequential_Address => Seq_Addr,
        Jump_Address => Jump_Addr,
        Jump_Enable => Jump_En,
        Selected_Address => Selected
    );
    
    process
    begin
        report "Testing Address Selector with Team Index Bits";
        
        -- Test1: Jump_Enable=0 -> select Sequential
        report "Test1: Jump=0 -> Output = Sequential(010=2)";
        Seq_Addr <= "010"; Jump_Addr <= "100"; Jump_En <= '0';
        wait for 20 ns;
        
        -- Test2: Jump_Enable=1 -> select Jump
        report "Test2: Jump=1 -> Output = Jump(100=4)";
        Jump_En <= '1';
        wait for 20 ns;
        
        -- Test3: Different values
        report "Test3: Sequential=101(5), Jump=011(3)";
        Seq_Addr <= "101"; Jump_Addr <= "011";
        Jump_En <= '0';
        wait for 20 ns;
        Jump_En <= '1';
        wait for 20 ns;
        
        report "Address_Selector Tests Complete!";
        wait;
    end process;
end Behavioral;
