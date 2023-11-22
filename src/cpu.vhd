library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity datapath is
    port(
        -- INPUTS 
        reset : in std_logic; 
        clk : in std_logic; 
        -- OUTPUTS 
        rs_out, rt_out : out std_logic_vector(31 downto 0);
        pc_out : out std_logic_vector(31 downto 0);
        overflow : out std_logic;
        zero : out std_logic
    );
end datapath;

architecture path of datapath is
    -- Declare the components found in the entity 
    component next_address
        port(
            rt, rs : in std_logic_vector(31 downto 0);
            pc : in std_logic_vector(31 downto 0);
            target_address : in std_logic_vector(25 downto 0);
            branch_type : in std_logic_vector(1 downto 0);
            pc_sel : in std_logic_vector(1 downto 0);
            next_pc : out std_logic_vector(31 downto 0)
        );
    end component;

    component pc 
        port(
            pc_in : in std_logic_vector(31 downto 0);
            reset : in std_logic;
            clk : in std_logic; 
            pc_out : out std_logic_vector(31 downto 0)
        ); 
    end component;

    component instruction_cache 
        port(
            addr : in std_logic_vector(4 downto 0);
            instr : out std_logic_vector(31 downto 0)
        );
    end component;

    component regfile
        port(
            din : in std_logic_vector(31 downto 0); 
            reset : in std_logic; 
            clk : in std_logic; 
            write : in std_logic;
            read_a : in std_logic_vector(4 downto 0);
            read_b : in std_logic_vector(4 downto 0);
            write_address : in std_logic_vector(4 downto 0);
            out_a : out std_logic_vector(31 downto 0);
            out_b : out std_logic_vector(31 downto 0)
        );
    end component;

    component signextend
        port(
            imm : in std_logic_vector(15 downto 0);
            func : in std_logic_vector(1 downto 0);
            ext_imm : out std_logic_vector(31 downto 0)
        );
    end component;

    component alu
        port(
            x, y : in std_logic_vector(31 downto 0);
            add_sub : in std_logic;
            logic_func : in std_logic_vector(1 downto 0);
            func : in std_logic_vector(1 downto 0);
            output : out std_logic_vector(31 downto 0);
            overflow : out std_logic;
            zero : out std_logic
        );
    end component;

    component data_cache 
        port(
            addr : in std_logic_vector(4 downto 0);
            d_in : in std_logic_vector(31 downto 0);
            reset : in std_logic;
            clk : in std_logic; 
            data_write : in std_logic; 
            d_out : out std_logic_vector(31 downto 0)
        );
    end component;

    -- Declare signals used to interconnect components
    -- Control Signals 
    signal pc_sel : std_logic_vector(1 downto 0);
    signal branch_type : std_logic_vector(1 downto 0);
    -- MUX INPUTS
    signal reg_dst : std_logic; -- MUX rt or rd
    signal alu_src : std_logic; -- MUX alu rt or sign_extend output 
    signal reg_in_src : std_logic; -- MUX ALU output or d_cache output
    -- I_CACHE 
    signal reg_write : std_logic; -- Write regfile
    -- SIGN EXTEND AND ALU
    signal func : std_logic_vector(1 downto 0 );
    -- ALU 
    signal add_sub : std_logic;
    signal logic_func : std_logic_vector(1 downto 0 );
    -- D_CACHE 
    signal data_write : std_logic;
    signal op : std_logic_vector(5 downto 0);
    signal func_r : std_logic_vector(5 downto 0);
    signal ctrl : std_logic_vector(13 downto 0); 

    -- PC
    signal next_pc, pc_n: std_logic_vector(31 downto 0);
    signal pc_i: std_logic_vector(4 downto 0); 
    -- I_CACHE 
    signal instr: std_logic_vector(31 downto 0);
    signal rs, rt, rd: std_logic_vector(4 downto 0);
    signal imm: std_logic_vector(15 downto 0);
    signal target_address: std_logic_vector(25 downto 0);
    -- REGISTER FILE 
    signal write_address: std_logic_vector(4 downto 0);
    signal out_a, out_b: std_logic_vector(31 downto 0);
    signal d_in: std_logic_vector(31 downto 0); 
    -- SIGN EXTEND 
    signal ext_imm: std_logic_vector(31 downto 0); 
    -- ALU 
    signal alu_y: std_logic_vector(31 downto 0);
    signal alu_out: std_logic_vector(31 downto 0);
    -- D_CACHE 
    signal d_addr: std_logic_vector(4 downto 0);
    signal d_out: std_logic_vector(31 downto 0); 

    -- Declare configuration specification
    for U1 : next_address use entity WORK.next_address(nextaddr);
    for U2 : pc use entity WORK.pc(pc_arch); 
    for U3 : i_cache use entity WORK.i_cache(icache_arch); 
    for U4 : regfile use entity WORK.regfile(reg); 
    for U5 : signextend use entity WORK.signextend(signextend_arch); 
    for U6 : alu use entity WORK.alu(alu_arch); 
    for U7 : d_cache use entity WORK.d_cache(dcache_arch); 

begin 
    pc_i <= pc_n(4 downto 0);
    rs <= instr(25 downto 21); 
    rt <= instr(20 downto 16); 
    rd <= instr(15 downto 11); 
    imm <= instr(15 downto 0); 
    target_address <= instr(25 downto 0);
    -- reg_dst MUX 
    with reg_dst select
        write_address <= rt when '0', 
                        rd when others; 
    -- alu_src MUX 
    with alu_src select 
        alu_y <= out_b when '0', 
                 ext_imm when others;
    d_addr <= alu_out(4 downto 0);
    -- reg_in_src MUX 
    with reg_in_src select 
        d_in <= d_out when '0', 
                alu_out when others; 

    -- OUTPUTS
    rs_out <= out_a; 
    rt_out <= out_b;
    pc_out <= pc_n;

    U1 : next_address port map(
        rt => out_b, 
        rs => out_a, 
        pc => pc_n, 
        target_address => target_address, 
        branch_type => branch_type, 
        pc_sel => pc_sel, 
        next_pc => next_pc
    );
    U2 : pc port map(
        pc_in => next_pc, 
        reset => reset, 
        clk => clk, 
        pc_out => pc_n
    );
    U3 : i_cache port map(
        addr => pc_i, 
        instr => instr
    );
    U4 : regfile port map(
        din => d_in, 
        reset => reset, 
        clk => clk, 
        write => reg_write, 
        read_a => rs, 
        read_b => rt, 
        write_address => write_address, 
        out_a => out_a, 
        out_b => out_b
    ); 
    U5 : signextend port map(
        imm => imm, 
        func => func, 
        ext_imm => ext_imm
    ); 
    U6 : alu port map(
        x => out_a, 
        y => alu_y, 
        add_sub => add_sub, 
        logic_func => logic_func, 
        func => func, 
        output => alu_out, 
        overflow => overflow, 
        zero => zero
    );
    U7 : d_cache port map(
        addr => d_addr, 
        d_in => out_b, 
        reset => reset, 
        clk => clk, 
        data_write => data_write, 
        d_out => d_out
    );

    reg_write <= ctrl(13); 
    reg_dst <= ctrl(12); 
    reg_in_src <= ctrl(11); 
    alu_src <= ctrl(10); 
    add_sub <= ctrl(9); 
    data_write <= ctrl(8); 
    logic_func <= ctrl(7 downto 6); 
    func <= ctrl(5 downto 4); 
    branch_type <= ctrl(3 downto 2); 
    pc_sel <= ctrl(1 downto 0); 

    op <= instr(31 downto 26); 
    func_r <= instr(5 downto 0); 
    process(op, func_r) 
    begin 
        if (op = "000000") then 
            case func_r is 
                when "100000" => -- add
                    ctrl <= "11100000100000";
                when "100010" => -- sub
                    ctrl <= "11101000100000";
                when "101010" => -- slt
                    ctrl <= "11101000010000";
                when "100100" => -- and
                    ctrl <= "11101000110000";
                when "100101" => -- or
                    ctrl <= "11101001110000";
                when "100110" => -- xor
                    ctrl <= "11101010110000";
                when "100111" => -- nor
                    ctrl <= "11101011110000";
                when "001000" => -- jr
                    ctrl <= "00000000000010";
                when others => 
                    ctrl <= "00000000000000";
            end case;
        else 
            case op is 
                when "001111" => -- lui
                    ctrl <= "10110000000000";
                when "001000" => -- addi
                    ctrl <= "10110000100000";
                when "001010" => -- slti 
                    ctrl <= "10111000010000";
                when "001100" => -- andi 
                    ctrl <= "10110000110000"; 
                when "001101" => -- ori
                    ctrl <= "10110001110000"; 
                when "001110" => -- xori
                    ctrl <= "10110010110000"; 
                when "100011" => -- lw
                    ctrl <= "10010010100000"; 
                when "101011" => -- sw
                    ctrl <= "00010100100000"; 
                when "000010" => -- j
                    ctrl <= "00000000000001";
                when "000001" => -- bltz
                    ctrl <= "00000000001100";
                when "000100" => -- beq
                    ctrl <= "00000000000100";
                when "000101" => --bne 
                    ctrl <= "00000000001000";
                when others => 
                    ctrl <= "00000000000000";
            end case;
        end if;
    end process;
end path;
