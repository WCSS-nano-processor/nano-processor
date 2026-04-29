----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 03:14:25 PM
-- Design Name: 
-- Module Name: tb_RCA_4 - Behavioral
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
-- Testbench for 4-bit Ripple Carry Adder (RCA_4)
-- Using index number 240066 (111010100111000010) for test values
-- Test values: 0010 (2), 0000 (0), 0111 (7), 1010 (10), 0011 (3)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_RCA_4 is
end tb_RCA_4;

architecture Behavioral of tb_RCA_4 is
    component RCA_4
        Port ( A0, A1, A2, A3 : in  STD_LOGIC;
               B0, B1, B2, B3 : in  STD_LOGIC;
               C_in           : in  STD_LOGIC;
               S0, S1, S2, S3 : out STD_LOGIC;
               C_out          : out STD_LOGIC);
    end component;
    
    signal A, B, S : STD_LOGIC_VECTOR(3 downto 0);
    signal C_in, C_out : STD_LOGIC;
    
    -- Values from index 240066
    constant VAL_A : STD_LOGIC_VECTOR(3 downto 0) := "0010";  -- 2 (bits 0-3)
    constant VAL_B : STD_LOGIC_VECTOR(3 downto 0) := "0000";  -- 0 (bits 4-7)
    constant VAL_C : STD_LOGIC_VECTOR(3 downto 0) := "0111";  -- 7 (bits 8-11)
    constant VAL_D : STD_LOGIC_VECTOR(3 downto 0) := "1010";  -- 10 (bits 12-15)
    constant VAL_E : STD_LOGIC_VECTOR(3 downto 0) := "0011";  -- 3 (bits 16-17 padded)
    
begin
    UUT: RCA_4 port map (
        A0 => A(0), A1 => A(1), A2 => A(2), A3 => A(3),
        B0 => B(0), B1 => B(1), B2 => B(2), B3 => B(3),
        C_in => C_in,
        S0 => S(0), S1 => S(1), S2 => S(2), S3 => S(3),
        C_out => C_out
    );
    
    process
    begin
        report "=== Testing RCA_4 with Index 240066 values ===";
        report "Index 240066 binary: 111010100111000010";
        report "Test values: A=0010(2), B=0000(0), C=0111(7), D=1010(10), E=0011(3)";
        
        -- Test 1: VAL_A + VAL_B = 2 + 0 = 2
        report "Test 1: 2 + 0 = 2 (from index bits 0-7)";
        A <= VAL_A; B <= VAL_B; C_in <= '0';
        wait for 10 ns;
        
        -- Test 2: VAL_C + VAL_D = 7 + 10 = 17 (carry out)
        report "Test 2: 7 + 10 = 17 (carry out expected)";
        A <= VAL_C; B <= VAL_D; C_in <= '0';
        wait for 10 ns;
        
        -- Test 3: VAL_A + VAL_E = 2 + 3 = 5
        report "Test 3: 2 + 3 = 5";
        A <= VAL_A; B <= VAL_E; C_in <= '0';
        wait for 10 ns;
        
        -- Test 4: VAL_D + VAL_D = 10 + 10 = 20 (carry out)
        report "Test 4: 10 + 10 = 20 (carry out expected)";
        A <= VAL_D; B <= VAL_D; C_in <= '0';
        wait for 10 ns;
        
        -- Test 5: VAL_C + VAL_E = 7 + 3 = 10
        report "Test 5: 7 + 3 = 10";
        A <= VAL_C; B <= VAL_E; C_in <= '0';
        wait for 10 ns;
        
        -- Test 6: VAL_B + VAL_B = 0 + 0 = 0
        report "Test 6: 0 + 0 = 0";
        A <= VAL_B; B <= VAL_B; C_in <= '0';
        wait for 10 ns;
        
        report "=== RCA_4 Tests Completed ===";
        wait;
    end process;
    
end Behavioral;