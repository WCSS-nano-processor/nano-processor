----------------------------------------------------------------------------------
-- Address Selector (2-way 3-bit Mux)
-- Selects between sequential PC+1 and jump address
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Address_Selector is
    port ( Sequential_Address : in  ProgramCounter;
           Jump_Address       : in  ProgramCounter;
           Jump_Enable        : in  std_logic;
           Selected_Address   : out ProgramCounter);
end Address_Selector;

architecture Behavioral of Address_Selector is
    component Mux_2way_3bit
        port ( Input_0 : in  STD_LOGIC_VECTOR (2 downto 0);
               Input_1 : in  STD_LOGIC_VECTOR (2 downto 0);
               Sel     : in  STD_LOGIC;
               Output  : out STD_LOGIC_VECTOR (2 downto 0));
    end component;
begin
    MUX: Mux_2way_3bit port map (
        Input_0 => Sequential_Address,
        Input_1 => Jump_Address,
        Sel => Jump_Enable,
        Output => Selected_Address
    );
end Behavioral;