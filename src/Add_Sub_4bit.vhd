----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 11:17:01 PM
-- Design Name: 
-- Module Name: Add_Sub_4bit - Behavioral
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


library IEEE;
----------------------------------------------------------------------------------
-- 4-bit Add/Subtract Unit
-- Supports addition and subtraction using 2's complement
-- Mode_Sel = '0' for ADD, '1' for SUBTRACT
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Add_Sub_4bit is
    Port ( Input_A     : in  DataBus;
           Input_B     : in  DataBus;
           Mode_Sel    : in  STD_LOGIC;
           Result      : out DataBus;
           Zero_Flag   : out STD_LOGIC;
           Overflow_Flag : out STD_LOGIC);
end Add_Sub_4bit;

architecture Behavioral of Add_Sub_4bit is
    component RCA_4
        port ( A0, A1, A2, A3 : in  STD_LOGIC;
               B0, B1, B2, B3 : in  STD_LOGIC;
               C_in           : in  STD_LOGIC;
               S0, S1, S2, S3 : out STD_LOGIC;
               C_out          : out STD_LOGIC);
    end component;
    
    signal Modified_B : DataBus;
    signal Temp_Result : DataBus;
    signal RCA_Cout : STD_LOGIC;
    
begin
    -- XOR each bit of B with Mode_Sel for 2's complement in subtraction
    Modified_B(0) <= Input_B(0) xor Mode_Sel;
    Modified_B(1) <= Input_B(1) xor Mode_Sel;
    Modified_B(2) <= Input_B(2) xor Mode_Sel;
    Modified_B(3) <= Input_B(3) xor Mode_Sel;
    
    -- RCA Instantiation
    RCA_inst: RCA_4 port map (
        A0 => Input_A(0), A1 => Input_A(1), A2 => Input_A(2), A3 => Input_A(3),
        B0 => Modified_B(0), B1 => Modified_B(1), B2 => Modified_B(2), B3 => Modified_B(3),
        C_in => Mode_Sel,
        S0 => Temp_Result(0), S1 => Temp_Result(1), S2 => Temp_Result(2), S3 => Temp_Result(3),
        C_out => RCA_Cout
    );
    
    -- Zero flag detection
    Zero_Flag <= '1' when Temp_Result = "0000" else '0';
    
    -- Overflow detection for signed 2's complement
    process(Input_A, Input_B, Temp_Result, Mode_Sel)
    begin
        if Mode_Sel = '0' then  -- Addition
            Overflow_Flag <= (Input_A(3) and Input_B(3) and not Temp_Result(3)) or
                             (not Input_A(3) and not Input_B(3) and Temp_Result(3));
        else  -- Subtraction
            Overflow_Flag <= (Input_A(3) and not Input_B(3) and not Temp_Result(3)) or
                             (not Input_A(3) and Input_B(3) and Temp_Result(3));
        end if;
    end process;
    
    Result <= Temp_Result;
    
end Behavioral;
