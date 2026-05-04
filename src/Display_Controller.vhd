----------------------------------------------------------------------------------
-- Display Controller with Negative Sign Support
-- Shows positive numbers normally, negative numbers with a minus sign
-- Uses time-division multiplexing to show sign and value on two digits
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Display_Controller is
    Port ( clk      : in  STD_LOGIC;           -- Fast clock (100MHz)
           Data_in  : in  STD_LOGIC_VECTOR(3 downto 0);  -- 4-bit signed value
           seg      : out STD_LOGIC_VECTOR(6 downto 0);  -- 7-segment output
           an       : out STD_LOGIC_VECTOR(3 downto 0)); -- Anode controls
end Display_Controller;

architecture Behavioral of Display_Controller is
    component LUT_16_7
        Port ( binary_in : in  STD_LOGIC_VECTOR (3 downto 0);
               seven_seg : out STD_LOGIC_VECTOR (6 downto 0));
    end component;

    signal abs_value     : STD_LOGIC_VECTOR(3 downto 0);
    signal digit_seg     : STD_LOGIC_VECTOR(6 downto 0);
    signal refresh_counter : unsigned(19 downto 0) := (others => '0');
    signal active_digit  : std_logic_vector(1 downto 0);
    
    -- Minus sign pattern (active low)
    constant MINUS_PATTERN : std_logic_vector(6 downto 0) := "0111111";  -- Shows "-"
    constant BLANK_PATTERN  : std_logic_vector(6 downto 0) := "1111111";  -- All OFF
    
begin
    -- Convert 2's complement to Absolute Value for display
    process(Data_in)
        variable temp : std_logic_vector(3 downto 0);
    begin
        if Data_in(3) = '1' and Data_in /= "0000" then
            -- Negative number: convert to absolute value (2's complement)
            temp := std_logic_vector(unsigned(not Data_in) + 1);
            abs_value <= temp;
        else
            -- Positive number or zero
            abs_value <= Data_in;
        end if;
    end process;

    -- LUT instance to get 7-segment pattern for the digit
    My_LUT: LUT_16_7 port map(
        binary_in => abs_value, 
        seven_seg => digit_seg
    );

    -- Refresh counter for multiplexing (~1kHz at 100MHz)
    process(clk)
    begin
        if rising_edge(clk) then 
            refresh_counter <= refresh_counter + 1;
        end if;
    end process;
    
    active_digit <= std_logic_vector(refresh_counter(19 downto 18));  -- 4 states

    -- Multiplexing display control
    process(active_digit, digit_seg, Data_in)
    begin
        case active_digit is
            -- Rightmost digit (Digit 0): Show the number value
            when "00" =>
                an <= "1110";      -- Enable only digit 0
                seg <= digit_seg;  -- Show absolute value
                
            -- Second digit (Digit 1): Show minus sign if negative
            when "01" =>
                an <= "1101";      -- Enable only digit 1
                if Data_in(3) = '1' and Data_in /= "0000" then
                    seg <= MINUS_PATTERN;  -- Show "-"
                else
                    seg <= BLANK_PATTERN;   -- Show blank for positive
                end if;
                
            -- Remaining digits (Digit 2 and 3): Turn OFF
            when "10" =>
                an <= "1011";      -- Enable only digit 2
                seg <= BLANK_PATTERN;
                
            when "11" =>
                an <= "0111";      -- Enable only digit 3
                seg <= BLANK_PATTERN;
                
            when others =>
                an <= "1111";
                seg <= BLANK_PATTERN;
        end case;
    end process;
    
end Behavioral;