----------------------------------------------------------------------------------
-- Constants Package
-- Instruction opcodes and control constants
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

package Constants is
    -- Instruction opcodes (2 bits)
    constant ADD_OP   : std_logic_vector(1 downto 0) := "00";
    constant NEG_OP   : std_logic_vector(1 downto 0) := "01";
    constant MOVI_OP  : std_logic_vector(1 downto 0) := "10";
    constant JZR_OP   : std_logic_vector(1 downto 0) := "11";
    
    -- ALU operation selects
    constant ALU_ADD  : std_logic := '0';
    constant ALU_SUB  : std_logic := '1';
    
    -- Load select modes
    constant LOAD_IMMEDIATE : std_logic := '0';
    constant LOAD_REGISTER  : std_logic := '1';
    
    -- Register R0 address (hardwired to zero)
    constant REG_ZERO : RegisterSelect := "000";
    
    -- Clock constants (for simulation)
    constant CLK_PERIOD : time := 10 ns;
    
end package Constants;