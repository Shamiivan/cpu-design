# 🌭🔥 **Glizzium: Spicing Up CPU Design with Flavorful Innovation!** 🔥🌭



Dive into the delectable world of Glizzium, where CPU design becomes a savory journey through VHDL. Our comprehensive CPU design boasts a control unit, instruction memory, register files, data memory, and a tantalizing ALU. Ideal for both seasoned developers and glizzy enthusiasts alike, Glizzium's VHDL architecture is the perfect blend of learning and flavor.

# ALU

The Glizzium ALU is the heart of our spicy CPU, featuring two 32-bit input operands and a 32-bit output port. It dances to the rhythm of control inputs like func and logic_func, orchestrating a symphony of arithmetic and logical operations. From load upper immediate to set less than zero, our ALU is seasoned with versatility. And let's not forget logic_func, the maestro behind AND, OR, XOR, and NOR operations—because computing should be as flavorful as your favorite glizzy!

![1700642004659](image/README/1700642004659.png)

## MSB of Adder

In the world of Glizzium, the Most Significant Bit (MSB) takes center stage during the "slt" (set less than zero) instruction. Picture this: the spicy comparison of x and y, the subtract operation unveiling the sign bit, and the grand finale—padding with 0s to create a 32-bit masterpiece. That's the magic of Glizzium's MSB, where every bit tells a flavorful story.

## Output of Adder

The output of our adder is like the perfect glizzy bite—full of substance and satisfaction. It's the result of a carefully orchestrated addition or subtraction, with arithmetic performed in the bold language of 32-bit two's complement notation. Glizzium's adder ensures that every computation is as robust and satisfying as your favorite glizzy feast.

## Output of Logic Unit

Glizzium's logic unit brings a burst of flavor to your computations. It's the secret sauce behind logical operations—AND, OR, XOR, and NOR. Just like choosing the right condiment for your glizzy, our logic unit lets you spice up your code with precision, making every computation a taste sensation.

# PC Entity

## Entity Declaration

```vhdl
-- Embrace the Glizzium Journey
entity glizzy_pc is
    port(
        glizzy_pc_in  : in  std_logic_vector(31 downto 0);  -- Input: New value for Glizzy Program Counter
        glizzy_reset  : in  std_logic;                      -- Input: Reset signal
        glizzy_clk    : in  std_logic;                      -- Input: Clock signal
        glizzy_pc_out : out std_logic_vector(31 downto 0)  -- Output: Current value of Glizzy Program Counter
    );
end glizzy_pc;
```

Introducing the Glizzy Program Counter (PC) entity—a crucial part of our flavorful digital system. It's not just a counter; it's the pulse of Glizzium, with inputs for a new PC value, a reset signal, and the heartbeat of computing—clock signal. The current PC value is not just an output; it's a flavorful revelation.

# Registers

# Next Address Unit

# Control Unit

# Instruction Cache

The Glizzium Instruction Cache unit is where the magic begins. With a 5-bit address input and a 32-bit data output, it's the gateway to the glizzy-inspired machine code. Just like choosing the perfect glizzy toppings, the `instruction_cache` entity lets you select instructions with precision. Modify the cases, change the flavor—because in Glizzium, every instruction is a culinary delight.

# Sign Extension

In the world of Glizzium, the Sign Extension is the spice that brings balance to our immediate field. Whether it's loading upper immediate, setting less than, or diving into arithmetic and logical operations, our Sign Extension ensures that your code's flavor is just right. With different sign extension formats to choose from, Glizzium lets you sign-extend with style.

# Data Cache

## Overview

The Glizzium Data Cache, a 32-location, 32-bit-wide RAM, is where your data gets its glizzy flavor. Addressed by the low-order 5 bits of the ALU output, this cache is the secret ingredient in our MIPS datapath. It's not just memory; it's a flavorful experience.

## Specifications

* **Memory:** 32 locations, each storing 32 bits.
* **Addressing:** Uses ALU's low-order 5 bits.

## Control Signals

* **Reset (`reset`):** A reset that's as bold as your glizzy cravings.
* **Clock (`clk`):** The heartbeat of Glizzium's data operations.
* **Data Write Control (`data_write`):** Because writing data should be as satisfying as taking a bite of your favorite glizzy.

## Ports

* **Data Input (`d_in`):** Connects to `out_b` from the Register File for store instructions.
* **Data Output (`d_out`):** Provides 32 bits read from the Glizzium Data Cache.

## Implementation

* Single-port register file with a clocked VHDL process.
* Multiplexer selects Data Cache output for load and ALU output for other instructions.
* Output feeds into `d_in` of the Register File.

## Integration

* Accessible by load and store instructions.
* Data read during loads; data written during stores.

🔗 **Join the Glizzium Revolution: #GlizzyCodingAdventure** 🔗

Are you ready to savor the flavor of Glizzium? Join the revolution, spice up your code, and let's embark on a coding adventure that's as bold as your favorite glizzy! 🌭💻
