# 8-Bit RISC Microcontroller in VHDL

## Project Overview
This repository contains the complete structural VHDL design and simulation of an 8-bit RISC microcontroller. The architecture is based on a Harvard memory model, featuring distinct logical pathways for instructions and data to optimize execution. The system was developed using a modular, structural approach to distinctly separate combinational execution pathways from synchronous control logic.

## Architectural Specifications
* **Architecture:** Harvard Architecture 
* **Bus Width:** 8-bit Data Bus, 8-bit Address Bus
* **Instruction Format:** 8-bit instruction width (4-bit Opcode + 4-bit Immediate Operand)
* **Datapath Components:**
  * **ALU:** Multiplexed execution unit supporting Addition, Subtraction, and Logical (AND, OR, XOR, NOT) operations.
  * **Register File:** Synchronous memory blocks containing the Accumulator (ACC) and Program Counter (PC).
* **Control Unit:** Moore-type Finite State Machine (FSM) utilizing a strict 3-phase pipeline (FETCH $\rightarrow$ DECODE $\rightarrow$ EXECUTE).

## Instruction Set Architecture (ISA)
| Opcode | Instruction | Description |
| :--- | :--- | :--- |
| `0000` | **LOAD** | Load immediate operand into Accumulator |
| `0010` | **ADD** | Add immediate operand to Accumulator |
| `0110` | **JMP** | Unconditional Jump to address |
| `0111` | **JZ** | Jump to address if ALU Zero Flag is set |

## Development & Simulation Tools
* **Compiler:** [GHDL](https://ghdl.github.io/ghdl/) (VHDL-2008 standard)
* **Waveform Viewer:** [GTKWave](https://gtkwave.sourceforge.net/)
* **Environment:** WSL (Ubuntu) via VSCode

## Repository Structure
* `/src` - Core VHDL design files (`alu.vhd`, `register_file.vhd`, `control_unit.vhd`, `top_mcu.vhd`).
* `/tb` - Simulation testbenches for individual components and the top-level motherboard.
* `/sim` - Generated `.vcd` waveform output directory.

## How to Run the Simulation
To compile the design and execute the testbench using GHDL, run the following commands from the root directory:

```bash
# Compile core modules and top-level design
ghdl -a --std=08 -fsynopsys src/*.vhd
ghdl -a --std=08 -fsynopsys tb/tb_top_mcu.vhd

# Elaborate and Run
ghdl -e --std=08 -fsynopsys tb_top_mcu
ghdl -r --std=08 -fsynopsys tb_top_mcu --vcd=sim/wave_top.vcd --stop-time=100ns

# View Waveforms
gtkwave sim/wave_top.vcd