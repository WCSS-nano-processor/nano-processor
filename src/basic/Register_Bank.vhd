----------------------------------------------------------------------------------
-- Register Bank
-- Contains 8 registers (R0-R7)
-- R0 is hardwired to 0 (read-only)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Register_Bank is
    Port ( Data        : in  DataBus;
           Reset       : in  STD_LOGIC;
           Reg_En      : in  RegisterSelect;
           Clock       : in  STD_LOGIC;
           Register_Outputs : out RegisterFile);
end Register_Bank;

architecture Behavioral of Register_Bank is
    component Decoder_3to8
        Port ( I : in  STD_LOGIC_VECTOR (2 downto 0);
               EN : in  STD_LOGIC;
               Y : out STD_LOGIC_VECTOR (7 downto 0));
    end component;
    
    component Reg
        Port ( D : in  STD_LOGIC_VECTOR (3 downto 0);
               Res : in  STD_LOGIC;
               En : in  STD_LOGIC;
               Clk : in  STD_LOGIC;
               Q : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
    
    signal Reg_Sel : STD_LOGIC_VECTOR (7 downto 0);
    signal reg_outputs_internal : RegisterFile;
    
begin
    -- 3-to-8 decoder converts 3-bit select to one-hot
    Decoder: Decoder_3to8 port map (
        I => Reg_En,
        EN => '1',
        Y => Reg_Sel
    );
    
    -- Register 0 - hardwired to zero
    R0: Reg port map (
        D => "0000",
        Res => Reset,
        En => '1',
        Clk => Clock,
        Q => reg_outputs_internal(0)
    );
    
    -- Registers 1-7
    R1: Reg port map (D => Data, Res => Reset, En => Reg_Sel(1), Clk => Clock, Q => reg_outputs_internal(1));
    R2: Reg port map (D => Data, Res => Reset, En => Reg_Sel(2), Clk => Clock, Q => reg_outputs_internal(2));
    R3: Reg port map (D => Data, Res => Reset, En => Reg_Sel(3), Clk => Clock, Q => reg_outputs_internal(3));
    R4: Reg port map (D => Data, Res => Reset, En => Reg_Sel(4), Clk => Clock, Q => reg_outputs_internal(4));
    R5: Reg port map (D => Data, Res => Reset, En => Reg_Sel(5), Clk => Clock, Q => reg_outputs_internal(5));
    R6: Reg port map (D => Data, Res => Reset, En => Reg_Sel(6), Clk => Clock, Q => reg_outputs_internal(6));
    R7: Reg port map (D => Data, Res => Reset, En => Reg_Sel(7), Clk => Clock, Q => reg_outputs_internal(7));
    
    Register_Outputs <= reg_outputs_internal;
    
end Behavioral;