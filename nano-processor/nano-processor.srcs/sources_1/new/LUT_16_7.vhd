----------------------------------------------------------------------------------
-- 7-Segment Display LUT (Look-Up Table)
-- Converts 4-bit binary to 7-segment pattern (active low for BASYS3)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity LUT_16_7 is
    Port ( binary_in : in  STD_LOGIC_VECTOR (3 downto 0);
           seven_seg : out STD_LOGIC_VECTOR (6 downto 0));
end LUT_16_7;

architecture Behavioral of LUT_16_7 is
    type rom_type is array (0 to 15) of std_logic_vector(6 downto 0);
    
    -- 7-segment patterns: a b c d e f g (active low)
    -- 0 = ON, 1 = OFF for common anode BASYS3
    constant sevenSegment_ROM : rom_type := (
        "1000000",  -- 0
        "1111001",  -- 1
        "0100100",  -- 2
        "0110000",  -- 3
        "0011001",  -- 4
        "0010010",  -- 5
        "0000010",  -- 6
        "1111000",  -- 7
        "0000000",  -- 8
        "0010000",  -- 9
        "0001000",  -- A (10)
        "0000011",  -- b (11)
        "1000110",  -- C (12)
        "0100001",  -- d (13)
        "0000110",  -- E (14)
        "0001110"   -- F (15)
    );
    
begin
    seven_seg <= sevenSegment_ROM(to_integer(unsigned(binary_in)));
end Behavioral;