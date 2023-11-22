# CPU Design

Comprehensive CPU design in VHDL, featuring control unit, instruction memory, register files, data memory, and ALU. Ideal for learning and implementing CPU architecture by students, hobbyists,

# ALU

The ALU has two 32-bit input operands (ports x and y) and a 32-bit output port. It utilizes control inputs func and logic_func to determine arithmetic and logical operations. The func control selects operations like load upper immediate, set less than zero, addition/subtraction, or logical operations, while logic_func controls logical operations (AND, OR, XOR, NOR). An additional control signal, add_sub, distinguishes between addition and subtraction, with arithmetic performed in 32-bit two's complement notation. See Figure 1 for a visual representation of the ALU's operations.

![1700642004659](image/README/1700642004659.png)

## MSB of adder

The Most Significant Bit (MSB) is determined in the context of the "slt" (set less than zero) instruction. This instruction sets a specified register to 1 if x < y and 0 otherwise. The condition x < y is checked by performing the operation x - y. The sign bit of the output of the subtract operation (adder_subtract unit) is padded with 0s to form a 32-bit number.

## Output of adder

## Output of logic Unit

# PC Entity

## Entity Declaration

```vhdl
entity pc is
    port(
        pc_in  : in  std_logic_vector(31 downto 0);  -- Input: New value for Program Counter
        reset  : in  std_logic;                       -- Input: Reset signal
        clk    : in  std_logic;                       -- Input: Clock signal
        pc_out : out std_logic_vector(31 downto 0)   -- Output: Current value of Program Counter
    );
end pc;
```

The `pc` entity represents a basic Program Counter (PC) module in a digital system. It has inputs for a new PC value (`pc_in`), a reset signal (`reset`), and a clock signal (`clk`). The current PC value is available as an output (`pc_out`).

# Registers

# Next Address Unit

# Control Unit

# Instruction Cache

The `instruction_cache` entity represents an Instruction Cache unit. It has a 5-bit address input (`addr`) for instruction retrieval and a 32-bit data output (`instr`) representing the machine code of the instruction stored at the addressed location.

The VHDL process with a case statement is used to implement the I-cache. Different programs can be tested by modifying the cases. The opcode and func fields within the instruction are not critical for this lab, but the values of rs, rt, rd, and immediate fields are essential for testing the datapath functionality.

The `addr` input is used to select the corresponding machine code based on the specified cases. If the address matches one of the cases, the corresponding instruction is output (`instr`). If the address doesn't match any case, the output is set to zero.

# Sign Extension

The Sign Extension component is responsible for extending the 16-bit immediate field of I-format instructions to a full 32-bit width. The specific sign extension process depends on the type of instruction being executed, determined by the control signal `func`. This documentation provides an overview of the Sign Extension component and its implementation.

## Sign Extension Formats:

The Sign Extension component supports different sign extension formats based on the `func` control signal. The formats are summarized in Table 4:

**Table 4: Sign Extension Formats**

| func | Instruction Type     | Sign Extension            | Comments                                                                    |
| ---- | -------------------- | ------------------------- | --------------------------------------------------------------------------- |
| 00   | Load Upper Immediate | i15i14i13..i1i0 000..00   | Pad with 16 zeros at least significant positions                            |
| 01   | Set Less Immediate   | i15i15... i15i14i13..i1i0 | Arithmetic sign extend (pad high order with copy of immediate sign bit i15) |
| 10   | Arithmetic           | i15i15... i15i14i13..i1i0 | Arithmetic sign extend (pad high order with copy of immediate sign bit i15) |
| 11   | Logical              | 00...00 i15i14i13..i1i0   | High order 16 bits padded with zeros                                        |

## VHDL Implementation:

The VHDL implementation of the Sign Extension component is encapsulated within the `signextend` entity and `signextend_arch` architecture. It utilizes the `func` control signal to determine the appropriate sign extension format. The main logic is implemented as follows:

```vhdl
architecture signextend_arch of signextend is 
    signal zero_ext : std_logic_vector(15 downto 0) := (others => '0');  -- Zero-extended version of imm
begin 
    -- Sign Extension Logic
    with func select 
        ext_imm <= imm & zero_ext when "00",                    -- Zero extension
                   std_logic_vector(resize(signed(imm), 32)) when "01" | "10",  -- Sign extension
                   zero_ext & imm when others;                   -- Zero extension

end signextend_arch;
```

## Usage in MIPS Datapath:

The Sign Extension component is an integral part of the MIPS datapath. It ensures that the immediate field is appropriately sign-extended before being used in various instructions. The MIPS datapath includes a data cache, and the Sign Extension component is essential for handling immediate values in load, store, and other instructions.


# Data Cache

## Overview:

The Data Cache serves as a 32-location, 32-bit-wide RAM in the MIPS datapath. It is addressed by the low-order 5 bits of the ALU output. This documentation outlines its specifications, control signals, and integration within the MIPS datapath.

## Specifications:

* **Memory:** 32 locations, each storing 32 bits.
* **Addressing:** Uses ALU's low-order 5 bits.

## Control Signals:

* **Reset (`reset`):** Asynchronously resets the Data Cache.
* **Clock (`clk`):** Synchronizes write operations.
* **Data Write Control (`data_write`):** Enables data writes on the rising clock edge (`'1'`).

## Ports:

* **Data Input (`d_in`):** Connects to `out_b` from the Register File for store instructions.
* **Data Output (`d_out`):** Provides 32 bits read from the Data Cache.

## Implementation:

* Single-port register file with a clocked VHDL process.
* Multiplexer selects Data Cache output for load and ALU output for other instructions.
* Output feeds into `d_in` of the Register File.

## Integration:

* Accessible by load and store instructions.
* Data read during loads; data written during stores.
