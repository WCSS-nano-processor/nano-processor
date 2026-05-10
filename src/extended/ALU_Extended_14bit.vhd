----------------------------------------------------------------------------------
-- Extended ALU - 14-bit ISA Version (VHDL 93/2002 Compatible)
-- Supports: ADD, SUB, NEG, MUL, AND, OR, XOR, NOT, CMP
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;
use work.Constants.all;

entity ALU_Extended_14bit is
    Port ( Input_A     : in  DataBus;
           Input_B     : in  DataBus;
           Op_Sel      : in  ALU_Op_Select;
           Result      : out DataBus;
           Zero_Flag   : out STD_LOGIC;
           Overflow_Flag : out STD_LOGIC;
           CMP_Equal   : out STD_LOGIC;
           CMP_Less    : out STD_LOGIC;
           CMP_Greater : out STD_LOGIC);
end ALU_Extended_14bit;

architecture Behavioral of ALU_Extended_14bit is
    signal A_s, B_s, Result_s : signed(3 downto 0);
    signal A_u, B_u, Result_u : unsigned(3 downto 0);
    signal Mul_Result : signed(7 downto 0);
    signal Logic_Result : DataBus;
    signal temp_result : DataBus;
    signal temp_overflow : STD_LOGIC;
    
begin
    A_s <= signed(Input_A);
    B_s <= signed(Input_B);
    A_u <= unsigned(Input_A);
    B_u <= unsigned(Input_B);
    
    -- Main ALU process (using if-elsif-else instead of case with multi-conditions)
    process(Input_A, Input_B, A_s, B_s, Op_Sel)
        variable mul_temp : signed(7 downto 0);
    begin
        temp_overflow <= '0';
        
        -- ADD Operation
        if Op_Sel = ALU_ADD then
            Result_s <= A_s + B_s;
            temp_result <= std_logic_vector(Result_s);
            if (A_s(3) = B_s(3) and Result_s(3) /= A_s(3)) then
                temp_overflow <= '1';
            else
                temp_overflow <= '0';
            end if;
            
        -- SUB Operation
        elsif Op_Sel = ALU_SUB then
            Result_s <= A_s - B_s;
            temp_result <= std_logic_vector(Result_s);
            if (A_s(3) /= B_s(3) and Result_s(3) /= A_s(3)) then
                temp_overflow <= '1';
            else
                temp_overflow <= '0';
            end if;
            
        -- NEG Operation
        elsif Op_Sel = ALU_NEG then
            Result_s <= -A_s;
            temp_result <= std_logic_vector(Result_s);
            if A_s = "1000" then
                temp_overflow <= '1';
            else
                temp_overflow <= '0';
            end if;
            
        -- MUL Operation
        elsif Op_Sel = ALU_MUL then
            mul_temp := A_s * B_s;
            temp_result <= std_logic_vector(mul_temp(3 downto 0));
            if mul_temp(7 downto 4) /= "0000" then
                temp_overflow <= '1';
            else
                temp_overflow <= '0';
            end if;
            
        -- AND Operation
        elsif Op_Sel = ALU_AND then
            temp_result <= Input_A and Input_B;
            temp_overflow <= '0';
            
        -- OR Operation
        elsif Op_Sel = ALU_OR then
            temp_result <= Input_A or Input_B;
            temp_overflow <= '0';
            
        -- XOR Operation
        elsif Op_Sel = ALU_XOR then
            temp_result <= Input_A xor Input_B;
            temp_overflow <= '0';
            
        -- NOT Operation
        elsif Op_Sel = ALU_NOT then
            temp_result <= not Input_A;
            temp_overflow <= '0';
            
        -- CMP Operation (Comparison)
        elsif Op_Sel = ALU_CMP then
            temp_result <= "0000";
            temp_overflow <= '0';
            
        -- Default
        else
            temp_result <= (others => '0');
            temp_overflow <= '0';
        end if;
    end process;
    
    -- Zero flag
    Zero_Flag <= '1' when temp_result = "0000" else '0';
    Overflow_Flag <= temp_overflow;
    
    -- Comparison flags (for CMP instruction)
    process(A_s, B_s, Op_Sel)
    begin
        if Op_Sel = ALU_CMP then
            if A_s = B_s then
                CMP_Equal <= '1';
                CMP_Less <= '0';
                CMP_Greater <= '0';
            elsif A_s < B_s then
                CMP_Equal <= '0';
                CMP_Less <= '1';
                CMP_Greater <= '0';
            else
                CMP_Equal <= '0';
                CMP_Less <= '0';
                CMP_Greater <= '1';
            end if;
        else
            CMP_Equal <= '0';
            CMP_Less <= '0';
            CMP_Greater <= '0';
        end if;
    end process;
    
    Result <= temp_result;
    
end Behavioral;