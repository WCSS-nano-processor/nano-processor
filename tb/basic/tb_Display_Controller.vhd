----------------------------------------------------------------------------------
-- Testbench for Display Controller
-- Using LAST 4 BINARY DIGITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Display_Controller is
end tb_Display_Controller;

architecture Behavioral of tb_Display_Controller is
    component Display_Controller
        Port ( clk : in STD_LOGIC;
               Data_in : in STD_LOGIC_VECTOR(3 downto 0);
               seg : out STD_LOGIC_VECTOR(6 downto 0);
               an : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    signal clk : STD_LOGIC := '0';
    signal Data_in : STD_LOGIC_VECTOR(3 downto 0);
    signal seg : STD_LOGIC_VECTOR(6 downto 0);
    signal an : STD_LOGIC_VECTOR(3 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    UUT: Display_Controller port map (clk => clk, Data_in => Data_in, seg => seg, an => an);
    
    clk <= not clk after CLK_PERIOD/2;
    
    process
    begin
        report "Testing Display Controller with Team Index Bits";
        
        -- Test positive numbers
        report "Test1: Display +2 (Member1)";
        Data_in <= "0010";
        wait for 500 ns;
        
        report "Test2: Display +7";
        Data_in <= "0111";
        wait for 500 ns;
        
        -- Test negative numbers
        report "Test3: Display -4 (Member2 & Member4)";
        Data_in <= "1100";
        wait for 500 ns;
        
        report "Test4: Display -3 (Member3)";
        Data_in <= "1101";
        wait for 500 ns;
        
        -- Test zero
        report "Test5: Display 0";
        Data_in <= "0000";
        wait for 500 ns;
        
        report "Display_Controller Tests Complete!";
        wait;
    end process;
end Behavioral;
