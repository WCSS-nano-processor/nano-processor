----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 11:26:41 AM
-- Design Name: 
-- Module Name: reg_bank - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_bank is
Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           reg_enable : in STD_LOGIC_VECTOR (7 downto 0);
           data_in : in STD_LOGIC_VECTOR (3 downto 0);
           data_out_a : out STD_LOGIC_VECTOR (3 downto 0);
           data_out_b : out STD_LOGIC_VECTOR (3 downto 0);
           sel_a : in STD_LOGIC_VECTOR (2 downto 0);
           sel_b : in STD_LOGIC_VECTOR (2 downto 0));
end reg_bank;

architecture Behavioral of reg_bank is

type reg_array is array (0 to 7) of STD_LOGIC_VECTOR (3 downto 0);
signal registers : reg_array := (others => (others => '0'));
    
begin

-- R0 is hardwired to 0
    registers(0) <= "0000";
    
    process(clk, reset)
    begin
        if reset = '1' then
            for i in 1 to 7 loop
                registers(i) <= "0000";
            end loop;
        elsif rising_edge(clk) then
            for i in 0 to 7 loop
                if reg_enable(i) = '1' and i /= 0 then
                    registers(i) <= data_in;
                end if;
            end loop;
        end if;
    end process;
    
    data_out_a <= registers(to_integer(unsigned(sel_a)));
    data_out_b <= registers(to_integer(unsigned(sel_b)));


end Behavioral;
