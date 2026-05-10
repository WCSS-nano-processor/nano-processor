----------------------------------------------------------------------------------
-- Input Selector - Reads switches from BASYS3 board
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Input_Selector is
    Port ( Switches     : in  DataBus;      -- SW0-SW3 from BASYS3
           Input_Enable : in  STD_LOGIC;    -- Enable signal from decoder
           OutputData   : out DataBus);     -- Output to load selector
end Input_Selector;

architecture Behavioral of Input_Selector is
begin
    -- When input is enabled, pass switch values; otherwise output zeros
    OutputData <= Switches when Input_Enable = '1' else "0000";
end Behavioral;