library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_cache is
port(addr : in std_logic_vector(4 downto 0);
	instr : out std_logic_vector(31 downto 0));
end instruction_cache ;

architecture behavioral of instruction_cache is 
begin 
	process(addr) 
	begin 
		case addr is 
			when "00000" => 
				instr <= "00100000000000010000000000000011"; -- addi r1, r0, 3
			when "00001" => 
				instr <= "00100000000000110000000000000001"; -- addi r2, r0, 1
			when "00010" => 
				instr <= "00000000001000100001100000100000"; -- add r3, r2, 1
			when "00011" => 
				instr <= "00010100010000110000000000000001"; -- bne r3, r2, 1
			when "00100" =>
				instr <= "00000000000000000000000000000000"; -- nothing
			when "00101" => 
				instr <= "00000000011001000001000000100101"; -- or r4, r3, r2
			when "00110" =>
				instr <= "00110000001001000000000000001110"; -- andi r4, r1, 14
			when "00111" =>
				instr <= "00001000000000000000000000000010"; -- jump 2
			when others => 
				instr <= "00000000000000000000000000000000"; -- nothing
		end case;
	end process;
end behavioral;

