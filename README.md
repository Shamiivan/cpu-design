# Project: VHDL-Based Datapath and Control for a Simple Processor (Legacy Example)
`Notice 
This project is no longer actively supported and serves as an educational example for those interested in CPU design. The implementation showcases fundamental concepts in processor architecture and VHDL design.
`
## Description:
This project implements a simple processor datapath in VHDL, combining arithmetic, logical, branching, and memory operations. It uses modular design principles to break the architecture into smaller reusable components like ALU, registers, instruction cache, data cache, and program counter. This processor supports a variety of instructions, including R-type, I-type, and branching instructions.

![1700642004659](image/README/1700642004659.png)
---

#### **Key Features**:

1. **Arithmetic Logic Unit (ALU)**:
   - Performs addition, subtraction, and logical operations (`AND`, `OR`, `XOR`, `NOR`).
   - Outputs flags for `overflow` and `zero` to indicate computation status.
   - Configurable via control signals (`func`, `logic_func`, `add_sub`).

2. **Datapath**:
   - Manages instruction fetch, decode, execution, and memory access.
   - Includes components such as `Program Counter (PC)`, `Instruction Cache`, `Register File`, `Sign Extender`, `ALU`, and `Data Cache`.
   - Implements instruction decoding with control signals for operation flow.

3. **Control Unit**:
   - Generates control signals for instruction execution (`add`, `sub`, `branch`, etc.).
   - Supports different instruction types with branching, jumping, and memory access.

4. **Memory Components**:
   - **Instruction Cache**: Provides instructions based on the program counter.
   - **Data Cache**: Stores and retrieves data for memory operations.

5. **Branching and Jumping**:
   - Supports conditional (`beq`, `bne`, `bltz`) and unconditional (`j`) branches.
   - Handles PC updates using a `next_address` component.

6. **Testbenches**:
   - Includes testbenches for individual components, like ALU and datapath, to verify correctness.

---

#### **Key Components**:

1. **ALU**:
   - Inputs: Operands (`x`, `y`), operation selectors (`func`, `logic_func`, `add_sub`).
   - Outputs: Computed result, `overflow` flag, `zero` flag.

2. **Program Counter (PC)**:
   - Keeps track of the current instruction address.
   - Supports reset and clocked updates.

3. **Instruction Cache**:
   - Contains predefined instructions.
   - Outputs instructions based on the current PC value.

4. **Data Cache**:
   - Stores temporary data for memory instructions like `lw` and `sw`.

5. **Register File**:
   - Stores and retrieves data for computation.
   - Provides dual read ports and a write port.

6. **Control Unit**:
   - Decodes instructions and generates appropriate control signals.

7. **Sign Extender**:
   - Extends immediate values to 32-bit for computations.

8. **Next Address Logic**:
   - Computes the next PC value for sequential, branch, and jump instructions.

---

#### **Supported Instructions**:

1. **Arithmetic and Logic**:
   - `add`, `sub`, `and`, `or`, `xor`, `nor`.

2. **Immediate Operations**:
   - `addi`, `andi`, `ori`, `xori`, `slti`, `lui`.

3. **Memory Access**:
   - `lw`, `sw`.

4. **Branch and Jump**:
   - `beq`, `bne`, `bltz`, `j`.

---

#### **Simulation and Testing**:

1. **ALU Testbench**:
   - Verifies ALU operations like addition, subtraction, and logical computations.

2. **Datapath Testbench**:
   - Simulates instruction execution and validates program flow.

3. **Behavioral Simulations**:
   - Run test programs using the instruction cache to verify end-to-end execution.

---

#### **How to Use**:

1. **Setup**:
   - Use a VHDL simulation tool like ModelSim or Vivado for compiling and testing.

2. **Compilation**:
   - Compile all the components (`alu`, `datapath`, `instruction_cache`, etc.).

3. **Simulation**:
   - Load the testbench files to simulate and verify the components.

4. **Modification**:
   - Add custom instructions by modifying the control logic and instruction cache.

---

#### **Future Enhancements**:
While this project remains static, aspiring designers can use it as a foundation to:
- Extend the instruction set to support more operations like division and multiplication.
- Implement pipeline stages to improve performance.
- Add a hazard detection unit for better instruction flow in complex programs.

---
