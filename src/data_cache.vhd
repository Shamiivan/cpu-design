library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity data_cache is
    port(
        addr      : in  std_logic_vector(4 downto 0);  -- Input: Address for data access
        d_in      : in  std_logic_vector(31 downto 0); -- Input: Data to be written into cache
        reset     : in  std_logic;                      -- Input: Reset signal
        clk       : in  std_logic;                      -- Input: Clock signal
        data_write: in  std_logic;                      -- Input: Data write enable signal
        d_out     : out std_logic_vector(31 downto 0)  -- Output: Data read from cache
    );
end data_cache;

architecture behavioral of data_cache is 
    type slv_array is array (0 to 31) of std_logic_vector(31 downto 0);
    signal mem: slv_array;  -- Array to store data in cache
begin 
    -- RESET OR WRITE
    process (clk, reset, data_write) 
    begin 
        if reset = '1' then 
            -- Reset all elements of the cache to zero
            for i in 0 to 31 loop 
                mem(i) <= (others => '0');
            end loop; 
        elsif rising_edge(clk) then 
            -- Write data into the cache if data_write is enabled
            if data_write = '1' then 
                mem(to_integer(unsigned(addr))) <= d_in;
            end if;
        end if; 
    end process;

    -- OUTPUT 
    -- Read data from the cache based on the provided address
    d_out <= mem(to_integer(unsigned(addr)));
end behavioral;
