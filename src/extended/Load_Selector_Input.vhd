----------------------------------------------------------------------------------
-- Load Selector with Input Support
-- Priority: Input_Enable > Load_Select
-- Uses only 2-way mux with input override
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Load_Selector_Input is
    Port ( RegisterValue  : in  DataBus;
           ImmediateValue : in  DataBus;
           InputValue     : in  DataBus;
           LoadSelect     : in  STD_LOGIC;
           InputEnable    : in  STD_LOGIC;
           OutputData     : out DataBus);
end Load_Selector_Input;

architecture Behavioral of Load_Selector_Input is
    signal normal_selection : DataBus;
begin
    -- Normal 2-way mux (immediate vs register)
    normal_selection <= ImmediateValue when LoadSelect = LOAD_IMMEDIATE else RegisterValue;
    
    -- Input has highest priority: if InputEnable=1, use InputValue
    OutputData <= InputValue when InputEnable = '1' else normal_selection;
    
end Behavioral;