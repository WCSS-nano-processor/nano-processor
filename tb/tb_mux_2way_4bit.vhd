----------------------------------------------------------------------------------
-- Testbench for 2-way 4-bit Multiplexer
-- Using LAST 4 BINARY DIGITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_Mux_2way_4bit is
end tb_Mux_2way_4bit;

architecture Behavioral of tb_Mux_2way_4bit is
    component Mux_2way_4bit
        Port ( Input_0, Input_1 : in STD_LOGIC_VECTOR(3 downto 0);
               Sel : in STD_LOGIC;
               Output : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    signal In0, In1, Output : STD_LOGIC_VECTOR(3 downto 0);
    signal Sel : STD_LOGIC;
    
begin
    UUT: Mux_2way_4bit port map (Input_0 => In0, Input_1 => In1, Sel => Sel, Output => Output);
    
    process
    begin
        report "Testing 2-way 4-bit Mux with Team Index Bits";
        
        -- Test1: Sel=0 selects Input_0
        report "Test1: Sel=0 -> Output = Member1(0010=2)";
        In0 <= "0010"; In1 <= "1100"; Sel <= '0';
        wait for 20 ns;
        
        -- Test2: Sel=1 selects Input_1
        report "Test2: Sel=1 -> Output = Member2(1100=12)";
        Sel <= '1';
        wait for 20 ns;
        
        -- Test3: Different values
        report "Test3: In0=Member3(1101=13), In1=Member4(1100=12)";
        In0 <= "1101"; In1 <= "1100";
        Sel <= '0';
        wait for 20 ns;
        Sel <= '1';
        wait for 20 ns;
        
        -- Test4: Both inputs equal
        report "Test4: Both inputs = 0010(2)";
        In0 <= "0010"; In1 <= "0010";
        Sel <= '0';
        wait for 20 ns;
        Sel <= '1';
        wait for 20 ns;
        
        report "Mux_2way_4bit Tests Complete!";
        wait;
    end process;
end Behavioral;
