----------------------------------------------------------------------------------
-- Testbench for 3-to-8 Decoder
-- Using LAST 3 BITS of team index numbers for inputs
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Decoder_3to8 is
end tb_Decoder_3to8;

architecture Behavioral of tb_Decoder_3to8 is
    component Decoder_3to8
        Port ( I : in STD_LOGIC_VECTOR(2 downto 0);
               EN : in STD_LOGIC;
               Y : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    signal I : STD_LOGIC_VECTOR(2 downto 0);
    signal EN : STD_LOGIC;
    signal Y : STD_LOGIC_VECTOR(7 downto 0);
    
begin
    UUT: Decoder_3to8 port map (I => I, EN => EN, Y => Y);
    
    process
    begin
        report "Testing 3-to-8 Decoder with Team Index Bits";
        
        -- Test with EN=0 (disabled)
        report "Test1: EN=0 -> all outputs 0";
        EN <= '0';
        I <= "010";
        wait for 20 ns;
        
        -- Enable decoder
        EN <= '1';
        
        -- Test all inputs
        report "Test2: Input=000 -> Output bit0";
        I <= "000"; wait for 15 ns;
        
        report "Test3: Input=001 -> Output bit1";
        I <= "001"; wait for 15 ns;
        
        report "Test4: Input=010 -> Output bit2 (Member1)";
        I <= "010"; wait for 15 ns;
        
        report "Test5: Input=011 -> Output bit3";
        I <= "011"; wait for 15 ns;
        
        report "Test6: Input=100 -> Output bit4 (Member2 & Member4)";
        I <= "100"; wait for 15 ns;
        
        report "Test7: Input=101 -> Output bit5 (Member3)";
        I <= "101"; wait for 15 ns;
        
        report "Test8: Input=110 -> Output bit6";
        I <= "110"; wait for 15 ns;
        
        report "Test9: Input=111 -> Output bit7";
        I <= "111"; wait for 15 ns;
        
        report "Decoder_3to8 Tests Complete!";
        wait;
    end process;
end Behavioral;
