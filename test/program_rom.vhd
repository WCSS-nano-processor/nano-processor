----------------------------------------------------------------------------------
-- Program ROM
-- Stores machine code program
-- Program: Sum of 1 + 2 + 3 = 6 stored in R7
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity Program_ROM is
    port( program_counter : in  ProgramCounter;
          instruction_out : out InstructionWord);
end Program_ROM;

architecture Behavioral of Program_ROM is
    type instruction_memory_type is array (0 to 7) of std_logic_vector(11 downto 0);
    
    -- Program: Sum of 1 to 3 = 6 in R7
    -- Assembly:
    --   0: MOVI R7, 0
    --   1: MOVI R1, 1
    --   2: MOVI R2, 2
    --   3: MOVI R3, 3
    --   4: ADD R7, R1
    --   5: ADD R7, R2
    --   6: ADD R7, R3
    --   7: JZR R0, 4  (infinite loop)
    --
    signal program_instructions : instruction_memory_type := (
        "100010000001",  -- 1: MOVI R1, 1
        "100100000010",  -- 2: MOVI R2, 2
        "100110000011",  -- 3: MOVI R3, 3
        "101110000000",  -- 0: MOVI R7, 0
        "001110010000",  -- 4: ADD R7, R1
        "001110100000",  -- 5: ADD R7, R2
        "001110110000",  -- 6: ADD R7, R3
        "110000000011"   -- 7: JZR R0, 3
    );
        
begin
    instruction_out <= program_instructions(to_integer(unsigned(program_counter)));
end Behavioral;