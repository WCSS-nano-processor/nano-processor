----------------------------------------------------------------------------------
-- Testbench for 4-bit Register
-- Using LAST 4 BINARY DIGITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Reg is
end tb_Reg;

architecture Behavioral of tb_Reg is
    component Reg
        Port ( D : in STD_LOGIC_VECTOR(3 downto 0);
               Res, En, Clk : in STD_LOGIC;
               Q : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    signal D, Q : STD_LOGIC_VECTOR(3 downto 0);
    signal Res, En, Clk : STD_LOGIC := '0';
    constant CLK_PERIOD : time := 20 ns;
    
begin
    UUT: Reg port map (D => D, Res => Res, En => En, Clk => Clk, Q => Q);
    
    Clk <= not Clk after CLK_PERIOD/2;
    
    process
    begin
        report "Testing 4-bit Register with Team Index Bits";
        
        -- Test reset
        report "Test1: Reset -> Q=0000";
        Res <= '1';
        wait for CLK_PERIOD;
        Res <= '0';
        
        -- Write with En=0 (should not change)
        report "Test2: En=0 -> Q stays 0000";
        En <= '0';
        D <= "0010";
        wait for CLK_PERIOD;
        
        -- Write Member1 value
        report "Test3: Write Member1(0010=2)";
        En <= '1';
        D <= "0010";
        wait for CLK_PERIOD;
        
        -- Write Member2 value
        report "Test4: Write Member2(1100=12)";
        D <= "1100";
        wait for CLK_PERIOD;
        
        -- Write Member3 value
        report "Test5: Write Member3(1101=13)";
        D <= "1101";
        wait for CLK_PERIOD;
        
        -- Write Member4 value
        report "Test6: Write Member4(1100=12)";
        D <= "1100";
        wait for CLK_PERIOD;
        
        -- Test reset during operation
        report "Test7: Reset during operation";
        Res <= '1';
        wait for CLK_PERIOD;
        
        report "Register Tests Complete!";
        wait;
    end process;
end Behavioral;
