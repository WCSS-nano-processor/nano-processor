----------------------------------------------------------------------------------
-- Testbench for Load Selector (2-way 4-bit Mux)
-- Using LAST 4 BINARY DIGITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Load_Selector is
end tb_Load_Selector;

architecture Behavioral of tb_Load_Selector is
    component Load_Selector
        Port ( RegisterValue, ImmediateValue : in DataBus;
               LoadSelect : in STD_LOGIC;
               OutputData : out DataBus);
    end component;
    
    signal RegVal, ImmVal, OutputData : DataBus;
    signal LoadSel : STD_LOGIC;
    
begin
    UUT: Load_Selector port map (
        RegisterValue => RegVal, ImmediateValue => ImmVal,
        LoadSelect => LoadSel, OutputData => OutputData
    );
    
    process
    begin
        report "Testing Load Selector with Team Index Bits";
        
        -- Test1: LoadSel=0 -> select Immediate
        report "Test1: LoadSel=0 -> Output = Immediate(1100=12)";
        RegVal <= "0010"; ImmVal <= "1100"; LoadSel <= '0';
        wait for 20 ns;
        
        -- Test2: LoadSel=1 -> select Register
        report "Test2: LoadSel=1 -> Output = Register(0010=2)";
        LoadSel <= '1';
        wait for 20 ns;
        
        -- Test3: Different values
        report "Test3: Reg=1101(13), Imm=0111(7)";
        RegVal <= "1101"; ImmVal <= "0111";
        LoadSel <= '0';
        wait for 20 ns;
        LoadSel <= '1';
        wait for 20 ns;
        
        report "Load_Selector Tests Complete!";
        wait;
    end process;
end Behavioral;
