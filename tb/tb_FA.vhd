----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 02:59:54 PM
-- Design Name: 
-- Module Name: tb_FA - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


----------------------------------------------------------------------------------
-- Testbench for Full Adder (FA)
-- Using index number 240066 bits for test values
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_FA is
end tb_FA;

architecture Behavioral of tb_FA is
    component FA
        Port ( A     : in  STD_LOGIC;
               B     : in  STD_LOGIC;
               C_in  : in  STD_LOGIC;
               S     : out STD_LOGIC;
               C_out : out STD_LOGIC);
    end component;
    
    signal A, B, C_in : STD_LOGIC;
    signal S, C_out : STD_LOGIC;
    
    -- From index 240066: bits 0,1,2,3 = 0010
    constant TEST_BIT_A : STD_LOGIC := '0';  -- bit 0
    constant TEST_BIT_B : STD_LOGIC := '0';  -- bit 1
    constant TEST_BIT_C : STD_LOGIC := '1';  -- bit 2
    
begin
    UUT: FA port map (
        A => A,
        B => B,
        C_in => C_in,
        S => S,
        C_out => C_out
    );
    
    process
    begin
        report "=== Testing Full Adder with Index 240066 values ===";
        
        -- Test 1: Using your index bits: A=0, B=0, Cin=1
        report "Test 1: 0 + 0 + 1 = 1, carry 0";
        A <= TEST_BIT_A; B <= TEST_BIT_B; C_in <= TEST_BIT_C;
        wait for 10 ns;
        
        -- Test 2: A=1 (from index bit 3), B=0, Cin=0
        report "Test 2: 1 + 0 + 0 = 1, carry 0";
        A <= '1'; B <= '0'; C_in <= '0';
        wait for 10 ns;
        
        -- Test 3: A=1, B=1, Cin=0 (from index bits)
        report "Test 3: 1 + 1 + 0 = 0, carry 1";
        A <= '1'; B <= '1'; C_in <= '0';
        wait for 10 ns;
        
        -- Test 4: A=1, B=0, Cin=1
        report "Test 4: 1 + 0 + 1 = 0, carry 1";
        A <= '1'; B <= '0'; C_in <= '1';
        wait for 10 ns;
        
        -- Test 5: A=1, B=1, Cin=1
        report "Test 5: 1 + 1 + 1 = 1, carry 1";
        A <= '1'; B <= '1'; C_in <= '1';
        wait for 10 ns;
        
        -- Test 6: A=0, B=1, Cin=0
        report "Test 6: 0 + 1 + 0 = 1, carry 0";
        A <= '0'; B <= '1'; C_in <= '0';
        wait for 10 ns;
        
        report "=== FA Tests Completed ===";
        wait;
    end process;
    
end Behavioral;
