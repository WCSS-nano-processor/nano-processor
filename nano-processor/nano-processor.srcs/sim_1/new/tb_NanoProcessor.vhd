----------------------------------------------------------------------------------
-- Testbench for NanoProcessor
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Constants.all;

entity tb_NanoProcessor is
end tb_NanoProcessor;

architecture Behavioral of tb_NanoProcessor is
    component NanoProcessor
        port( Clock   : in  STD_LOGIC;
              Reset   : in  STD_LOGIC;
              Overflow: out STD_LOGIC;
              Zero    : out STD_LOGIC;
              S_7Seg  : out STD_LOGIC_VECTOR(6 downto 0);
              anode   : out STD_LOGIC_VECTOR(3 downto 0);
              Data    : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    signal Clock : STD_LOGIC := '0';
    signal Reset : STD_LOGIC := '1';
    signal Overflow, Zero : STD_LOGIC;
    signal S_7Seg : STD_LOGIC_VECTOR(6 downto 0);
    signal anode : STD_LOGIC_VECTOR(3 downto 0);
    signal Data : STD_LOGIC_VECTOR(3 downto 0);
    
begin
    UUT: NanoProcessor port map (Clock => Clock, Reset => Reset,
                                 Overflow => Overflow, Zero => Zero,
                                 S_7Seg => S_7Seg, anode => anode, Data => Data);
    
    -- Clock generation (for simulation - fast clock)
    Clock <= not Clock after CLK_PERIOD/2;
    
    -- Stimulus process
    stim: process
    begin
        Reset <= '1';
        wait for 100 ns;
        Reset <= '0';
        wait;
    end process;
    
end Behavioral;