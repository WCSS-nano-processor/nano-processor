----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 11:29:36 AM
-- Design Name: 
-- Module Name: tb_reg_bank - Behavioral
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

entity tb_reg_bank is
--  Port ( );
end tb_reg_bank;

architecture Behavioral of tb_reg_bank is

-- Component declaration
    component reg_bank
        Port ( clk : in STD_LOGIC;
               reset : in STD_LOGIC;
               reg_enable : in STD_LOGIC_VECTOR (7 downto 0);
               data_in : in STD_LOGIC_VECTOR (3 downto 0);
               data_out_a : out STD_LOGIC_VECTOR (3 downto 0);
               data_out_b : out STD_LOGIC_VECTOR (3 downto 0);
               sel_a : in STD_LOGIC_VECTOR (2 downto 0);
               sel_b : in STD_LOGIC_VECTOR (2 downto 0));
    end component;

 -- Signals
    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal reg_enable : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal data_in : STD_LOGIC_VECTOR (3 downto 0) := "0000";
    signal data_out_a : STD_LOGIC_VECTOR (3 downto 0);
    signal data_out_b : STD_LOGIC_VECTOR (3 downto 0);
    signal sel_a : STD_LOGIC_VECTOR (2 downto 0) := "000";
    signal sel_b : STD_LOGIC_VECTOR (2 downto 0) := "000";
    
begin

-- Instantiate DUT
    uut: reg_bank
        port map (
            clk => clk,
            reset => reset,
            reg_enable => reg_enable,
            data_in => data_in,
            data_out_a => data_out_a,
            data_out_b => data_out_b,
            sel_a => sel_a,
            sel_b => sel_b
        );

    -- Clock generation (10 ns period)
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 5 ns;
            clk <= '1';
            wait for 5 ns;
        end loop;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- ? Reset all registers
        reset <= '1';
        wait for 10 ns;
        reset <= '0';

        -- ? Try writing to R0 (should stay 0)
        reg_enable <= "00000001";  -- enable R0
        data_in <= "1111";
        wait for 10 ns;

        -- ? Write to R1
        reg_enable <= "00000010";
        data_in <= "1010";
        wait for 10 ns;

        -- ? Write to R2
        reg_enable <= "00000100";
        data_in <= "1100";
        wait for 10 ns;

        -- ? Write to R3
        reg_enable <= "00001000";
        data_in <= "0110";
        wait for 10 ns;

        -- ? Disable writes
        reg_enable <= (others => '0');

        -- ? Read test
        sel_a <= "001"; -- R1
        sel_b <= "010"; -- R2
        wait for 10 ns;

        sel_a <= "011"; -- R3
        sel_b <= "000"; -- R0 (should always be 0)
        wait for 10 ns;

        -- ? Overwrite R1
        reg_enable <= "00000010";
        data_in <= "0011";
        wait for 10 ns;

        reg_enable <= (others => '0');
        sel_a <= "001"; -- R1 updated value
        wait for 10 ns;

        -- Stop simulation
        wait;
    end process;
end Behavioral;
