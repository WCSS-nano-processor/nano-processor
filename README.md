# 4-bit NanoProcessor

<p>
  <img src="https://img.shields.io/badge/VHDL-2008-00599C?style=flat-square" alt="VHDL" />
  <img src="https://img.shields.io/badge/Xilinx%20Vivado-2023.2-FF1B1C?style=flat-square" alt="Xilinx Vivado" />
  <img src="https://img.shields.io/badge/FPGA-Artix--7%20xc7a35t-009688?style=flat-square" alt="FPGA Artix-7" />
  <img src="https://img.shields.io/badge/Board-Digilent%20Basys%203-007ACC?style=flat-square" alt="Digilent Basys 3" />
  <img src="https://img.shields.io/badge/License-MIT-green?style=flat-square" alt="License: MIT" />
</p>

A custom 4-bit single-cycle microprocessor designed, verified, and synthesized in VHDL for the Digilent Basys 3 Artix-7 FPGA (`xc7a35tcpg236-1`). The repository contains two self-contained processor implementations: a baseline 12-bit ISA processor and an extended 14-bit ISA processor with multi-operation ALU, status flags, and interactive hardware control.

> [!NOTE]
> Comprehensive architectural documentation, the 113-page academic report, opcode quick-reference cards, and simulation waveforms are hosted in the **[nano-processor-docs](https://github.com/WCSS-nano-processor/nano-processor-docs)** repository.

---

## Status

Fully verified in simulation and validated on physical Digilent Basys 3 hardware. Pre-compiled bitstreams for both base and extended configurations are included in `bitstreams/`.

---

## What It Does

- **Single-Cycle Datapath**: Direct execution of instructions in a single clock cycle with zero pipelining hazards.
- **Dual Architecture Configurations**:
  - **Base (12-bit ISA)**: 4 fundamental instructions (`MOVI`, `ADD`, `NEG`, `JZR`), 4-bit datapath, and 8 general-purpose registers (`R0` hardwired to `0000`, `R1` through `R7`).
  - **Extended (14-bit ISA)**: 12 instructions supporting arithmetic, 4-bit unsigned multiplication (`MUL`), bitwise logic (`AND`, `OR`, `XOR`, `NOT`), register comparison (`CMP`), and direct slide switch input (`IN`).
- **Comprehensive Flag Generation**: Dedicated hardware detection for Zero (`Z`), Carry (`C`), Signed Overflow (`V`), and Comparison outcomes (`EQ`, `LT`, `GT`).
- **Dual Execution Modes**: Autonomous instruction execution from ROM and manual push-button stepping for hardware inspection.
- **Hardware I/O Mapping**: Visual output on 16 onboard LEDs and multiplexed 4-digit 7-segment display via dedicated display controllers.

---

## Stack

| Subsystem | Implementation | Purpose |
|---|---|---|
| Hardware Description | VHDL-93 / VHDL-2008 | Register-transfer level (RTL) modeling and verification |
| Toolchain & Synthesis | Xilinx Vivado Design Suite | Synthesis, implementation, timing analysis, and bitstream generation |
| Target Platform | Digilent Basys 3 (`xc7a35tcpg236-1`) | Physical FPGA hardware verification |
| Clock Subsystem | `Slow_Clk.vhd` | 100 MHz oscillator division to 1 Hz human-observable clock |
| Output Subsystem | `Display_Controller.vhd`, `LUT_16_7.vhd` | Time-multiplexed 7-segment display driver and cathode decoder |

---

## Instruction Set Architecture

### Base 12-bit Instruction Set
Instruction format: `Opcode [11:10] | RegA [9:7] | RegB [6:4] | Immediate / Address [3:0]`

| Opcode | Mnemonic | Format | Description |
|:---:|---|---|---|
| `10` | `MOVI R, d` | `10 RRR 000 dddd` | Load 4-bit immediate `d` into register `R` |
| `00` | `ADD Ra, Rb` | `00 RaRaRa RbRbRb 0000` | Compute `Ra <= Ra + Rb` |
| `01` | `NEG R` | `01 RRR 000 0000` | Two's complement negation: `R <= 0 - R` |
| `11` | `JZR R, d` | `11 RRR 000 dddd` | Branch to ROM address `d` if register `R == 0` |

### Extended 14-bit Instruction Set
Instruction format: `Opcode [13:10] | RegA [9:7] | RegB [6:4] | Func / Immediate [3:0]`

| Opcode | Hex | Mnemonic | Operation | Flags Updated |
|:---:|:---:|---|---|:---:|
| `0000` | `0x0` | `MOVI Ra, Imm` | `Ra <= Immediate` | None |
| `0001` | `0x1` | `ADD Ra, Rb` | `Ra <= Ra + Rb` | `Zero`, `Carry`, `Overflow` |
| `0010` | `0x2` | `SUB Ra, Rb` | `Ra <= Ra - Rb` | `Zero`, `Carry`, `Overflow` |
| `0011` | `0x3` | `NEG Ra` | `Ra <= -Ra` | `Zero`, `Carry`, `Overflow` |
| `0100` | `0x4` | `JZR Ra, Addr` | If `Ra == 0` then `PC <= Addr` | None |
| `0101` | `0x5` | `IN Ra` | `Ra <= Switches[3:0]` | None |
| `0110` | `0x6` | `MUL Ra, Rb` | `Ra <= (Ra * Rb)[3:0]` | `Zero`, `Overflow` |
| `0111` | `0x7` | `AND Ra, Rb` | `Ra <= Ra AND Rb` | `Zero` |
| `1000` | `0x8` | `OR Ra, Rb` | `Ra <= Ra OR Rb` | `Zero` |
| `1001` | `0x9` | `XOR Ra, Rb` | `Ra <= Ra XOR Rb` | `Zero` |
| `1010` | `0xA` | `NOT Ra` | `Ra <= NOT Ra` | `Zero` |
| `1011` | `0xB` | `CMP Ra, Rb` | Compare `Ra` and `Rb` (no register write) | `CMP_Equal`, `CMP_Less`, `CMP_Greater` |

---

## Project Structure

```
nano-processor/
├── bitstreams/
│   ├── NanoProcessor.bit                  # Generated bitstream (Base 12-bit)
│   └── Top_NanoProcessor_14bit.bit        # Generated bitstream (Extended 14-bit)
│
├── constraints/
│   ├── README.md                          # Pin mapping and signal allocation guide
│   ├── basic/basys3_constraints.xdc       # Physical pin constraints (12-bit)
│   └── extended/basys3_constraints.xdc    # Physical pin constraints (14-bit)
│
├── src/
│   ├── basic/                             # 22 self-contained VHDL modules (12-bit)
│   │   ├── Add_Sub_4bit.vhd
│   │   ├── Address_Selector.vhd
│   │   ├── BusDefinitions.vhd
│   │   ├── Constants.vhd
│   │   ├── D_FF.vhd
│   │   ├── Decoder_3to8.vhd
│   │   ├── Display_Controller.vhd
│   │   ├── FA.vhd
│   │   ├── Instruction_Decoder.vhd
│   │   ├── LUT_16_7.vhd
│   │   ├── Load_Selector.vhd
│   │   ├── Mux_2way_3bit.vhd
│   │   ├── Mux_2way_4bit.vhd
│   │   ├── Mux_8way_4bit.vhd
│   │   ├── NanoProcessor.vhd              # Top Module (Base)
│   │   ├── PC_Adder.vhd
│   │   ├── Program_Counter.vhd
│   │   ├── Program_ROM.vhd
│   │   ├── RCA_4.vhd
│   │   ├── Reg.vhd
│   │   ├── RegisterData_Multiplexer.vhd
│   │   ├── Register_Bank.vhd
│   │   └── Slow_Clk.vhd
│   │
│   └── extended/                          # 26 self-contained VHDL modules (14-bit)
│       ├── ALU_Extended_14bit.vhd
│       ├── Address_Selector.vhd
│       ├── BusDefinitions.vhd
│       ├── Constants.vhd
│       ├── D_FF.vhd
│       ├── Decoder_3to8.vhd
│       ├── Display_Controller.vhd
│       ├── FA.vhd
│       ├── Input_Selector.vhd
│       ├── Instruction_Decoder_14bit.vhd
│       ├── LUT_16_7.vhd
│       ├── Load_Selector.vhd
│       ├── Load_Selector_Input.vhd
│       ├── Manual_Controller.vhd
│       ├── Mux_2way_3bit.vhd
│       ├── Mux_2way_4bit.vhd
│       ├── Mux_8way_4bit.vhd
│       ├── PC_Adder.vhd
│       ├── Program_Counter.vhd
│       ├── Program_ROM_14bit.vhd
│       ├── RCA_4.vhd
│       ├── Reg.vhd
│       ├── RegisterData_Multiplexer.vhd
│       ├── Register_Bank.vhd
│       ├── Slow_Clk.vhd
│       └── Top_NanoProcessor_14bit.vhd    # Top Module (Extended)
│
├── tb/
│   ├── basic/                             # 16 unit and integration testbenches
│   └── extended/                          # 6 extended unit and top-level testbenches
│
├── .gitignore
├── LICENSE
└── README.md
```

---

## Run Locally

### Prerequisites
- **OS**: Windows 10/11 or Ubuntu Linux
- **EDA Suite**: Xilinx Vivado (2020.1 or newer recommended)
- **Target Hardware**: Digilent Basys 3 Artix-7 FPGA Trainer Board (micro-USB connection)

### Vivado Project Setup
1. Launch Vivado and select **Create Project** -> **RTL Project**.
2. Select device: **`xc7a35tcpg236-1`** (or select the **Basys 3** board from the vendor list).
3. Add Design Sources:
   - For **Base Processor**: Add all `.vhd` files from [`src/basic/`](src/basic/). Set `NanoProcessor` as Top.
   - For **Extended Processor**: Add all `.vhd` files from [`src/extended/`](src/extended/). Set `Top_NanoProcessor_14bit` as Top.
4. Add Constraints:
   - For Base: Add [`constraints/basic/basys3_constraints.xdc`](constraints/basic/basys3_constraints.xdc).
   - For Extended: Add [`constraints/extended/basys3_constraints.xdc`](constraints/extended/basys3_constraints.xdc).
5. Add Simulation Sources:
   - Add testbenches from [`tb/basic/`](tb/basic/) or [`tb/extended/`](tb/extended/).

---

## Validate

### Running Testbench Simulations
- **Base Integration Test**: In the Flow Navigator, set `tb_NanoProcessor_TB` as the top simulation module and run **Run Behavioral Simulation**. Verify instruction execution, register values, and loop iteration.
- **Extended Integration Test**: Set `tb_Top_NanoProcessor_14bit` as the top simulation module and run **Run Behavioral Simulation**. Verify arithmetic operations, multiplier output, logic flags, and input routing.

### Hardware Synthesis & Programming
1. In Vivado, click **Run Synthesis** and wait for completion.
2. Click **Run Implementation** and inspect timing and resource reports.
3. Click **Generate Bitstream**.
4. Connect the Basys 3 board, open **Hardware Manager** -> **Open Target** -> **Auto Connect**.
5. Click **Program Device** and select the generated bitstream or the pre-built files in `bitstreams/`.

---

## Team & Credits

Developed for **CS1050: Computer Organisation & Digital Design** at the **Department of Computer Science & Engineering, University of Moratuwa**.

**Team WCSS**:
- Bandaranayake I.B.W.D
- Botheju P.V.C.N.P
- Dayarathna A.M.S.T
- Bandara W.B.S.N

---

## License

This project is licensed under the [MIT License](LICENSE).
