----------------------------------------------------------------------------------
-- 2-way 4-bit Multiplexer
-- Used for load selector (immediate vs ALU result)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Mux_2way_4bit is
    Port ( Input_0 : in  STD_LOGIC_VECTOR (3 downto 0);
           Input_1 : in  STD_LOGIC_VECTOR (3 downto 0);
           Sel     : in  STD_LOGIC;
           Output  : out STD_LOGIC_VECTOR (3 downto 0));
end Mux_2way_4bit;

architecture Behavioral of Mux_2way_4bit is
begin
    Output <= Input_0 when Sel = '0' else Input_1;
end Behavioral;
