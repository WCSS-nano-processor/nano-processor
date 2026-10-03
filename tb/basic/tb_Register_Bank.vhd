----------------------------------------------------------------------------------
-- Testbench for Register Bank
-- Using LAST 4 BINARY DIGITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Register_Bank is
end tb_Register_Bank;

architecture Behavioral of tb_Register_Bank is
    component Register_Bank
        Port ( Data : in DataBus;
               Reset : in STD_LOGIC;
               Reg_En : in RegisterSelect;
               Clock : in STD_LOGIC;
               Register_Outputs : out RegisterFile);
    end component;
    
    signal Data : DataBus;
    signal Reset : STD_LOGIC := '1';
    signal Reg_En : RegisterSelect;
    signal Clock : STD_LOGIC := '0';
    signal Register_Outputs : RegisterFile;
    
    constant CLK_PERIOD : time := 20 ns;
    
begin
    UUT: Register_Bank port map (
        Data => Data, Reset => Reset, Reg_En => Reg_En,
        Clock => Clock, Register_Outputs => Register_Outputs
    );
    
    Clock <= not Clock after CLK_PERIOD/2;
    
    process
    begin
        report "Testing Register Bank with Team Index Bits";
        
        -- Reset
        report "Test1: Reset -> all registers 0";
        Reset <= '1';
        wait for CLK_PERIOD;
        Reset <= '0';
        
        -- Write to R1 (Member1: 2)
        report "Test2: Write 2 to R1";
        Data <= "0010"; Reg_En <= "001";
        wait for CLK_PERIOD;
        
        -- Write to R2 (Member2: 12)
        report "Test3: Write 12 to R2";
        Data <= "1100"; Reg_En <= "010";
        wait for CLK_PERIOD;
        
        -- Write to R3 (Member3: 13)
        report "Test4: Write 13 to R3";
        Data <= "1101"; Reg_En <= "011";
        wait for CLK_PERIOD;
        
        -- Write to R4 (Member4: 12)
        report "Test5: Write 12 to R4";
        Data <= "1100"; Reg_En <= "100";
        wait for CLK_PERIOD;
        
        -- Write to R7
        report "Test6: Write 7 to R7";
        Data <= "0111"; Reg_En <= "111";
        wait for CLK_PERIOD;
        
        -- Verify R0 is always 0
        if Register_Outputs(0) = "0000" then
            report "R0 = 0 (correct)";
        else
            report "ERROR: R0 should be 0!";
        end if;
        
        report "Register_Bank Tests Complete!";
        wait;
    end process;
end Behavioral;
