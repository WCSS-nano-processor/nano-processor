----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 06:08:02 PM
-- Design Name: 
-- Module Name: tb_PC_Adder - Behavioral
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
-- Testbench for 3-bit PC Adder
-- Using index number 240066 bits for test values
-- Bits 16-17: 11 (binary 3) for testing
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity tb_PC_Adder is
end tb_PC_Adder;

architecture Behavioral of tb_PC_Adder is
    component PC_Adder
        port ( current_address : in  ProgramCounter;
               next_address    : out ProgramCounter);
    end component;
    
    signal current_addr, next_addr : ProgramCounter;
    
    -- From index 240066 bits 16-17: "11" = 3
    constant INDEX_START : ProgramCounter := "011";  -- 3
    
begin
    UUT: PC_Adder port map (
        current_address => current_addr,
        next_address => next_addr
    );
    
    process
    begin
        report "=== Testing PC_Adder with Index 240066 ===";
        report "Index bits 16-17: 11 (binary 3)";
        
        -- Test 1: Start from your index value 3
        report "Test 1: Start from index value 3 -> 4";
        current_addr <= INDEX_START;  -- Start at 3
        wait for 10 ns;
        assert next_addr = "100" report "Error: 3+1 should be 4" severity error;
        
        -- Test 2: 4 -> 5
        report "Test 2: 4 -> 5";
        current_addr <= "100";
        wait for 10 ns;
        assert next_addr = "101" report "Error: 4+1 should be 5" severity error;
        
        -- Test 3: 5 -> 6
        report "Test 3: 5 -> 6";
        current_addr <= "101";
        wait for 10 ns;
        
        -- Test 4: 6 -> 7
        report "Test 4: 6 -> 7";
        current_addr <= "110";
        wait for 10 ns;
        
        -- Test 5: 7 -> 0 (wrap around)
        report "Test 5: 7 -> 0 (wrap around)";
        current_addr <= "111";
        wait for 10 ns;
        assert next_addr = "000" report "Error: 7+1 should wrap to 0" severity error;
        
        -- Test 6: 0 -> 1
        report "Test 6: 0 -> 1";
        current_addr <= "000";
        wait for 10 ns;
        
        -- Test 7: Test all addresses
        report "Test 7: Testing all addresses from 0 to 7";
        for i in 0 to 7 loop
            current_addr <= std_logic_vector(to_unsigned(i, 3));
            wait for 5 ns;
            if i = 7 then
                assert next_addr = "000" 
                    report "Error: Wrap around failed at 7" severity error;
            else
                assert unsigned(next_addr) = i + 1
                    report "Error: Increment failed at " & integer'image(i)
                    severity error;
            end if;
        end loop;
        
        report "=== PC_Adder Tests Completed ===";
        wait;
    end process;
    
end Behavioral;

