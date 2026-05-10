----------------------------------------------------------------------------------
-- Testbench for 14-bit Program ROM
-- Program: Count from -8 to +7 using ADD instructions
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity tb_Program_ROM_14bit is
end tb_Program_ROM_14bit;

architecture Behavioral of tb_Program_ROM_14bit is
    component Program_ROM_14bit
        port( program_counter : in ProgramCounter; instruction_out : out InstructionWord);
    end component;
    
    signal addr : ProgramCounter;
    signal instr : InstructionWord;
    
    -- Test addresses from team index last 3 bits
    constant ADDR_M1 : ProgramCounter := "010";  -- 2
    constant ADDR_M2 : ProgramCounter := "100";  -- 4
    constant ADDR_M3 : ProgramCounter := "101";  -- 5
    
    function to_string_14(instr : std_logic_vector(13 downto 0)) return string is
    begin
        return std_logic'image(instr(13)) & std_logic'image(instr(12)) &
               std_logic'image(instr(11)) & std_logic'image(instr(10)) &
               std_logic'image(instr(9)) & std_logic'image(instr(8)) &
               std_logic'image(instr(7)) & std_logic'image(instr(6)) &
               std_logic'image(instr(5)) & std_logic'image(instr(4)) &
               std_logic'image(instr(3)) & std_logic'image(instr(2)) &
               std_logic'image(instr(1)) & std_logic'image(instr(0));
    end function;
    
begin
    UUT: Program_ROM_14bit port map (program_counter => addr, instruction_out => instr);
    
    process
    begin
        report "==========================================================";
        report "Testing 14-bit Program ROM";
        report "Program: Count from -8 to +7 using ADD";
        report "==========================================================";
        
        -- Test all addresses 0-7
        for i in 0 to 7 loop
            addr <= std_logic_vector(to_unsigned(i, 3));
            wait for 20 ns;
            report "Addr=" & integer'image(i) & " Instruction=" & to_string_14(instr);
        end loop;
        
        -- Test specific addresses from team indexes
        report "";
        report "Testing team index addresses:";
        
        addr <= ADDR_M1;
        wait for 20 ns;
        report "  Addr=M1(010=2): " & to_string_14(instr);
        
        addr <= ADDR_M2;
        wait for 20 ns;
        report "  Addr=M2(100=4): " & to_string_14(instr);
        
        addr <= ADDR_M3;
        wait for 20 ns;
        report "  Addr=M3(101=5): " & to_string_14(instr);
        
        report "==========================================================";
        report "Program_ROM Tests Complete!";
        report "==========================================================";
        wait;
    end process;
end Behavioral;
