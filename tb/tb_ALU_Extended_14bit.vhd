----------------------------------------------------------------------------------
-- Testbench for Extended ALU (14-bit ISA)
-- Tests: ADD, SUB, NEG, MUL, AND, OR, XOR, NOT, CMP
-- Using LAST 4 BINARY DIGITS of team index numbers
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity tb_ALU_Extended_14bit is
end tb_ALU_Extended_14bit;

architecture Behavioral of tb_ALU_Extended_14bit is
    component ALU_Extended_14bit
        Port ( Input_A : in DataBus; Input_B : in DataBus; Op_Sel : in ALU_Op_Select;
               Result : out DataBus; Zero_Flag : out STD_LOGIC; Overflow_Flag : out STD_LOGIC;
               CMP_Equal : out STD_LOGIC; CMP_Less : out STD_LOGIC; CMP_Greater : out STD_LOGIC);
    end component;
    
    signal A, B, Result : DataBus;
    signal Op_Sel : ALU_Op_Select;
    signal Zero_Flag, Overflow_Flag : STD_LOGIC;
    signal CMP_Equal, CMP_Less, CMP_Greater : STD_LOGIC;
    
    -- Test values from LAST 4 BINARY DIGITS
    constant M1_VAL : DataBus := "0010";  -- Member1: 2
    constant M2_VAL : DataBus := "1100";  -- Member2: 12 (-4)
    constant M3_VAL : DataBus := "1101";  -- Member3: 13 (-3)
    constant M4_VAL : DataBus := "1100";  -- Member4: 12 (-4)
    
begin
    UUT: ALU_Extended_14bit port map (
        Input_A => A, Input_B => B, Op_Sel => Op_Sel,
        Result => Result, Zero_Flag => Zero_Flag, Overflow_Flag => Overflow_Flag,
        CMP_Equal => CMP_Equal, CMP_Less => CMP_Less, CMP_Greater => CMP_Greater
    );
    
    process
    begin
        report "==========================================================";
        report "Testing Extended ALU with Team Index Bits";
        report "M1=2(0010), M2=-4(1100), M3=-3(1101), M4=-4(1100)";
        report "==========================================================";
        
        -- ========== ADDITION ==========
        report "--- ADDITION (ADD_OP) ---";
        Op_Sel <= ALU_ADD;
        
        A <= M1_VAL; B <= M2_VAL; wait for 20 ns;
        report "Test1: 2 + (-4) = -2 (1110)";
        
        A <= M3_VAL; B <= M4_VAL; wait for 20 ns;
        report "Test2: (-3) + (-4) = -7 (1001)";
        
        -- ========== SUBTRACTION ==========
        report "--- SUBTRACTION (SUB_OP) ---";
        Op_Sel <= ALU_SUB;
        
        A <= M2_VAL; B <= M1_VAL; wait for 20 ns;
        report "Test3: (-4) - 2 = -6 (1010)";
        
        A <= M4_VAL; B <= M3_VAL; wait for 20 ns;
        report "Test4: (-4) - (-3) = -1 (1111)";
        
        -- ========== NEGATION ==========
        report "--- NEGATION (NEG_OP) ---";
        Op_Sel <= ALU_NEG;
        
        A <= M1_VAL; B <= "0000"; wait for 20 ns;
        report "Test5: NEG 2 = -2 (1110)";
        
        A <= M2_VAL; wait for 20 ns;
        report "Test6: NEG -4 = 4 (0100)";
        
        -- ========== MULTIPLICATION ==========
        report "--- MULTIPLICATION (MUL_OP) ---";
        Op_Sel <= ALU_MUL;
        
        A <= "0010"; B <= "0011"; wait for 20 ns;
        report "Test7: 2 x 3 = 6 (0110)";
        
        A <= M2_VAL; B <= M1_VAL; wait for 20 ns;
        report "Test8: (-4) x 2 = -8 (1000)";
        
        -- ========== LOGICAL AND ==========
        report "--- LOGICAL AND (AND_OP) ---";
        Op_Sel <= ALU_AND;
        
        A <= "1010"; B <= "1100"; wait for 20 ns;
        report "Test9: 1010 AND 1100 = 1000 (8)";
        
        -- ========== LOGICAL OR ==========
        report "--- LOGICAL OR (OR_OP) ---";
        Op_Sel <= ALU_OR;
        
        A <= "1010"; B <= "1100"; wait for 20 ns;
        report "Test10: 1010 OR 1100 = 1110 (14)";
        
        -- ========== LOGICAL XOR ==========
        report "--- LOGICAL XOR (XOR_OP) ---";
        Op_Sel <= ALU_XOR;
        
        A <= "1010"; B <= "1100"; wait for 20 ns;
        report "Test11: 1010 XOR 1100 = 0110 (6)";
        
        -- ========== LOGICAL NOT ==========
        report "--- LOGICAL NOT (NOT_OP) ---";
        Op_Sel <= ALU_NOT;
        
        A <= "1010"; wait for 20 ns;
        report "Test12: NOT 1010 = 0101 (5)";
        
        -- ========== COMPARISON ==========
        report "--- COMPARISON (CMP_OP) ---";
        Op_Sel <= ALU_CMP;
        
        A <= M1_VAL; B <= M1_VAL; wait for 20 ns;
        report "Test13: 2 == 2 => EQUAL=1";
        
        A <= M1_VAL; B <= M3_VAL; wait for 20 ns;
        report "Test14: 2 < -3? => LESS=1";
        
        A <= M4_VAL; B <= M2_VAL; wait for 20 ns;
        report "Test15: -4 == -4 => EQUAL=1";
        
        report "==========================================================";
        report "Extended ALU Tests Complete!";
        report "==========================================================";
        wait;
    end process;
end Behavioral;
