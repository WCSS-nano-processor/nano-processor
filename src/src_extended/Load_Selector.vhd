----------------------------------------------------------------------------------
-- Load Selector (2-way 4-bit Mux)
-- Selects between ALU result and immediate value for register write
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Load_Selector is
    Port ( RegisterValue  : in  DataBus;
           ImmediateValue : in  DataBus;
           LoadSelect     : in  STD_LOGIC;
           OutputData     : out DataBus);
end Load_Selector;

architecture Behavioral of Load_Selector is
    component Mux_2way_4bit
        port ( Input_0 : in  STD_LOGIC_VECTOR (3 downto 0);
               Input_1 : in  STD_LOGIC_VECTOR (3 downto 0);
               Sel     : in  STD_LOGIC;
               Output  : out STD_LOGIC_VECTOR (3 downto 0));
    end component;
begin
    MUX: Mux_2way_4bit port map (
        Input_0 => ImmediateValue,
        Input_1 => RegisterValue,
        Sel => LoadSelect,
        Output => OutputData
    );
end Behavioral;