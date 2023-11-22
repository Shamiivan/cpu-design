-- Declare the library
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Define the entity with ports
entity alu is 
 port(
   x, y : in std_logic_vector(31 downto 0); -- Input vectors
   func : in std_logic_vector(1 downto 0); -- Function selection
   add_sub : in std_logic; -- Add or Subtract operation
   logic_func : in std_logic_vector(1 downto 0); -- Logic operation selection
   output : out std_logic_vector(31 downto 0); -- Output vector
   overflow : out std_logic; -- Overflow flag
   zero : out std_logic); -- Zero flag
end alu;

-- Define the architecture
architecture structural of alu is 
	signal add_sub_result, logic_result, msb, msbsub: std_logic_vector(31 downto 0); -- Signals for operations
begin 
	-- ADD SUB OPERATIONS
	add_sub_result <= std_logic_vector(unsigned(x)+unsigned(y)) when (add_sub='0') else 
			std_logic_vector(unsigned(x)-unsigned(y)); -- Add or Subtract operation

	-- MSB OPERATIONS 	
	msbsub <= std_logic_vector(unsigned(x)-unsigned(y)); -- Subtract operation
	msb <= (0 => msbsub(31), others => '0'); -- MSB operation

	-- LOGIC OPERATIONS 
	with logic_func select 
	logic_result <= x AND y when "00", 
			x OR y when "01", 
			x XOR y when "10", 
			x NOR y when others; -- Logic operations
	-- ZERO OUTPUT
	process(add_sub_result)
	begin
		if (unsigned(add_sub_result) = 0) then 
			zero <= '1'; -- Zero flag set
		else 
			zero <= '0';
		end if;
	end process;

	-- OVERFLOW 
	overflow <= add_sub_result(31) XOR y(31); -- Overflow flag

	-- OUTPUT
	with func select 
	output <= y when "00", 
               msb when "01", 
               add_sub_result when "10", 
               logic_result when others; -- Output selection
end structural;
