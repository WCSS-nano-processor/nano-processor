----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 11:20:20 PM
-- Design Name: 
-- Module Name: PC_Adder - Behavioral
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
-- 3-bit Adder for Program Counter Increment
-- PC_Next = PC_Current + 1
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity PC_Adder is
    Port ( current_address : in  ProgramCounter;
           next_address    : out ProgramCounter);
end PC_Adder;

architecture Behavioral of PC_Adder is
begin
    next_address <= std_logic_vector(unsigned(current_address) + 1);
end Behavioral;
