----------------------------------------------------------------------------------
-- Instruction Decoder - 14-bit Extended Version
-- Supports: MOVI, ADD, SUB, NEG, JZR, IN, MUL, AND, OR, XOR, NOT, CMP
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity Instruction_Decoder_14bit is
    port (
        Instruction              : in  InstructionWord;  -- 14-bit
        Register_Value_For_Jump : in  DataBus;
        Register_Enable         : out RegisterSelect;
        Register_Select_A       : out RegisterSelect;
        Register_Select_B       : out RegisterSelect;
        ALU_Op_Sel              : out ALU_Op_Select;
        Immediate_Value         : out DataBus;
        Jump_Enable             : out STD_LOGIC;
        Jump_Address            : out ProgramCounter;
        Load_Select             : out STD_LOGIC;
        Input_Enable            : out STD_LOGIC
    );
end Instruction_Decoder_14bit;

architecture Behavioral of Instruction_Decoder_14bit is
    signal Opcode : std_logic_vector(3 downto 0);
    signal R1, R2 : std_logic_vector(2 downto 0);
    signal Func_Imm : std_logic_vector(3 downto 0);
    signal Imm4 : std_logic_vector(3 downto 0);
    signal JumpAddr3 : std_logic_vector(2 downto 0);
    
begin
    -- Extract fields from 14-bit instruction
    Opcode <= Instruction(13 downto 10);
    R1     <= Instruction(9 downto 7);
    R2     <= Instruction(6 downto 4);
    Func_Imm <= Instruction(3 downto 0);
    Imm4   <= Instruction(3 downto 0);
    JumpAddr3 <= Instruction(2 downto 0);
    
    decode: process(Opcode, R1, R2, Func_Imm, Imm4, JumpAddr3, Register_Value_For_Jump)
    begin
        -- Default values
        Jump_Enable      <= '0';
        Immediate_Value  <= "0000";
        Load_Select      <= LOAD_IMMEDIATE;
        Register_Enable  <= "000";
        ALU_Op_Sel       <= ALU_ADD;
        Register_Select_A <= REG_ZERO;
        Register_Select_B <= REG_ZERO;
        Jump_Address     <= "000";
        Input_Enable     <= '0';
        
        case Opcode is
            when MOVI_OP =>  -- MOVI R1, d
                Immediate_Value <= Imm4;
                Load_Select     <= LOAD_IMMEDIATE;
                Register_Enable <= R1;
                
            when ADD_OP =>  -- ADD R1, R2
                Register_Select_A <= R1;
                Register_Select_B <= R2;
                ALU_Op_Sel       <= ALU_ADD;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when SUB_OP =>  -- SUB R1, R2
                Register_Select_A <= R1;
                Register_Select_B <= R2;
                ALU_Op_Sel       <= ALU_SUB;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when NEG_OP =>  -- NEG R1
                Register_Select_A <= REG_ZERO;
                Register_Select_B <= R1;
                ALU_Op_Sel       <= ALU_NEG;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when JZR_OP =>  -- JZR R1, d
                Register_Select_A <= R1;
                Register_Enable   <= "000";
                if Register_Value_For_Jump = "0000" then
                    Jump_Enable   <= '1';
                    Jump_Address  <= JumpAddr3;
                end if;
                
            when IN_OP =>   -- IN R1
                Register_Enable <= R1;
                Input_Enable    <= '1';
                Load_Select     <= LOAD_IMMEDIATE;
                
            when MUL_OP =>  -- MUL R1, R2
                Register_Select_A <= R1;
                Register_Select_B <= R2;
                ALU_Op_Sel       <= ALU_MUL;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when AND_OP =>  -- AND R1, R2
                Register_Select_A <= R1;
                Register_Select_B <= R2;
                ALU_Op_Sel       <= ALU_AND;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when OR_OP =>   -- OR R1, R2
                Register_Select_A <= R1;
                Register_Select_B <= R2;
                ALU_Op_Sel       <= ALU_OR;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when XOR_OP =>  -- XOR R1, R2
                Register_Select_A <= R1;
                Register_Select_B <= R2;
                ALU_Op_Sel       <= ALU_XOR;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when NOT_OP =>  -- NOT R1
                Register_Select_A <= R1;
                Register_Select_B <= REG_ZERO;
                ALU_Op_Sel       <= ALU_NOT;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= R1;
                
            when CMP_OP =>  -- CMP R1, R2 (no register write)
                Register_Select_A <= R1;
                Register_Select_B <= R2;
                ALU_Op_Sel       <= ALU_CMP;
                Load_Select       <= LOAD_REGISTER;
                Register_Enable   <= "000";  -- No write for comparison!
                
            when others =>
                null;
        end case;
    end process;
    
end Behavioral;