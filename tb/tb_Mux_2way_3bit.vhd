----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 03:49:12 PM
-- Design Name: 
-- Module Name: tb_Mux_2way_3bit - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_Mux_2way_3bit is
--  Port ( );
end tb_Mux_2way_3bit;

architecture Behavioral of tb_Mux_2way_3bit is

-- Component declaration
    component Mux_2way_3bit
        Port ( Input_0 : in  STD_LOGIC_VECTOR (2 downto 0);
               Input_1 : in  STD_LOGIC_VECTOR (2 downto 0);
               Sel     : in  STD_LOGIC;
               Output  : out STD_LOGIC_VECTOR (2 downto 0));
    end component;

    -- Signals
    signal Input_0 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal Input_1 : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal Sel     : STD_LOGIC := '0';
    signal Output  : STD_LOGIC_VECTOR (2 downto 0);
    

begin

-- Instantiate DUT
    uut: Mux_2way_3bit
        port map (
            Input_0 => Input_0,
            Input_1 => Input_1,
            Sel     => Sel,
            Output  => Output
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- ? Test 1: Sel = 0 ? Output = Input_0
        Input_0 <= "101";
        Input_1 <= "010";
        Sel <= '0';
        wait for 10 ns;

        -- ? Test 2: Sel = 1 ? Output = Input_1
        Sel <= '1';
        wait for 10 ns;

        -- ? Test 3: Change inputs while Sel = 0
        Sel <= '0';
        Input_0 <= "111";
        Input_1 <= "000";
        wait for 10 ns;

        -- ? Test 4: Change inputs while Sel = 1
        Sel <= '1';
        wait for 10 ns;

        -- ? Test 5: Both inputs equal
        Input_0 <= "110";
        Input_1 <= "110";
        Sel <= '0';
        wait for 10 ns;

        Sel <= '1';
        wait for 10 ns;

        -- ? Test 6: Rapid switching
        Input_0 <= "011";
        Input_1 <= "100";

        Sel <= '0'; wait for 5 ns;
        Sel <= '1'; wait for 5 ns;
        Sel <= '0'; wait for 5 ns;
        Sel <= '1'; wait for 5 ns;

        -- End simulation
        wait;
    end process;


end Behavioral;