----------------------------------------------------------------------------------
-- 4-bit Register with Asynchronous Reset
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Reg is
    Port ( D     : in  STD_LOGIC_VECTOR (3 downto 0);
           Res   : in  STD_LOGIC;
           En    : in  STD_LOGIC;
           Clk   : in  STD_LOGIC;
           Q     : out STD_LOGIC_VECTOR (3 downto 0));
end Reg;

architecture Behavioral of Reg is
begin
    process(Clk, Res)
    begin
        if Res = '1' then
            Q <= (others => '0');
        elsif rising_edge(Clk) then
            if En = '1' then
                Q <= D;
            end if;
        end if;
    end process;
end Behavioral;