----------------------------------------------------------------------------------
-- Testbench for Add_Sub_4bit
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity tb_Add_Sub_4bit is
end tb_Add_Sub_4bit;

architecture Behavioral of tb_Add_Sub_4bit is
    component Add_Sub_4bit
        Port ( Input_A : in DataBus;
               Input_B : in DataBus;
               Mode_Sel : in STD_LOGIC;
               Result : out DataBus;
               Zero_Flag : out STD_LOGIC;
               Overflow_Flag : out STD_LOGIC);
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
        report "========================================" severity note;
        report "TESTING ADD_SUB_4BIT" severity note;
        report "========================================" severity note;
        
        -- TEST 1: 0 + 1 = 1 (No overflow, No zero)
        A <= "0000"; B <= "0001"; Mode_Sel <= '0';
        wait for 10 ns;
        report "0 + 1 = " & integer'image(to_integer(unsigned(Result)));
        assert Zero_Flag = '0' report "ERROR: Zero flag should be 0" severity error;
        assert Overflow_Flag = '0' report "ERROR: Overflow flag should be 0" severity error;
        
        -- TEST 2: 1 + 2 = 3
        A <= "0001"; B <= "0010"; Mode_Sel <= '0';
        wait for 10 ns;
        report "1 + 2 = " & integer'image(to_integer(unsigned(Result)));
        
        -- TEST 3: 3 + 3 = 6
        A <= "0011"; B <= "0011"; Mode_Sel <= '0';
        wait for 10 ns;
        report "3 + 3 = " & integer'image(to_integer(unsigned(Result)));
        
        -- TEST 4: 7 + 1 = 8 (Overflow expected!)
        A <= "0111"; B <= "0001"; Mode_Sel <= '0';
        wait for 10 ns;
        report "7 + 1 = " & integer'image(to_integer(unsigned(Result)));
        assert Overflow_Flag = '1' report "ERROR: Should have overflow!" severity error;
        
        -- TEST 5: 0 - 0 = 0 (Zero flag expected!)
        A <= "0000"; B <= "0000"; Mode_Sel <= '1';
        wait for 10 ns;
        report "0 - 0 = " & integer'image(to_integer(unsigned(Result)));
        assert Zero_Flag = '1' report "ERROR: Zero flag should be 1" severity error;
        
        -- TEST 6: 5 - 3 = 2
        A <= "0101"; B <= "0011"; Mode_Sel <= '1';
        wait for 10 ns;
        report "5 - 3 = " & integer'image(to_integer(unsigned(Result)));
        
        -- TEST 7: (-4) - 3 = -7 (No overflow, -7 is valid)
        A <= "1100"; B <= "0011"; Mode_Sel <= '1';
        wait for 10 ns;
        report "-4 - 3 = " & integer'image(to_integer(signed(Result)));
        
        -- TEST 8: (-8) - 1 = -9 (Overflow expected!)
        A <= "1000"; B <= "0001"; Mode_Sel <= '1';
        wait for 10 ns;
        report "-8 - 1 = " & integer'image(to_integer(signed(Result)));
        assert Overflow_Flag = '1' report "ERROR: Should have overflow!" severity error;
        
        report "========================================" severity note;
        report "ALL TESTS COMPLETE" severity note;
        report "========================================" severity note;
        wait;
    end process;
end Behavioral;