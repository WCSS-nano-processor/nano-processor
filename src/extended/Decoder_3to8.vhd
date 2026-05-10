----------------------------------------------------------------------------------
-- 3-to-8 Decoder
-- Converts 3-bit register select to one-hot enable
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decoder_3to8 is
    Port ( I : in  STD_LOGIC_VECTOR (2 downto 0);
           EN : in  STD_LOGIC;
           Y : out STD_LOGIC_VECTOR (7 downto 0));
end Decoder_3to8;

architecture Behavioral of Decoder_3to8 is
begin
    process(I, EN)
    begin
        if EN = '1' then
            case I is
                when "000" => Y <= "00000001";
                when "001" => Y <= "00000010";
                when "010" => Y <= "00000100";
                when "011" => Y <= "00001000";
                when "100" => Y <= "00010000";
                when "101" => Y <= "00100000";
                when "110" => Y <= "01000000";
                when "111" => Y <= "10000000";
                when others => Y <= "00000000";
            end case;
        else
            Y <= "00000000";
        end if;
    end process;
end Behavioral;