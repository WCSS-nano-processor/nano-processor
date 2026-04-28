----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 11:22:44 PM
-- Design Name: 
-- Module Name: Program_counter - Behavioral
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
-- 3-bit Program Counter with Reset
-- Uses D Flip-Flops with asynchronous reset
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Program_Counter is
    Port ( PC_Next    : in  ProgramCounter;
           Res        : in  STD_LOGIC;
           Clk        : in  STD_LOGIC;
           PC_Current : out ProgramCounter);
end Program_Counter;

architecture Behavioral of Program_Counter is
    component Reg
        port ( D, Res, En, Clk : in STD_LOGIC;
               Q : out STD_LOGIC);
    end component;
    
    signal pc_reg : ProgramCounter;
    
begin
    -- 3-bit register using individual flip-flops
    GEN_REG: for i in 0 to 2 generate
        REG_i: entity work.Reg
            port map (
                D => PC_Next(i),
                Res => Res,
                En => '1',
                Clk => Clk,
                Q => pc_reg(i)
            );
    end generate;
    
    PC_Current <= pc_reg;
    
end Behavioral;