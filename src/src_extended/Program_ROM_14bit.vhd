----------------------------------------------------------------------------------
-- Program ROM - 14-bit Extended ISA
-- Count from -8 to +7 using ADD instruction (fits in 8 ROM locations)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity Program_ROM_14bit is
    port( program_counter : in  ProgramCounter;
          instruction_out : out InstructionWord);
end Program_ROM_14bit;

architecture Behavioral of Program_ROM_14bit is
    type instruction_memory_type is array (0 to 7) of std_logic_vector(13 downto 0);
    
    -- Format: OOOO RRR RRR FFFF (14 bits total)
    --        4    3    3    4 = 14 bits
    --
    -- MOVI R7, -8: 0000 111 000 1000 = "00001110001000"
    -- MOVI R1, 1: 0000 001 000 0001 = "00000010000001"
    -- ADD R7, R1: 0001 111 001 0000 = "00011110010000"
    -- JZR R0, 2:  0100 000 000 0010 = "01000000000010"
    --
    signal program_instructions : instruction_memory_type := (
        "00001110001000",  -- 0: MOVI R7, -8     (R7 = -8 in signed)
        "00000010000001",  -- 1: MOVI R1, 1     (R1 = 1)
        "00011110010000",  -- 2: ADD R7, R1     (R7 = R7 + 1)
        "00011110010000",  -- 3: ADD R7, R1     (R7 = R7 + 1)
        "00011110010000",  -- 4: ADD R7, R1     (R7 = R7 + 1)
        "00011110010000",  -- 5: ADD R7, R1     (R7 = R7 + 1)
        "00011110010000",  -- 6: ADD R7, R1     (R7 = R7 + 1)
        "01000000000010"   -- 7: JZR R0, 2      (Jump to address 2 - loop)
    );
        
begin
    instruction_out <= program_instructions(to_integer(unsigned(program_counter)));
end Behavioral;