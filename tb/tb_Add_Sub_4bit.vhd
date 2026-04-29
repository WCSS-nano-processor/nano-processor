----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 05:55:39 PM
-- Design Name: 
-- Module Name: tb_Add_Sub_4bit - Behavioral
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
-- Testbench for 4-bit Add/Subtract Unit
-- Using index number 240066 (111010100111000010)
-- Tests addition, subtraction, overflow, and zero flag
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Add_Sub_4bit is
end tb_Add_Sub_4bit;

architecture Behavioral of tb_Add_Sub_4bit is
    component Add_Sub_4bit
        Port ( Input_A     : in  DataBus;
               Input_B     : in  DataBus;
               Mode_Sel    : in  STD_LOGIC;
               Result      : out DataBus;
               Zero_Flag   : out STD_LOGIC;
               Overflow_Flag : out STD_LOGIC);
    end component;
    
    signal A, B, Result : DataBus;
    signal Mode_Sel, Zero_Flag, Overflow_Flag : STD_LOGIC;
    
    -- Values from index 240066 (111010100111000010)
    constant VAL_INDEX_1 : DataBus := "0010";  -- bits 0-3: 2
    constant VAL_INDEX_2 : DataBus := "0000";  -- bits 4-7: 0
    constant VAL_INDEX_3 : DataBus := "0111";  -- bits 8-11: 7
    constant VAL_INDEX_4 : DataBus := "1010";  -- bits 12-15: 10 (-6 in signed)
    constant VAL_INDEX_5 : DataBus := "0011";  -- bits 16-17 padded: 3
    
begin
    UUT: Add_Sub_4bit port map (
        Input_A => A,
        Input_B => B,
        Mode_Sel => Mode_Sel,
        Result => Result,
        Zero_Flag => Zero_Flag,
        Overflow_Flag => Overflow_Flag
    );
    
    process
    begin
        report "========================================";
        report "Testing Add_Sub_4bit with Index: 240066";
        report "Binary: 111010100111000010";
        report "========================================";
        
        -- ========== ADDITION TESTS (Mode_Sel = '0') ==========
        
        -- Test A1: VAL_INDEX_1 + VAL_INDEX_2 = 2 + 0 = 2
        report "Test A1: 2 + 0 = 2";
        A <= VAL_INDEX_1; B <= VAL_INDEX_2; Mode_Sel <= '0';
        wait for 10 ns;
        
        -- Test A2: VAL_INDEX_3 + VAL_INDEX_5 = 7 + 3 = 10 (1010)
        report "Test A2: 7 + 3 = 10";
        A <= VAL_INDEX_3; B <= VAL_INDEX_5; Mode_Sel <= '0';
        wait for 10 ns;
        
        -- Test A3: VAL_INDEX_4 (as signed -6) + VAL_INDEX_1 = -6 + 2 = -4 (1100)
        report "Test A3: (-6) + 2 = -4 (signed addition)";
        A <= VAL_INDEX_4; B <= VAL_INDEX_1; Mode_Sel <= '0';
        wait for 10 ns;
        
        -- Test A4: 7 + 1 = 8 (overflow test - should show overflow)
        report "Test A4: 7 + 1 = 8 (overflow expected)";
        A <= "0111"; B <= "0001"; Mode_Sel <= '0';
        wait for 10 ns;
        
        -- Test A5: VAL_INDEX_4 (as signed -6) + VAL_INDEX_4 = -12 (overflow)
        report "Test A5: (-6) + (-6) = -12 (overflow expected)";
        A <= VAL_INDEX_4; B <= VAL_INDEX_4; Mode_Sel <= '0';
        wait for 10 ns;
        
        -- ========== SUBTRACTION TESTS (Mode_Sel = '1') ==========
        
        -- Test S1: VAL_INDEX_3 - VAL_INDEX_1 = 7 - 2 = 5
        report "Test S1: 7 - 2 = 5";
        A <= VAL_INDEX_3; B <= VAL_INDEX_1; Mode_Sel <= '1';
        wait for 10 ns;
        
        -- Test S2: VAL_INDEX_1 - VAL_INDEX_3 = 2 - 7 = -5 (1011)
        report "Test S2: 2 - 7 = -5";
        A <= VAL_INDEX_1; B <= VAL_INDEX_3; Mode_Sel <= '1';
        wait for 10 ns;
        
        -- Test S3: VAL_INDEX_4 (as signed -6) - VAL_INDEX_1 = -6 - 2 = -8 (1000)
        report "Test S3: (-6) - 2 = -8";
        A <= VAL_INDEX_4; B <= VAL_INDEX_1; Mode_Sel <= '1';
        wait for 10 ns;
        
        -- Test S4: VAL_INDEX_5 - VAL_INDEX_5 = 3 - 3 = 0 (zero flag)
        report "Test S4: 3 - 3 = 0 (zero flag expected)";
        A <= VAL_INDEX_5; B <= VAL_INDEX_5; Mode_Sel <= '1';
        wait for 10 ns;
        
        -- Test S5: (-8) - 1 = -9 (overflow expected)
        report "Test S5: (-8) - 1 = -9 (overflow expected)";
        A <= "1000"; B <= "0001"; Mode_Sel <= '1';
        wait for 10 ns;
        
        -- ========== ADDITIONAL INDEX-BASED TESTS ==========
        
        -- Test I1: VAL_INDEX_2 + VAL_INDEX_2 = 0 + 0 = 0
        report "Test I1: 0 + 0 = 0 (zero flag)";
        A <= VAL_INDEX_2; B <= VAL_INDEX_2; Mode_Sel <= '0';
        wait for 10 ns;
        
        -- Test I2: VAL_INDEX_3 + VAL_INDEX_4 = 7 + (-6) = 1
        report "Test I2: 7 + (-6) = 1";
        A <= VAL_INDEX_3; B <= VAL_INDEX_4; Mode_Sel <= '0';
        wait for 10 ns;
        
        -- Test I3: VAL_INDEX_5 - VAL_INDEX_1 = 3 - 2 = 1
        report "Test I3: 3 - 2 = 1";
        A <= VAL_INDEX_5; B <= VAL_INDEX_1; Mode_Sel <= '1';
        wait for 10 ns;
        
        report "=== All Add_Sub_4bit Tests Completed ===";
        wait;
    end process;
    
end Behavioral;