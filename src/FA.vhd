----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 11:01:05 PM
-- Design Name: 
-- Module Name: FA - Behavioral
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
-- Full Adder (FA)
-- Building block for Ripple Carry Adder
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    Port ( A     : in  STD_LOGIC;
           B     : in  STD_LOGIC;
           C_in  : in  STD_LOGIC;
           S     : out STD_LOGIC;
           C_out : out STD_LOGIC);
end FA;

architecture Behavioral of FA is
begin
    S     <= A xor B xor C_in;
    C_out <= (A and B) or (A and C_in) or (B and C_in);
end Behavioral;
