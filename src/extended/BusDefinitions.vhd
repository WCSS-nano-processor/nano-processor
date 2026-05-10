----------------------------------------------------------------------------------
-- Bus Definitions Package - 14-BIT VERSION (CONFIRMED)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package BusDefinitions is
    -- 4-bit data bus (4-bit data, 14-bit instructions!)
    -- Your ALU processes 4-bit values - this is CORRECT!
    subtype DataBus is std_logic_vector(3 downto 0);
    
    -- 3-bit register select (for 8 registers)
    subtype RegisterSelect is std_logic_vector(2 downto 0);
    
    -- 3-bit program counter (for 8 ROM locations)
    subtype ProgramCounter is std_logic_vector(2 downto 0);
    
    -- 14-bit instruction word (EXTENDED!)
    subtype InstructionWord is std_logic_vector(13 downto 0);
    
    -- 8-bit register enable (one-hot encoded)
    subtype RegisterEnable is std_logic_vector(7 downto 0);
    
    -- ALU operation select (4 bits)
    subtype ALU_Op_Select is std_logic_vector(3 downto 0);
    
    -- Register file array type
    type RegisterFile is array (0 to 7) of DataBus;
    
end package BusDefinitions;