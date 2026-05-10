----------------------------------------------------------------------------------
-- Testbench for Load Selector with Input Support
-- Tests priority: Input_Enable > Load_Select
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity tb_Load_Selector_Input is
end tb_Load_Selector_Input;

architecture Behavioral of tb_Load_Selector_Input is
    component Load_Selector_Input
        Port ( RegisterValue : in DataBus; ImmediateValue : in DataBus;
               InputValue : in DataBus; LoadSelect : in STD_LOGIC;
               InputEnable : in STD_LOGIC; OutputData : out DataBus);
    end component;
    
    signal RegVal, ImmVal, InputVal, OutputData : DataBus;
    signal LoadSel, InputEn : STD_LOGIC;
    
    constant REG_VAL : DataBus := "0010";   -- 2
    constant IMM_VAL : DataBus := "1100";   -- 12
    constant INPUT_VAL : DataBus := "0111"; -- 7
    
begin
    UUT: Load_Selector_Input port map (
        RegisterValue => RegVal, ImmediateValue => ImmVal,
        InputValue => InputVal, LoadSelect => LoadSel,
        InputEnable => InputEn, OutputData => OutputData
    );
    
    process
    begin
        report "==========================================================";
        report "Testing Load Selector with Input Priority";
        report "Reg=2(0010), Imm=12(1100), Input=7(0111)";
        report "==========================================================";
        
        RegVal <= REG_VAL; ImmVal <= IMM_VAL; InputVal <= INPUT_VAL;
        
        -- Test1: Input disabled, LoadSelect=0 => Immediate
        report "Test1: InputEn=0, LoadSel=0 => Output=Immediate(1100=12)";
        InputEn <= '0'; LoadSel <= LOAD_IMMEDIATE;
        wait for 20 ns;
        
        -- Test2: Input disabled, LoadSelect=1 => Register
        report "Test2: InputEn=0, LoadSel=1 => Output=Register(0010=2)";
        LoadSel <= LOAD_REGISTER;
        wait for 20 ns;
        
        -- Test3: Input enabled => Overrides both (Input has priority)
        report "Test3: InputEn=1 => Output=Input(0111=7) (priority)";
        InputEn <= '1';
        wait for 20 ns;
        
        -- Test4: Input enabled, change LoadSel (still Input)
        report "Test4: InputEn=1, LoadSel=0 => Still Input(7)";
        LoadSel <= LOAD_IMMEDIATE;
        wait for 20 ns;
        
        report "==========================================================";
        report "Load Selector Tests Complete!";
        report "==========================================================";
        wait;
    end process;
end Behavioral;
