----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 11:17:56 AM
-- Design Name: 
-- Module Name: tb_decoder_3to8 - Behavioral
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

entity tb_decoder_3to8 is
--  Port ( );
end tb_decoder_3to8;

architecture Behavioral of tb_decoder_3to8 is

-- Component declaration
    component decoder_3to8
        Port ( A  : in STD_LOGIC_VECTOR (2 downto 0);
               EN : in STD_LOGIC;
               Y  : out STD_LOGIC_VECTOR (7 downto 0));
    end component;

    -- Signals to connect to DUT (Device Under Test)
    signal A  : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal EN : STD_LOGIC := '0';
    signal Y  : STD_LOGIC_VECTOR (7 downto 0);

begin

-- Instantiate the DUT
    uut: decoder_3to8
        port map (
            A  => A,
            EN => EN,
            Y  => Y
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test with EN = 0 (all outputs should be 0)
        EN <= '0';
        for i in 0 to 7 loop
            A <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;

        -- Enable decoder
        EN <= '1';
        for i in 0 to 7 loop
            A <= std_logic_vector(to_unsigned(i, 3));
            wait for 10 ns;
        end loop;

        -- Disable again
        EN <= '0';
        A <= "101";
        wait for 10 ns;

        -- Stop simulation
        wait;
    end process;


end Behavioral;
