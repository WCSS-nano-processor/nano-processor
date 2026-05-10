----------------------------------------------------------------------------------
-- Manual Controller - FIXED (sensitivity list corrected)
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.BusDefinitions.all;

entity Manual_Controller is
    Port ( clk         : in  STD_LOGIC;
           reset       : in  STD_LOGIC;
           store_btn   : in  STD_LOGIC;
           sw_data     : in  DataBus;
           sw_reg_sel  : in  RegisterSelect;
           sw_op_sel   : in  STD_LOGIC;
           sw_clear    : in  STD_LOGIC;
           reg_outputs : out RegisterFile;
           alu_result  : out DataBus;
           zero_flag   : out STD_LOGIC;
           overflow_flag : out STD_LOGIC;
           r7_value    : out DataBus);
end Manual_Controller;

architecture Behavioral of Manual_Controller is
    signal regs : RegisterFile := (others => (others => '0'));
    signal operandA, operandB, result : DataBus;
    signal store_pulse : STD_LOGIC := '0';
    signal last_store : STD_LOGIC := '0';
    
    component Add_Sub_4bit
        Port ( Input_A : in DataBus; Input_B : in DataBus; Mode_Sel : in STD_LOGIC;
               Result : out DataBus; Zero_Flag : out STD_LOGIC; Overflow_Flag : out STD_LOGIC);
    end component;
    
begin
    -- Read operands
    operandA <= regs(to_integer(unsigned(sw_reg_sel)));
    operandB <= sw_data;
    
    -- ALU
    U_ALU: Add_Sub_4bit port map (
        Input_A => operandA,
        Input_B => operandB,
        Mode_Sel => sw_op_sel,
        Result => result,
        Zero_Flag => zero_flag,
        Overflow_Flag => overflow_flag
    );
    
    alu_result <= result;
    r7_value <= regs(7);
    reg_outputs <= regs;
    
    -- Store to selected register on button press
    -- ? FIXED: Added sw_clear to sensitivity list
    process(clk, reset, sw_clear)
    begin
        if reset = '1' or sw_clear = '1' then
            -- Clear all registers
            for i in 0 to 7 loop
                regs(i) <= (others => '0');
            end loop;
            last_store <= '0';
        elsif rising_edge(clk) then
            -- Edge detection for store button
            store_pulse <= store_btn and not last_store;
            last_store <= store_btn;
            
            if store_pulse = '1' then
                -- Store ALU result to selected register
                regs(to_integer(unsigned(sw_reg_sel))) <= result;
            end if;
        end if;
    end process;
    
end Behavioral;