----------------------------------------------------------------------------------
-- Program ROM - FIXED VERSION
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
    
    -- INSTRUCTIONS IN CORRECT ORDER (PC starts at 0)
    signal program_instructions : instruction_memory_type := (
        "101110000000",  -- 0: MOVI R7, 0     (R7 = 0)
        "100010000001",  -- 1: MOVI R1, 1     (R1 = 1)
        "100100000010",  -- 2: MOVI R2, 2     (R2 = 2)
        "100110000011",  -- 3: MOVI R3, 3     (R3 = 3)
        "001110010000",  -- 4: ADD R7, R1     (R7 = 0+1 = 1)
        "001110100000",  -- 5: ADD R7, R2     (R7 = 1+2 = 3)
        "001110110000",  -- 6: ADD R7, R3     (R7 = 3+3 = 6)
        "110000000100"   -- 7: JZR R0, 4      (Jump to address 4 - infinite loop)
    );
        
begin
    instruction_out <= program_instructions(to_integer(unsigned(program_counter)));
end Behavioral;