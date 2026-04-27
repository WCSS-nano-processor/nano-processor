----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 11:40:47 AM
-- Design Name: 
-- Module Name: tb_mux_2way_4bit - Behavioral
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

entity tb_mux_2way_4bit is
--  Port ( );
end tb_mux_2way_4bit;

architecture Behavioral of tb_mux_2way_4bit is

-- Component declaration
    component mux_2way_4bit
        Port ( Sel : in STD_LOGIC;
               In0 : in STD_LOGIC_VECTOR (3 downto 0);
               In1 : in STD_LOGIC_VECTOR (3 downto 0);
               Output : out STD_LOGIC_VECTOR (3 downto 0));
    end component;

    -- Signals
    signal Sel : STD_LOGIC := '0';
    signal In0 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal In1 : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal Output : STD_LOGIC_VECTOR (3 downto 0);
    
begin

 -- Instantiate DUT
    uut: mux_2way_4bit
        port map (
            Sel => Sel,
            In0 => In0,
            In1 => In1,
            Output => Output
        );

    -- Stimulus process
    stim_proc: process
    begin
        -- Test 1: Sel = 0 ? Output = In0
        Sel <= '0';
        In0 <= "1010";
        In1 <= "0101";
        wait for 10 ns;

        -- Test 2: Sel = 1 ? Output = In1
        Sel <= '1';
        wait for 10 ns;

        -- Test 3: Change inputs with Sel = 0
        Sel <= '0';
        In0 <= "1111";
        In1 <= "0000";
        wait for 10 ns;

        -- Test 4: Change inputs with Sel = 1
        Sel <= '1';
        wait for 10 ns;

        -- Test 5: Both inputs same
        In0 <= "1100";
        In1 <= "1100";
        Sel <= '0';
        wait for 10 ns;

        Sel <= '1';
        wait for 10 ns;

        -- Stop simulation
        wait;
    end process;
end Behavioral;
