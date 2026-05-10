----------------------------------------------------------------------------------
-- Constants Package - 14-BIT EXTENDED ISA
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

package Constants is
    -- Instruction opcodes (4 bits for 14-bit ISA)
    constant MOVI_OP  : std_logic_vector(3 downto 0) := "0000";
    constant ADD_OP   : std_logic_vector(3 downto 0) := "0001";
    constant SUB_OP   : std_logic_vector(3 downto 0) := "0010";
    constant NEG_OP   : std_logic_vector(3 downto 0) := "0011";
    constant JZR_OP   : std_logic_vector(3 downto 0) := "0100";
    constant IN_OP    : std_logic_vector(3 downto 0) := "0101";
    constant MUL_OP   : std_logic_vector(3 downto 0) := "0110";
    constant AND_OP   : std_logic_vector(3 downto 0) := "0111";
    constant OR_OP    : std_logic_vector(3 downto 0) := "1000";
    constant XOR_OP   : std_logic_vector(3 downto 0) := "1001";
    constant NOT_OP   : std_logic_vector(3 downto 0) := "1010";
    constant CMP_OP   : std_logic_vector(3 downto 0) := "1011";
    
    -- ALU operation selects (4 bits)
    constant ALU_ADD  : ALU_Op_Select := "0000";
    constant ALU_SUB  : ALU_Op_Select := "0001";
    constant ALU_NEG  : ALU_Op_Select := "0010";
    constant ALU_MUL  : ALU_Op_Select := "0011";
    constant ALU_AND  : ALU_Op_Select := "0100";
    constant ALU_OR   : ALU_Op_Select := "0101";
    constant ALU_XOR  : ALU_Op_Select := "0110";
    constant ALU_NOT  : ALU_Op_Select := "0111";
    constant ALU_CMP  : ALU_Op_Select := "1000";
    
    -- Load select modes
    constant LOAD_IMMEDIATE : std_logic := '0';
    constant LOAD_REGISTER  : std_logic := '1';
    
    -- Register R0 address (hardwired to zero)
    constant REG_ZERO : RegisterSelect := "000";
    
    -- Clock constants (for simulation)
    constant CLK_PERIOD : time := 10 ns;
    
end package Constants;