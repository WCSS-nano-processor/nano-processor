----------------------------------------------------------------------------------
-- 8-way 4-bit Multiplexer
-- Used to select one of 8 register values
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_8way_4bit is
    Port ( Sel     : in  STD_LOGIC_VECTOR (2 downto 0);
           Reg_0   : in  STD_LOGIC_VECTOR (3 downto 0);
           Reg_1   : in  STD_LOGIC_VECTOR (3 downto 0);
           Reg_2   : in  STD_LOGIC_VECTOR (3 downto 0);
           Reg_3   : in  STD_LOGIC_VECTOR (3 downto 0);
           Reg_4   : in  STD_LOGIC_VECTOR (3 downto 0);
           Reg_5   : in  STD_LOGIC_VECTOR (3 downto 0);
           Reg_6   : in  STD_LOGIC_VECTOR (3 downto 0);
           Reg_7   : in  STD_LOGIC_VECTOR (3 downto 0);
           MuxOut  : out STD_LOGIC_VECTOR (3 downto 0));
end Mux_8way_4bit;

architecture Behavioral of Mux_8way_4bit is
begin
    process(Sel, Reg_0, Reg_1, Reg_2, Reg_3, Reg_4, Reg_5, Reg_6, Reg_7)
    begin
        case Sel is
            when "000" => MuxOut <= Reg_0;
            when "001" => MuxOut <= Reg_1;
            when "010" => MuxOut <= Reg_2;
            when "011" => MuxOut <= Reg_3;
            when "100" => MuxOut <= Reg_4;
            when "101" => MuxOut <= Reg_5;
            when "110" => MuxOut <= Reg_6;
            when "111" => MuxOut <= Reg_7;
            when others => MuxOut <= "0000";
        end case;
    end process;
end Behavioral;