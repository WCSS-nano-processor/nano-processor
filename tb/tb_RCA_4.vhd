----------------------------------------------------------------------------------
-- Testbench for 4-bit Ripple Carry Adder (RCA_4)
-- Using LAST 4 BINARY DIGITS of team index numbers
-- Member1: 0010(2), Member2: 1100(12), Member3: 1101(13), Member4: 1100(12)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_RCA_4 is
end tb_RCA_4;

architecture Behavioral of tb_RCA_4 is
    component RCA_4
        Port ( A0,A1,A2,A3,B0,B1,B2,B3,C_in : in STD_LOGIC;
               S0,S1,S2,S3,C_out : out STD_LOGIC);
    end component;
    
    signal A, B, S : STD_LOGIC_VECTOR(3 downto 0);
    signal C_in, C_out : STD_LOGIC;
    
begin
    UUT: RCA_4 port map (
        A0=>A(0), A1=>A(1), A2=>A(2), A3=>A(3),
        B0=>B(0), B1=>B(1), B2=>B(2), B3=>B(3),
        C_in=>C_in, S0=>S(0), S1=>S(1), S2=>S(2), S3=>S(3), C_out=>C_out
    );
    
    process
    begin
        report "Testing 4-bit RCA with Team Index Bits";
        
        -- Test1: Member1(2) + Member2(12) = 14
        report "Test1: 2 + 12 = 14";
        A <= "0010"; B <= "1100"; C_in <= '0';
        wait for 20 ns;
        
        -- Test2: Member3(13) + Member4(12) = 25 (carry out)
        report "Test2: 13 + 12 = 25 (carry out)";
        A <= "1101"; B <= "1100"; C_in <= '0';
        wait for 20 ns;
        
        -- Test3: Member1(2) + Member1(2) = 4
        report "Test3: 2 + 2 = 4";
        A <= "0010"; B <= "0010"; C_in <= '0';
        wait for 20 ns;
        
        -- Test4: 15 + 1 = 16 (carry out)
        report "Test4: 15 + 1 = 16 (carry out)";
        A <= "1111"; B <= "0001"; C_in <= '0';
        wait for 20 ns;
        
        -- Test5: With carry in: 2 + 2 + 1 = 5
        report "Test5: 2 + 2 + 1 = 5";
        A <= "0010"; B <= "0010"; C_in <= '1';
        wait for 20 ns;
        
        report "RCA_4 Tests Complete!";
        wait;
    end process;
end Behavioral;
