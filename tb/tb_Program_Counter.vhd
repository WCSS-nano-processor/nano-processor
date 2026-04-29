----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 06:15:50 PM
-- Design Name: 
-- Module Name: tb_Program_Counter - Behavioral
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
-- Testbench for 3-bit Program Counter
-- Using index number 240066 for test values
-- Tests reset, clock behavior, and loading values from index
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity tb_Program_Counter is
end tb_Program_Counter;

architecture Behavioral of tb_Program_Counter is
    component Program_Counter
        Port ( PC_Next    : in  ProgramCounter;
               Res        : in  STD_LOGIC;
               Clk        : in  STD_LOGIC;
               PC_Current : out ProgramCounter);
    end component;
    
    signal PC_Next, PC_Current : ProgramCounter;
    signal Res, Clk : STD_LOGIC := '0';
    
    constant CLK_PERIOD : time := 10 ns;
    
    -- Values from index 240066
    constant INDEX_VAL_1 : ProgramCounter := "010";  -- bits 16-17? Actually 3-bit from index
    constant INDEX_VAL_2 : ProgramCounter := "000";
    constant INDEX_VAL_3 : ProgramCounter := "111";
    constant INDEX_VAL_4 : ProgramCounter := "101";
    
begin
    UUT: Program_Counter port map (
        PC_Next => PC_Next,
        Res => Res,
        Clk => Clk,
        PC_Current => PC_Current
    );
    
    -- Clock generation
    clk_process: process
    begin
        for i in 0 to 40 loop
            Clk <= '0';
            wait for CLK_PERIOD/2;
            Clk <= '1';
            wait for CLK_PERIOD/2;
        end loop;
        wait;
    end process;
    
    -- Stimulus process
    stim_proc: process
    begin
        report "========================================";
        report "Testing Program Counter with Index: 240066";
        report "========================================";
        
        -- Test 1: Reset test - PC should become 0
        report "Test 1: Reset test";
        Res <= '1';
        PC_Next <= INDEX_VAL_3;  -- Should be ignored
        wait for CLK_PERIOD;
        assert PC_Current = "000" 
            report "Error: PC not reset to 0" severity error;
        
        -- Test 2: Load INDEX_VAL_1 (010 = 2)
        report "Test 2: Load index value 010 (2)";
        Res <= '0';
        PC_Next <= INDEX_VAL_1;
        wait for CLK_PERIOD;
        assert PC_Current = "010" 
            report "Error: PC did not load 010" severity error;
        
        -- Test 3: Load INDEX_VAL_2 (000 = 0)
        report "Test 3: Load index value 000 (0)";
        PC_Next <= INDEX_VAL_2;
        wait for CLK_PERIOD;
        assert PC_Current = "000" 
            report "Error: PC did not load 000" severity error;
        
        -- Test 4: Load INDEX_VAL_3 (111 = 7)
        report "Test 4: Load index value 111 (7)";
        PC_Next <= INDEX_VAL_3;
        wait for CLK_PERIOD;
        assert PC_Current = "111" 
            report "Error: PC did not load 111" severity error;
        
        -- Test 5: Load INDEX_VAL_4 (101 = 5)
        report "Test 5: Load index value 101 (5)";
        PC_Next <= INDEX_VAL_4;
        wait for CLK_PERIOD;
        assert PC_Current = "101" 
            report "Error: PC did not load 101" severity error;
        
        -- Test 6: Test all values from 0 to 7
        report "Test 6: Testing all 8 values";
        for i in 0 to 7 loop
            PC_Next <= std_logic_vector(to_unsigned(i, 3));
            wait for CLK_PERIOD;
            assert PC_Current = std_logic_vector(to_unsigned(i, 3))
                report "Error: PC failed for value " & integer'image(i)
                severity error;
        end loop;
        
        -- Test 7: Reset during operation
        report "Test 7: Reset during operation";
        PC_Next <= "110";
        wait for CLK_PERIOD;
        assert PC_Current = "110" report "Error: PC did not load 110" severity error;
        
        Res <= '1';
        wait for CLK_PERIOD;
        assert PC_Current = "000" report "Error: Reset failed during operation" severity error;
        
        -- Test 8: Release reset and load
        report "Test 8: Release reset and load index value";
        Res <= '0';
        PC_Next <= INDEX_VAL_1;
        wait for CLK_PERIOD;
        assert PC_Current = INDEX_VAL_1 
            report "Error: PC did not load after reset" severity error;
        
        report "=== All Program Counter Tests Completed Successfully! ===";
        wait;
    end process;
    
end Behavioral;