library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity next_address is
    port(
        rt             : in std_logic_vector(31 downto 0);   -- Input: Register contents (destination)
        rs             : in std_logic_vector(31 downto 0);   -- Input: Register contents (source)
        pc             : in std_logic_vector(31 downto 0);   -- Input: Program Counter value
        target_address : in std_logic_vector(25 downto 0);   -- Input: Target address for branch/jump
        branch_type    : in std_logic_vector(1 downto 0);    -- Input: Type of branch instruction
        pc_sel         : in std_logic_vector(1 downto 0);    -- Input: Program Counter selection
        next_pc        : out std_logic_vector(31 downto 0)  -- Output: Next Program Counter value
    );
end next_address;

architecture nextaddr of next_address is 
    signal branch_out : std_logic_vector(31 downto 0);  -- Intermediate signal for branch calculation
    signal offset     : signed(31 downto 0);            -- Offset for branch calculation
begin 
    -- BRANCH INSTRUCTIONS 
    process(branch_type, rs, rt, pc, offset)
    begin 
        branch_out <= pc; -- Default value

        if (branch_type = "00") then
            branch_out <= pc;  -- No branch (default)
        elsif (branch_type = "01") then 
            if (rt = rs) then 
                branch_out <= std_logic_vector(signed(pc) + offset);  -- Branch if registers are equal
            end if;	
        elsif (branch_type = "10") then 
            if (rt /= rs) then
                branch_out <= std_logic_vector(signed(pc) + offset);  -- Branch if registers are not equal
            end if;  
        elsif (branch_type = "11") then 
            if (signed(rs) < 0) then
                branch_out <= std_logic_vector(signed(pc) + offset);  -- Branch if source register is negative
            end if;  
        end if;
    end process; 

    -- PC SELECT
    with pc_sel select 
        next_pc <= std_logic_vector(unsigned(branch_out) + 1) when "00",  -- Increment PC
                   "000000" & target_address when "01",                 -- Jump to target address
                   rs when "10",                                       -- Jump to address in source register
                   (others => '0') when others;                       -- Default (no change in PC)
end nextaddr;
