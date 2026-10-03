# FPGA Board Constraints (Digilent Basys 3)

This directory contains the physical pin and I/O standard constraints (`.xdc`) for targeting the **Digilent Basys 3 Artix-7 FPGA** (`xc7a35tcpg236-1`).

---

## Directory Structure

- **[`basic/basys3_constraints.xdc`](basic/basys3_constraints.xdc)**: Pin mappings for the 12-bit Base NanoProcessor.
- **[`extended/basys3_constraints.xdc`](extended/basys3_constraints.xdc)**: Pin mappings for the 14-bit Extended NanoProcessor.

---

## Pin Mapping Summary

### Base NanoProcessor (12-bit)

| Signal | Basys 3 Pin | Description / Hardware |
|---|---|---|
| `Clock` | `W5` | 100 MHz Onboard Oscillator |
| `Reset` | `U18` | Center Push Button (`BTNC`) |
| `Data[3:0]` | `V19, U19, E19, U16` | LEDs `LD3` to `LD0` (R7 output value) |
| `Zero` | `U14` | LED `LD14` (Zero flag indicator) |
| `Overflow` | `V14` | LED `LD15` (Overflow flag indicator) |
| `S_7Seg[6:0]` | `U7, V5, U5, V8, U8, W6, W7` | 7-Segment Display Cathodes (Active LOW) |
| `anode[3:0]` | `W4, V4, U4, U2` | 7-Segment Display Anodes (Active LOW) |

### Extended NanoProcessor (14-bit)

| Signal | Basys 3 Pin | Description / Hardware |
|---|---|---|
| `Clock` | `W5` | 100 MHz Onboard Oscillator |
| `Reset` | `U18` | Center Push Button (`BTNC`) |
| `Store_Btn` | `T17` | Right Push Button (`BTNR`) for manual register store |
| `Toggle_Btn` | `W19` | Left Push Button (`BTNL`) for clock/mode stepping |
| `Switches[15:0]` | `R2` down to `V17` | Slide Switches `SW15` down to `SW0` |
| `Data[3:0]` | `V19, U19, E19, U16` | LEDs `LD3` to `LD0` (R7 output value) |
| `CMP_Equal` | `V13` | LED `LD8` (Comparison Equal Flag) |
| `CMP_Less` | `V3` | LED `LD9` (Comparison Less Than Flag) |
| `CMP_Greater` | `W3` | LED `LD10` (Comparison Greater Than Flag) |
| `Zero` | `P1` | LED `LD14` (Zero Flag) |
| `Overflow` | `L1` | LED `LD15` (Overflow Flag) |
| `S_7Seg[6:0]` | `U7, V5, U5, V8, U8, W6, W7` | 7-Segment Display Cathodes (Active LOW) |
| `anode[3:0]` | `W4, V4, U4, U2` | 7-Segment Display Anodes (Active LOW) |
