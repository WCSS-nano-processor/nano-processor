----------------------------------------------------------------------------------
-- Testbench for Full Adder (FA)
-- Simple test using LAST 4 BINARY DIGITS of team index numbers
-- Member1(240066): 0010
-- Member2(240060): 1100
-- Member3(240061): 1101
-- Member4(240092): 1100
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_FA is
end tb_FA;

architecture Behavioral of tb_FA is
    -- Component declaration
    component FA
        Port ( A, B, C_in : in STD_LOGIC;
               S, C_out : out STD_LOGIC);
    end component;
    
    -- Test signals
    signal A, B, C_in, S, C_out : STD_LOGIC;
    
begin
    -- Instantiate Full Adder
    UUT: FA port map (
        A => A, 
        B => B, 
        C_in => C_in,
        S => S, 
        C_out => C_out
    );
    
    -- Test process
    process
    begin
        report "Testing Full Adder with Team Index Bits";
        
        -- Test 1: Member1 bits (from 0010: A=0, B=0, Cin=1)
        report "Test1: 0 + 0 + 1 = 1, carry 0";
        A <= '0'; B <= '0'; C_in <= '1';
        wait for 20 ns;
        
        -- Test 2: Member2 bits (from 1100: A=1, B=1, Cin=0)
        report "Test2: 1 + 1 + 0 = 0, carry 1";
        A <= '1'; B <= '1'; C_in <= '0';
        wait for 20 ns;
        
        -- Test 3: Member3 bits (from 1101: A=1, B=0, Cin=1)
        report "Test3: 1 + 0 + 1 = 0, carry 1";
        A <= '1'; B <= '0'; C_in <= '1';
        wait for 20 ns;
        
        -- Test 4: Member4 bits (from 1100: A=1, B=1, Cin=0)
        report "Test4: 1 + 1 + 0 = 0, carry 1";
        A <= '1'; B <= '1'; C_in <= '0';
        wait for 20 ns;
        
        -- Test 5: All zeros
        report "Test5: 0 + 0 + 0 = 0, carry 0";
        A <= '0'; B <= '0'; C_in <= '0';
        wait for 20 ns;
        
        -- Test 6: All ones
        report "Test6: 1 + 1 + 1 = 1, carry 1";
        A <= '1'; B <= '1'; C_in <= '1';
        wait for 20 ns;
        
        report "FA Tests Complete!";
        wait;
    end process;
end Behavioral;
