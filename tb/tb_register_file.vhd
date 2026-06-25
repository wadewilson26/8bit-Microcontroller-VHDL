library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_register_file is
end tb_register_file;

architecture behavior of tb_register_file is
    component register_file
    Port (
        clk      : in  STD_LOGIC;
        rst      : in  STD_LOGIC;
        acc_we   : in  STD_LOGIC;
        pc_we    : in  STD_LOGIC;
        pc_inc   : in  STD_LOGIC;
        data_in  : in  STD_LOGIC_VECTOR (7 downto 0);
        addr_in  : in  STD_LOGIC_VECTOR (7 downto 0);
        acc_out  : out STD_LOGIC_VECTOR (7 downto 0);
        pc_out   : out STD_LOGIC_VECTOR (7 downto 0)
    );
    end component;

    -- Signals to connect
    signal clk      : STD_LOGIC := '0';
    signal rst      : STD_LOGIC := '0';
    signal acc_we   : STD_LOGIC := '0';
    signal pc_we    : STD_LOGIC := '0';
    signal pc_inc   : STD_LOGIC := '0';
    signal data_in  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal addr_in  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal acc_out  : STD_LOGIC_VECTOR (7 downto 0);
    signal pc_out   : STD_LOGIC_VECTOR (7 downto 0);

    -- Clock period definition
    constant clk_period : time := 10 ns;

begin
    uut: register_file PORT MAP (
        clk => clk, rst => rst, acc_we => acc_we, pc_we => pc_we, 
        pc_inc => pc_inc, data_in => data_in, addr_in => addr_in, 
        acc_out => acc_out, pc_out => pc_out
    );

    -- Clock generating process
    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    -- Simulation instructions
    stim_proc: process
    begin
        -- 1. Reset the system
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        
        -- 2. Write hex value 'AA' into the Accumulator
        acc_we <= '1';
        data_in <= x"AA";
        wait for clk_period;
        acc_we <= '0';
        
        -- 3. Let the Program Counter tick up twice
        pc_inc <= '1';
        wait for clk_period * 2;
        pc_inc <= '0';
        
        -- 4. Simulate a Jump command by forcing the PC to address 'FF'
        pc_we <= '1';
        addr_in <= x"FF";
        wait for clk_period;
        pc_we <= '0';

        wait;
    end process;
end behavior;