----------------------------------------------------------------------------------
-- Instruction Decoder
-- Decodes 12-bit instruction and generates all control signals
--
-- Instruction Formats:
--   MOVI R, d  : 10 RRR 0001 dddd
--   ADD Ra, Rb : 00 RaRaRa RbRbRb 0000
--   NEG R      : 01 RRR 0000 0000
--   JZR R, d   : 11 RRR 0000 0ddd
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Instruction_Decoder is
    port (
        Instruction              : in  InstructionWord;
        Register_Value_For_Jump : in  DataBus;
        Register_Enable         : out RegisterSelect;
        Register_Select_A       : out RegisterSelect;
        Register_Select_B       : out RegisterSelect;
        Operation_Select        : out STD_LOGIC;
        Immediate_Value         : out DataBus;
        Jump_Enable             : out STD_LOGIC;
        Jump_Address            : out ProgramCounter;
        Load_Select             : out STD_LOGIC
    );
end Instruction_Decoder;

architecture Behavioral of Instruction_Decoder is
    signal Opcode : std_logic_vector(1 downto 0);
begin
    Opcode <= Instruction(11 downto 10);
    
    decode: process(Opcode, Register_Value_For_Jump, Instruction)
    begin
        -- Default values to prevent latches
        Jump_Enable      <= '0';
        Immediate_Value  <= "0000";
        Load_Select      <= LOAD_IMMEDIATE;
        Register_Enable  <= "000";
        Operation_Select <= ALU_ADD;
        Register_Select_A <= REG_ZERO;
        Register_Select_B <= REG_ZERO;
        Jump_Address     <= "000";
        
        case Opcode is
            when MOVI_OP =>  -- MOVI R, d
                Immediate_Value <= Instruction(3 downto 0);
                Load_Select     <= LOAD_IMMEDIATE;
                Register_Enable <= Instruction(9 downto 7);
                
            when ADD_OP =>  -- ADD Ra, Rb
                Register_Select_A <= Instruction(9 downto 7);
                Register_Select_B <= Instruction(6 downto 4);
                Operation_Select  <= ALU_ADD;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= Instruction(9 downto 7);
                
            when NEG_OP =>  -- NEG R (0 - R)
                Register_Select_A <= REG_ZERO;
                Register_Select_B <= Instruction(9 downto 7);
                Operation_Select  <= ALU_SUB;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= Instruction(9 downto 7);
                
            when JZR_OP =>  -- JZR R, d
                Register_Select_A <= Instruction(9 downto 7);
                Register_Enable   <= "000";
                
                if Register_Value_For_Jump = "0000" then
                    Jump_Enable   <= '1';
                    Jump_Address  <= Instruction(2 downto 0);
                else
                    Jump_Enable   <= '0';
                end if;
                
            when others =>
                null;
        end case;
    end process decode;
end Behavioral;