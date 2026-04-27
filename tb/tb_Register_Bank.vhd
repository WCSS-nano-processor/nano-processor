----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 03:25:48 PM
-- Design Name: 
-- Module Name: tb_Register_Bank - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity tb_Register_Bank is
--  Port ( );
end tb_Register_Bank;

architecture Behavioral of tb_Register_Bank is

 component Register_Bank
        Port ( Data        : in  DataBus;
               Reset       : in  STD_LOGIC;
               Reg_En      : in  RegisterSelect;
               Clock       : in  STD_LOGIC;
               Register_Outputs : out RegisterFile);
end component;
    
signal Data        : DataBus := "0000";
signal Reset       : STD_LOGIC := '0';
signal Reg_En      : RegisterSelect := "000";
signal Clock       : STD_LOGIC := '0';
signal Reg_Outputs : RegisterFile;
    
constant CLK_PERIOD : time := 10 ns;
    
begin

 UUT: Register_Bank port map (
        Data => Data,
        Reset => Reset,
        Reg_En => Reg_En,
        Clock => Clock,
        Register_Outputs => Reg_Outputs
    );
    
    -- Clock generation
    Clock <= not Clock after CLK_PERIOD/2;
    
    process
    begin
        ------------------------------------------------------------------------
        -- Test 1: Reset all registers
        ------------------------------------------------------------------------
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';
        wait for 20 ns;
        
        -- Verify R0 is 0 (should be hardwired)
        assert Reg_Outputs(0) = "0000" report "R0 should be 0" severity error;
        
        ------------------------------------------------------------------------
        -- Test 2: Write to R1 (230137G last digits - 1001 = 9)
        ------------------------------------------------------------------------
        Reg_En <= "001";  -- Select R1
        Data <= "1001";   -- Value 9
        wait for CLK_PERIOD;
        
        ------------------------------------------------------------------------
        -- Test 3: Write to R2 (230094U last digits - 1110 = 14)
        ------------------------------------------------------------------------
        Reg_En <= "010";  -- Select R2
        Data <= "1110";   -- Value 14
        wait for CLK_PERIOD;
        
        ------------------------------------------------------------------------
        -- Test 4: Write to R3 (230506M last digits - 1010 = 10)
        ------------------------------------------------------------------------
        Reg_En <= "011";  -- Select R3
        Data <= "1010";   -- Value 10
        wait for CLK_PERIOD;
        
        ------------------------------------------------------------------------
        -- Test 5: Write to R4 (230153C last digits - 1001 = 9)
        ------------------------------------------------------------------------
        Reg_En <= "100";  -- Select R4
        Data <= "1001";   -- Value 9
        wait for CLK_PERIOD;
        
        ------------------------------------------------------------------------
        -- Test 6: Write to R5 and R6
        ------------------------------------------------------------------------
        Reg_En <= "101";  -- Select R5
        Data <= "0101";   -- Value 5
        wait for CLK_PERIOD;
        
        Reg_En <= "110";  -- Select R6
        Data <= "0110";   -- Value 6
        wait for CLK_PERIOD;
        
        ------------------------------------------------------------------------
        -- Test 7: Write to R7
        ------------------------------------------------------------------------
        Reg_En <= "111";  -- Select R7
        Data <= "0111";   -- Value 7
        wait for CLK_PERIOD;
        
        ------------------------------------------------------------------------
        -- Test 8: Verify all registers have correct values
        ------------------------------------------------------------------------
        wait for 20 ns;
        
        assert Reg_Outputs(0) = "0000" report "R0 test failed" severity error;
        assert Reg_Outputs(1) = "1001" report "R1 test failed" severity error;
        assert Reg_Outputs(2) = "1110" report "R2 test failed" severity error;
        assert Reg_Outputs(3) = "1010" report "R3 test failed" severity error;
        assert Reg_Outputs(4) = "1001" report "R4 test failed" severity error;
        assert Reg_Outputs(5) = "0101" report "R5 test failed" severity error;
        assert Reg_Outputs(6) = "0110" report "R6 test failed" severity error;
        assert Reg_Outputs(7) = "0111" report "R7 test failed" severity error;
        
        ------------------------------------------------------------------------
        -- Test 9: Try to write to R0 (should stay 0)
        ------------------------------------------------------------------------
        Reg_En <= "000";
        Data <= "1111";
        wait for CLK_PERIOD;
        assert Reg_Outputs(0) = "0000" report "R0 should remain 0" severity error;
        
        ------------------------------------------------------------------------
        -- Test 10: Reset again
        ------------------------------------------------------------------------
        Reset <= '1';
        wait for 20 ns;
        Reset <= '0';
        wait for 20 ns;
        
        -- Verify all registers reset to 0
        for i in 0 to 7 loop
            assert Reg_Outputs(i) = "0000" 
                report "Register " & integer'image(i) & " did not reset properly" severity error;
        end loop;
        
        wait;
    end process;

end Behavioral;
