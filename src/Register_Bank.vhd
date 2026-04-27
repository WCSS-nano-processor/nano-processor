----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 03:18:57 PM
-- Design Name: 
-- Module Name: Register_Bank - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_Bank is
Port ( Data        : in  DataBus;
       Reset       : in  STD_LOGIC;
       Reg_En      : in  RegisterSelect;  -- 3-bit select
       Clock       : in  STD_LOGIC;
       Register_Outputs : out RegisterFile);  -- 8 x 4-bit array
end Register_Bank;

architecture Behavioral of Register_Bank is

 -- Component declarations
    component Decoder_3to8
        Port ( I  : in  STD_LOGIC_VECTOR (2 downto 0);
               EN : in  STD_LOGIC;
               Y  : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Reg
        Port ( D   : in  STD_LOGIC_VECTOR (3 downto 0);
               Res : in  STD_LOGIC;
               En  : in  STD_LOGIC;
               Clk : in  STD_LOGIC;
               Q   : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
-- Internal signals
signal Reg_Sel : STD_LOGIC_VECTOR (7 downto 0);  -- One-hot enable signals
signal reg_outputs : RegisterFile;

begin

    Decoder: Decoder_3to8 port map (
        I  => Reg_En,
        EN => '1',          -- Always enabled
        Y  => Reg_Sel
    );
    
        R0: Reg port map (
            D   => "0000",      -- Hardwired to zero
            Res => Reset,
            En  => '1',         -- Always enabled (but writing doesn't matter)
            Clk => Clock,
            Q   => reg_outputs(0)
        );
        
            R1: Reg port map (
                D   => Data,
                Res => Reset,
                En  => Reg_Sel(1),
                Clk => Clock,
                Q   => reg_outputs(1)
            );
            
            R2: Reg port map (
                D   => Data,
                Res => Reset,
                En  => Reg_Sel(2),
                Clk => Clock,
                Q   => reg_outputs(2)
            );
            
            R3: Reg port map (
                D   => Data,
                Res => Reset,
                En  => Reg_Sel(3),
                Clk => Clock,
                Q   => reg_outputs(3)
            );
            
            R4: Reg port map (
                D   => Data,
                Res => Reset,
                En  => Reg_Sel(4),
                Clk => Clock,
                Q   => reg_outputs(4)
            );
            
            R5: Reg port map (
                D   => Data,
                Res => Reset,
                En  => Reg_Sel(5),
                Clk => Clock,
                Q   => reg_outputs(5)
            );
            
            R6: Reg port map (
                D   => Data,
                Res => Reset,
                En  => Reg_Sel(6),
                Clk => Clock,
                Q   => reg_outputs(6)
            );
            
            R7: Reg port map (
                D   => Data,
                Res => Reset,
                En  => Reg_Sel(7),
                Clk => Clock,
                Q   => reg_outputs(7)
            );
            
            -- Connect internal signals to output port
            Register_Outputs <= reg_outputs;


end Behavioral;
