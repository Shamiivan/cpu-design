library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pc is
    port(
        pc_in  : in  std_logic_vector(31 downto 0);  -- Input: New value for Program Counter
        reset  : in  std_logic;                       -- Input: Reset signal
        clk    : in  std_logic;                       -- Input: Clock signal
        pc_out : out std_logic_vector(31 downto 0)   -- Output: Current value of Program Counter
    );
end pc;

architecture structural of pc is 
begin 
    process (clk, reset) 
    begin 
        if reset = '1' then 
            pc_out <= (others => '0');  -- Reset Program Counter to zero
        elsif rising_edge(clk) then 
            pc_out <= pc_in;  -- Update Program Counter with the new value
        end if;
    end process;
end structural;
