----------------------------------------------------------------------------------
-- Testbench for Input Selector
-- Reads switches when enabled
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Input_Selector is
end tb_Input_Selector;

architecture Behavioral of tb_Input_Selector is
    component Input_Selector
        Port ( Switches : in DataBus; Input_Enable : in STD_LOGIC; OutputData : out DataBus);
    end component;
    
    signal Switches, OutputData : DataBus;
    signal Input_Enable : STD_LOGIC;
    
    -- Test switch values from team index last 4 bits
    constant SW_M1 : DataBus := "0010";  -- Member1: 2
    constant SW_M2 : DataBus := "1100";  -- Member2: 12
    constant SW_M3 : DataBus := "1101";  -- Member3: 13
    
begin
    UUT: Input_Selector port map (Switches => Switches, Input_Enable => Input_Enable, OutputData => OutputData);
    
    process
    begin
        report "==========================================================";
        report "Testing Input Selector";
        report "==========================================================";
        
        -- Test1: Input disabled => Output zeros
        report "Test1: InputEn=0 => Output=0000";
        Input_Enable <= '0';
        Switches <= SW_M1;
        wait for 20 ns;
        
        -- Test2: Input enabled, with M1 value
        report "Test2: InputEn=1, Switches=0010(2) => Output=2";
        Input_Enable <= '1';
        Switches <= SW_M1;
        wait for 20 ns;
        
        -- Test3: Input enabled, with M2 value
        report "Test3: InputEn=1, Switches=1100(12) => Output=12";
        Switches <= SW_M2;
        wait for 20 ns;
        
        -- Test4: Input enabled, with M3 value
        report "Test4: InputEn=1, Switches=1101(13) => Output=13";
        Switches <= SW_M3;
        wait for 20 ns;
        
        report "==========================================================";
        report "Input Selector Tests Complete!";
        report "==========================================================";
        wait;
    end process;
end Behavioral;
