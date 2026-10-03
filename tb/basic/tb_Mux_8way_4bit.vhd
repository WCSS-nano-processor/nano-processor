----------------------------------------------------------------------------------
-- Testbench for 8-way 4-bit Multiplexer
-- Using LAST 4 BINARY DIGITS for register values
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity tb_Mux_8way_4bit is
end tb_Mux_8way_4bit;

architecture Behavioral of tb_Mux_8way_4bit is
    component Mux_8way_4bit
        Port ( Sel : in STD_LOGIC_VECTOR(2 downto 0);
               Reg_0,Reg_1,Reg_2,Reg_3,Reg_4,Reg_5,Reg_6,Reg_7 : in DataBus;
               MuxOut : out DataBus);
    end component;
    
    signal Sel : STD_LOGIC_VECTOR(2 downto 0);
    signal Reg_0,Reg_1,Reg_2,Reg_3,Reg_4,Reg_5,Reg_6,Reg_7 : DataBus;
    signal MuxOut : DataBus;
    
begin
    UUT: Mux_8way_4bit port map (
        Sel => Sel,
        Reg_0 => Reg_0, Reg_1 => Reg_1, Reg_2 => Reg_2, Reg_3 => Reg_3,
        Reg_4 => Reg_4, Reg_5 => Reg_5, Reg_6 => Reg_6, Reg_7 => Reg_7,
        MuxOut => MuxOut
    );
    
    process
    begin
        report "Testing 8-way 4-bit Mux with Team Index Bits";
        
        -- Load register values from team indexes
        Reg_0 <= "0000";
        Reg_1 <= "0010";  -- Member1: 2
        Reg_2 <= "1100";  -- Member2: 12
        Reg_3 <= "1101";  -- Member3: 13
        Reg_4 <= "1100";  -- Member4: 12
        Reg_5 <= "0000";
        Reg_6 <= "1111";
        Reg_7 <= "0111";
        
        -- Test all select values
        report "Sel=000 -> Output = R0(0)";
        Sel <= "000"; wait for 15 ns;
        
        report "Sel=001 -> Output = R1(2)";
        Sel <= "001"; wait for 15 ns;
        
        report "Sel=010 -> Output = R2(12)";
        Sel <= "010"; wait for 15 ns;
        
        report "Sel=011 -> Output = R3(13)";
        Sel <= "011"; wait for 15 ns;
        
        report "Sel=100 -> Output = R4(12)";
        Sel <= "100"; wait for 15 ns;
        
        report "Sel=101 -> Output = R5(0)";
        Sel <= "101"; wait for 15 ns;
        
        report "Sel=110 -> Output = R6(15)";
        Sel <= "110"; wait for 15 ns;
        
        report "Sel=111 -> Output = R7(7)";
        Sel <= "111"; wait for 15 ns;
        
        report "Mux_8way_4bit Tests Complete!";
        wait;
    end process;
end Behavioral;
