----------------------------------------------------------------------------------
-- Slow Clock Generator - FOR BASYS3 (100MHz)
-- Set SIMULATION_MODE = true for simulation, false for hardware
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Slow_Clk is
    Generic (
        SIMULATION_MODE : boolean := true  -- true for simulation, false for hardware
    );
    Port ( Clk_in  : in  STD_LOGIC;
           Clk_out : out STD_LOGIC);
end Slow_Clk;

architecture Behavioral of Slow_Clk is
    signal count : integer := 0;
    signal clk_state : std_logic := '0';
    constant MAX_COUNT : integer := 50000000;  -- 0.5 seconds at 100MHz
    constant SIM_COUNT : integer := 5;          -- Fast for simulation
begin
    process(Clk_in)
    begin
        if rising_edge(Clk_in) then
            if SIMULATION_MODE then
                -- Simulation mode: very fast
                if count = SIM_COUNT - 1 then
                    clk_state <= not clk_state;
                    Clk_out <= clk_state;
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            else
                -- Hardware mode: 0.5 second per half cycle
                if count = MAX_COUNT - 1 then
                    clk_state <= not clk_state;
                    Clk_out <= clk_state;
                    count <= 0;
                else
                    count <= count + 1;
                end if;
            end if;
        end if;
    end process;
end Behavioral;