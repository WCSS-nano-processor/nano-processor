----------------------------------------------------------------------------------
-- Register Data Multiplexer (8-way 4-bit)
-- Selects one register's value based on select address
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.BusDefinitions.all;

entity RegisterData_Multiplexer is
    Port ( DataSources   : in  RegisterFile;
           SelectAddress : in  RegisterSelect;
           OutputData    : out DataBus);
end RegisterData_Multiplexer;

architecture Behavioral of RegisterData_Multiplexer is
    component Mux_8way_4bit
        port ( Sel     : in  STD_LOGIC_VECTOR (2 downto 0);
               Reg_0, Reg_1, Reg_2, Reg_3, Reg_4, Reg_5, Reg_6, Reg_7 : in DataBus;
               MuxOut  : out DataBus);
    end component;
begin
    MUX: Mux_8way_4bit port map (
        Sel => SelectAddress,
        Reg_0 => DataSources(0),
        Reg_1 => DataSources(1),
        Reg_2 => DataSources(2),
        Reg_3 => DataSources(3),
        Reg_4 => DataSources(4),
        Reg_5 => DataSources(5),
        Reg_6 => DataSources(6),
        Reg_7 => DataSources(7),
        MuxOut => OutputData
    );
end Behavioral;