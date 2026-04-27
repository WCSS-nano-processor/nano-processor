----------------------------------------------------------------------------------
-- Bus Definitions Package
-- Common data types for the nanoprocessor
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package BusDefinitions is
    -- 4-bit data bus
    subtype DataBus is std_logic_vector(3 downto 0);
    
    -- 3-bit register select (for 8 registers)
    subtype RegisterSelect is std_logic_vector(2 downto 0);
    
    -- 3-bit program counter (for 8 ROM locations)
    subtype ProgramCounter is std_logic_vector(2 downto 0);
    
    -- 12-bit instruction word
    subtype InstructionWord is std_logic_vector(11 downto 0);
    
    -- 8-bit register enable (one-hot encoded)
    subtype RegisterEnable is std_logic_vector(7 downto 0);
    
    -- Register file array type
    type RegisterFile is array (7 downto 0) of DataBus;
    
end package BusDefinitions;