########################################################################
# BASYS 3 Constraints for 14-bit Nanoprocessor
# Based on official Basys3 rev B board constraints
########################################################################

## Clock signal
set_property PACKAGE_PIN W5 [get_ports Clock]
set_property IOSTANDARD LVCMOS33 [get_ports Clock]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports Clock]

## Switches SW0-SW15
set_property PACKAGE_PIN V17 [get_ports {Switches[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[0]}]
set_property PACKAGE_PIN V16 [get_ports {Switches[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[1]}]
set_property PACKAGE_PIN W16 [get_ports {Switches[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[2]}]
set_property PACKAGE_PIN W17 [get_ports {Switches[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[3]}]
set_property PACKAGE_PIN W15 [get_ports {Switches[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[4]}]
set_property PACKAGE_PIN V15 [get_ports {Switches[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[5]}]
set_property PACKAGE_PIN W14 [get_ports {Switches[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[6]}]
set_property PACKAGE_PIN W13 [get_ports {Switches[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[7]}]
set_property PACKAGE_PIN V2 [get_ports {Switches[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[8]}]
set_property PACKAGE_PIN T3 [get_ports {Switches[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[9]}]
set_property PACKAGE_PIN T2 [get_ports {Switches[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[10]}]
set_property PACKAGE_PIN R3 [get_ports {Switches[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[11]}]
set_property PACKAGE_PIN W2 [get_ports {Switches[12]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[12]}]
set_property PACKAGE_PIN U1 [get_ports {Switches[13]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[13]}]
set_property PACKAGE_PIN T1 [get_ports {Switches[14]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[14]}]
set_property PACKAGE_PIN R2 [get_ports {Switches[15]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Switches[15]}]

## LEDs for Output R7 (Data bus) - LD0 to LD3
set_property PACKAGE_PIN U16 [get_ports {Data[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data[0]}]
set_property PACKAGE_PIN E19 [get_ports {Data[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data[1]}]
set_property PACKAGE_PIN U19 [get_ports {Data[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data[2]}]
set_property PACKAGE_PIN V19 [get_ports {Data[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {Data[3]}]

## Comparison Result Flags - Using available LEDs LD8, LD9, LD10
set_property PACKAGE_PIN V13 [get_ports CMP_Equal]
set_property IOSTANDARD LVCMOS33 [get_ports CMP_Equal]

set_property PACKAGE_PIN V3 [get_ports CMP_Less]
set_property IOSTANDARD LVCMOS33 [get_ports CMP_Less]

set_property PACKAGE_PIN W3 [get_ports CMP_Greater]
set_property IOSTANDARD LVCMOS33 [get_ports CMP_Greater]

## Zero Flag (LD14)
set_property PACKAGE_PIN P1 [get_ports Zero]
set_property IOSTANDARD LVCMOS33 [get_ports Zero]

## Overflow Flag (LD15)
set_property PACKAGE_PIN L1 [get_ports Overflow]
set_property IOSTANDARD LVCMOS33 [get_ports Overflow]

## 7-Segment Display Segments
set_property PACKAGE_PIN W7 [get_ports {S_7Seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S_7Seg[0]}]
set_property PACKAGE_PIN W6 [get_ports {S_7Seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S_7Seg[1]}]
set_property PACKAGE_PIN U8 [get_ports {S_7Seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S_7Seg[2]}]
set_property PACKAGE_PIN V8 [get_ports {S_7Seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S_7Seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {S_7Seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S_7Seg[4]}]
set_property PACKAGE_PIN V5 [get_ports {S_7Seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S_7Seg[5]}]
set_property PACKAGE_PIN U7 [get_ports {S_7Seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {S_7Seg[6]}]

## 7-Segment Display Anodes
set_property PACKAGE_PIN U2 [get_ports {anode[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[0]}]
set_property PACKAGE_PIN U4 [get_ports {anode[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[1]}]
set_property PACKAGE_PIN V4 [get_ports {anode[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[2]}]
set_property PACKAGE_PIN W4 [get_ports {anode[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {anode[3]}]

## Buttons
set_property PACKAGE_PIN U18 [get_ports Reset]
set_property IOSTANDARD LVCMOS33 [get_ports Reset]

set_property PACKAGE_PIN T17 [get_ports Store_Btn]
set_property IOSTANDARD LVCMOS33 [get_ports Store_Btn]

set_property PACKAGE_PIN W19 [get_ports Toggle_Btn]
set_property IOSTANDARD LVCMOS33 [get_ports Toggle_Btn]

## Configuration settings
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]