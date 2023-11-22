library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity regfile is
    port(
        din           : in  std_logic_vector(31 downto 0);   -- Data input
        reset         : in  std_logic;                        -- Reset signal
        clk           : in  std_logic;                        -- Clock signal
        write         : in  std_logic;                        -- Write enable signal
        read_a        : in  std_logic_vector(4 downto 0);    -- Address for read port A
        read_b        : in  std_logic_vector(4 downto 0);    -- Address for read port B
        write_address : in  std_logic_vector(4 downto 0);    -- Address for write port
        out_a         : out std_logic_vector(31 downto 0);   -- Data output for port A
        out_b         : out std_logic_vector(31 downto 0)    -- Data output for port B
    );
end regfile;

architecture behavioral of regfile is
    type slv_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal reg: slv_array;  -- Register file storage
begin 
    -- RESET OR WRITE
    process (clk, reset, write) 
    begin 
        if reset = '1' then 
            -- Reset all registers to zero
            for i in reg'range loop 
                reg(i) <= (others => '0');
            end loop; 
        elsif rising_edge(clk) then 
            if write = '1' then 
                -- Write data to the specified address
                reg(to_integer(unsigned(write_address))) <= din;
            end if;
        end if; 
    end process;
    
    -- READ OUTPUT 
    -- Output data for read ports A and B based on the specified addresses
    out_a <= reg(to_integer(unsigned(read_a)));
    out_b <= reg(to_integer(unsigned(read_b)));
end behavioral;
