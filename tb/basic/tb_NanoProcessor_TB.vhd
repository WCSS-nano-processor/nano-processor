----------------------------------------------------------------------------------
-- Top-Level Testbench for NanoProcessor
-- Tests: 1 + 2 + 3 = 6 in R7
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_NanoProcessor_TB is
end tb_NanoProcessor_TB;

architecture Behavioral of tb_NanoProcessor_TB is
    component NanoProcessor
        Port ( Clock : in STD_LOGIC;
               Reset : in STD_LOGIC;
               Overflow : out STD_LOGIC;
               Zero : out STD_LOGIC;
               S_7Seg : out STD_LOGIC_VECTOR(6 downto 0);
               anode : out STD_LOGIC_VECTOR(3 downto 0);
               Data : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    signal Clock   : STD_LOGIC := '0';
    signal Reset   : STD_LOGIC := '1';
    signal Overflow : STD_LOGIC;
    signal Zero    : STD_LOGIC;
    signal S_7Seg  : STD_LOGIC_VECTOR(6 downto 0);
    signal anode   : STD_LOGIC_VECTOR(3 downto 0);
    signal Data    : STD_LOGIC_VECTOR(3 downto 0);
    
    constant CLK_PERIOD : time := 20 ns;
    
begin
    UUT: NanoProcessor port map (
        Clock    => Clock,
        Reset    => Reset,
        Overflow => Overflow,
        Zero     => Zero,
        S_7Seg   => S_7Seg,
        anode    => anode,
        Data     => Data
    );
    
    -- Clock generation
    Clock <= not Clock after CLK_PERIOD/2;
    
    process
    begin
        report "Starting NanoProcessor Simulation";
        report "Program: 1 + 2 + 3 = 6, result stored in R7";
        
        -- Apply reset
        report "Applying Reset...";
        Reset <= '1';
        wait for CLK_PERIOD * 2;
        Reset <= '0';
        report "Reset released, processor running...";
        
        -- Allow enough cycles for the program to complete
        -- 8 instructions x a few cycles each
        wait for CLK_PERIOD * 20;
        
        -- Check final result
        report "Checking final output...";
        if Data = "0110" then
            report "SUCCESS: R7 = 6 (1 + 2 + 3 = 6 CORRECT)";
        else
            report "RESULT: Data = " &
                   std_logic'image(Data(3)) &
                   std_logic'image(Data(2)) &
                   std_logic'image(Data(1)) &
                   std_logic'image(Data(0));
        end if;
        
        if Zero = '0' then
            report "Zero flag = 0 (correct, result is non-zero)";
        else
            report "WARNING: Zero flag unexpectedly set";
        end if;
        
        if Overflow = '0' then
            report "Overflow flag = 0 (correct, no overflow)";
        else
            report "WARNING: Overflow flag set";
        end if;
        
        report "NanoProcessor Simulation Complete!";
        wait;
    end process;
end Behavioral;
