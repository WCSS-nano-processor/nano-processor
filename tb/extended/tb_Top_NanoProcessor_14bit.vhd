----------------------------------------------------------------------------------
-- Top-Level Testbench for 14-bit Extended Nanoprocessor
-- Tests ROM mode program execution
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_Top_NanoProcessor_14bit is
end tb_Top_NanoProcessor_14bit;

architecture Behavioral of tb_Top_NanoProcessor_14bit is
    component Top_NanoProcessor_14bit
        port( Clock : in STD_LOGIC; Reset : in STD_LOGIC;
              Store_Btn : in STD_LOGIC; Toggle_Btn : in STD_LOGIC;
              Switches : in STD_LOGIC_VECTOR(15 downto 0);
              Overflow : out STD_LOGIC; Zero : out STD_LOGIC;
              CMP_Equal : out STD_LOGIC; CMP_Less : out STD_LOGIC; CMP_Greater : out STD_LOGIC;
              S_7Seg : out STD_LOGIC_VECTOR(6 downto 0);
              anode : out STD_LOGIC_VECTOR(3 downto 0);
              Data : out STD_LOGIC_VECTOR(3 downto 0));
    end component;
    
    signal Clock : STD_LOGIC := '0';
    signal Reset : STD_LOGIC := '1';
    signal Store_Btn, Toggle_Btn : STD_LOGIC := '0';
    signal Switches : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal Overflow, Zero : STD_LOGIC;
    signal CMP_Equal, CMP_Less, CMP_Greater : STD_LOGIC;
    signal S_7Seg : STD_LOGIC_VECTOR(6 downto 0);
    signal anode : STD_LOGIC_VECTOR(3 downto 0);
    signal Data : STD_LOGIC_VECTOR(3 downto 0);
    
    constant CLK_PERIOD : time := 10 ns;
    
    function seg_to_char(seg : std_logic_vector(6 downto 0)) return string is
    begin
        case seg is
            when "1000000" => return "0";
            when "1111001" => return "1";
            when "0100100" => return "2";
            when "0110000" => return "3";
            when "0011001" => return "4";
            when "0010010" => return "5";
            when "0000010" => return "6";
            when "1111000" => return "7";
            when "0111111" => return "-";
            when others => return "?";
        end case;
    end function;
    
begin
    UUT: Top_NanoProcessor_14bit port map (
        Clock => Clock, Reset => Reset,
        Store_Btn => Store_Btn, Toggle_Btn => Toggle_Btn,
        Switches => Switches,
        Overflow => Overflow, Zero => Zero,
        CMP_Equal => CMP_Equal, CMP_Less => CMP_Less, CMP_Greater => CMP_Greater,
        S_7Seg => S_7Seg, anode => anode, Data => Data
    );
    
    Clock <= not Clock after CLK_PERIOD/2;
    
    process
    begin
        report "==========================================================";
        report "Testing 14-bit Extended Nanoprocessor";
        report "ROM Mode Program: Count from -8 to +7";
        report "==========================================================";
        
        -- Apply reset
        report "Step 1: Applying RESET...";
        Reset <= '1';
        wait for 100 ns;
        
        -- Release reset (ROM mode, SW15=0)
        report "Step 2: Releasing RESET - ROM mode starting...";
        Reset <= '0';
        
        -- Run simulation
        wait for 5000 ns;
        
        -- Display results
        report "";
        report "==========================================================";
        report "SIMULATION COMPLETE";
        report "==========================================================";
        report "Final R7 value (Data) = " & integer'image(to_integer(unsigned(Data)));
        report "Zero flag = " & std_logic'image(Zero);
        report "Overflow flag = " & std_logic'image(Overflow);
        report "==========================================================";
        
        wait;
    end process;
end Behavioral;
