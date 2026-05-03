----------------------------------------------------------------------------------
-- 3-bit Program Counter with Reset
-- Uses D Flip-Flops with asynchronous reset
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity Program_Counter is
    Port ( PC_Next    : in  ProgramCounter;
           Res        : in  STD_LOGIC;
           Clk        : in  STD_LOGIC;
           PC_Current : out ProgramCounter);
end Program_Counter;

architecture Behavioral of Program_Counter is
    -- D_FF component declaration
    component D_FF
        Port ( D   : in  STD_LOGIC;
               Res : in  STD_LOGIC;
               Clk : in  STD_LOGIC;
               Q   : out STD_LOGIC;
               Qbar: out STD_LOGIC);
    end component;
    
    -- Internal signals for flip-flop outputs
    signal q0, q1, q2 : STD_LOGIC;
    
begin
    -- Instantiate 3 D Flip-Flops (one for each bit)
    DFF0: D_FF port map (D => PC_Next(0), Res => Res, Clk => Clk, Q => q0, Qbar => open);
    DFF1: D_FF port map (D => PC_Next(1), Res => Res, Clk => Clk, Q => q1, Qbar => open);
    DFF2: D_FF port map (D => PC_Next(2), Res => Res, Clk => Clk, Q => q2, Qbar => open);
    
    -- Combine individual bits into 3-bit output
    PC_Current <= q2 & q1 & q0;
    
end Behavioral;