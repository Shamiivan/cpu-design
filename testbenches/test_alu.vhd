library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_tb is
end alu_tb;

architecture behavior of alu_tb is 
   -- Component Declaration for the Unit Under Test (UUT)
   COMPONENT alu
   PORT(
        x : IN std_logic_vector(31 downto 0);
        y : IN std_logic_vector(31 downto 0);
        func : IN std_logic_vector(1 downto 0);
        add_sub : IN std_logic;
        logic_func : IN std_logic_vector(1 downto 0);
        output : OUT std_logic_vector(31 downto 0);
        overflow : OUT std_logic;
        zero : OUT std_logic
       );
   END COMPONENT;
      --Inputs
  signal x : std_logic_vector(31 downto 0) := (others => '0');
  signal y : std_logic_vector(31 downto 0) := (others => '0');
  signal func : std_logic_vector(1 downto 0) := (others => '0');
  signal add_sub : std_logic := '0';
  signal logic_func : std_logic_vector(1 downto 0) := (others => '0');
 --Outputs
  signal output : std_logic_vector(31 downto 0);
  signal overflow : std_logic;
  signal zero : std_logic;

  -- Instantiate the Unit Under Test (UUT)
  uut: alu PORT MAP (
         x => x,
         y => y,
         func => func,
         add_sub => add_sub,
         logic_func => logic_func,
         output => output,
         overflow => overflow,
         zero => zero
       );

  -- Stimulus process
  process stim_proc
  begin 
    -- hold reset state for 100 ns.
    x <= x"0000000A";
    y <= x"00000002";
    func <= "00";
    add_sub <= '0';
    logic_func <= "00";
    wait for 100 ns;
    
    -- Testing complete
    wait;
  end process stim_proc;

END;
