library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity signextend is
    port(
        imm     : in  std_logic_vector(15 downto 0);  -- Input: Immediate value to be sign-extended
        func    : in  std_logic_vector(1 downto 0);   -- Input: Sign extension function control
        ext_imm : out std_logic_vector(31 downto 0)   -- Output: Sign-extended immediate value
    );
end signextend;

architecture structural of signextend is 
    signal zero_ext : std_logic_vector(15 downto 0) := (others => '0');  -- Zero-extended version of imm
begin 
    -- Sign Extension Logic
    with func select 
        ext_imm <= imm & zero_ext when "00",                    -- Zero extension
                   std_logic_vector(resize(signed(imm), 32)) when "01" | "10",  -- Sign extension
                   zero_ext & imm when others;                   -- Zero extension

end structural;
