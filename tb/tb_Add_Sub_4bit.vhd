----------------------------------------------------------------------------------
-- Testbench for 4-bit Add/Subtract Unit
-- Using LAST 4 BINARY DIGITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Add_Sub_4bit is
end tb_Add_Sub_4bit;

architecture Behavioral of tb_Add_Sub_4bit is
    component Add_Sub_4bit
        Port ( Input_A, Input_B : in DataBus;
               Mode_Sel : in STD_LOGIC;
               Result : out DataBus;
               Zero_Flag, Overflow_Flag : out STD_LOGIC);
    end component;
    
    signal A, B, Result : DataBus;
    signal Mode_Sel, Zero_Flag, Overflow_Flag : STD_LOGIC;
    
begin
    UUT: Add_Sub_4bit port map (
        Input_A => A, Input_B => B, Mode_Sel => Mode_Sel,
        Result => Result, Zero_Flag => Zero_Flag, Overflow_Flag => Overflow_Flag
    );
    
    process
    begin
        report "Testing 4-bit Add/Sub Unit with Team Index Bits";
        
        -- ========== ADDITION TESTS ==========
        report "--- ADDITION TESTS ---";
        
        -- Test1: 2 + 12 = 14
        report "Test1: 2 + 12 = 14";
        A <= "0010"; B <= "1100"; Mode_Sel <= '0';
        wait for 20 ns;
        
        -- Test2: 13 + 12 = 25 (overflow)
        report "Test2: 13 + 12 = 25 (overflow)";
        A <= "1101"; B <= "1100"; Mode_Sel <= '0';
        wait for 20 ns;
        
        -- Test3: 7 + 1 = 8 (overflow in signed)
        report "Test3: 7 + 1 = 8 (overflow)";
        A <= "0111"; B <= "0001"; Mode_Sel <= '0';
        wait for 20 ns;
        
        -- Test4: 0 + 0 = 0 (zero flag)
        report "Test4: 0 + 0 = 0 (zero flag)";
        A <= "0000"; B <= "0000"; Mode_Sel <= '0';
        wait for 20 ns;
        
        -- ========== SUBTRACTION TESTS ==========
        report "--- SUBTRACTION TESTS ---";
        
        -- Test5: 12 - 2 = 10
        report "Test5: 12 - 2 = 10";
        A <= "1100"; B <= "0010"; Mode_Sel <= '1';
        wait for 20 ns;
        
        -- Test6: 2 - 12 = -6 (1010)
        report "Test6: 2 - 12 = -6";
        A <= "0010"; B <= "1100"; Mode_Sel <= '1';
        wait for 20 ns;
        
        -- Test7: 5 - 5 = 0 (zero flag)
        report "Test7: 5 - 5 = 0 (zero flag)";
        A <= "0101"; B <= "0101"; Mode_Sel <= '1';
        wait for 20 ns;
        
        -- Test8: (-8) - 1 = 7 (overflow)
        report "Test8: (-8) - 1 = 7 (overflow)";
        A <= "1000"; B <= "0001"; Mode_Sel <= '1';
        wait for 20 ns;
        
        report "Add_Sub_4bit Tests Complete!";
        wait;
    end process;
end Behavioral;
