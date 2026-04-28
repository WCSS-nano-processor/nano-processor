----------------------------------------------------------------------------------
-- 2-way 3-bit Multiplexer
-- Used for address selection (normal PC vs jump address)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2way_3bit is
    Port ( Input_0 : in  STD_LOGIC_VECTOR (2 downto 0);
           Input_1 : in  STD_LOGIC_VECTOR (2 downto 0);
           Sel     : in  STD_LOGIC;
           Output  : out STD_LOGIC_VECTOR (2 downto 0));
end Mux_2way_3bit;

architecture Behavioral of Mux_2way_3bit is
begin
    Output <= Input_0 when Sel = '0' else Input_1;
end Behavioral;
