----------------------------------------------------------------------------------
-- 4-bit Ripple Carry Adder (RCA_4)
-- Used for ALU addition/subtraction
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RCA_4 is
    Port ( A0, A1, A2, A3 : in  STD_LOGIC;
           B0, B1, B2, B3 : in  STD_LOGIC;
           C_in           : in  STD_LOGIC;
           S0, S1, S2, S3 : out STD_LOGIC;
           C_out          : out STD_LOGIC);
end RCA_4;

architecture Structural of RCA_4 is
    component FA
        port ( A, B, C_in : in  STD_LOGIC;
               S, C_out   : out STD_LOGIC);
    end component;
    
    signal C1, C2, C3 : STD_LOGIC;
    
begin
    FA0: FA port map (A0, B0, C_in,  S0, C1);
    FA1: FA port map (A1, B1, C1,    S1, C2);
    FA2: FA port map (A2, B2, C2,    S2, C3);
    FA3: FA port map (A3, B3, C3,    S3, C_out);
end Structural;