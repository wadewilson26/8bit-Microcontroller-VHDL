library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_control_unit is
end tb_control_unit;

architecture behavior of tb_control_unit is
    component control_unit
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        opcode    : in  STD_LOGIC_VECTOR (3 downto 0);
        zero_flag : in  STD_LOGIC;
        alu_sel   : out STD_LOGIC_VECTOR (2 downto 0);
        acc_we    : out STD_LOGIC;
        pc_we     : out STD_LOGIC;
        pc_inc    : out STD_LOGIC
    );
    end component;

    signal clk       : STD_LOGIC := '0';
    signal rst       : STD_LOGIC := '0';
    signal opcode    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
    signal zero_flag : STD_LOGIC := '0';
    signal alu_sel   : STD_LOGIC_VECTOR (2 downto 0);
    signal acc_we    : STD_LOGIC;
    signal pc_we     : STD_LOGIC;
    signal pc_inc    : STD_LOGIC;

    constant clk_period : time := 10 ns;

begin
    uut: control_unit PORT MAP (
        clk => clk, rst => rst, opcode => opcode, zero_flag => zero_flag,
        alu_sel => alu_sel, acc_we => acc_we, pc_we => pc_we, pc_inc => pc_inc
    );

    clk_process :process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        -- Reset FSM to FETCH state
        rst <= '1';
        wait for 15 ns;
        rst <= '0';
        
        -- Test 1: Send an 'ADD' instruction (Opcode 0010)
        -- Cycle: FETCH (10ns) -> DECODE (10ns) -> EXECUTE (10ns)
        opcode <= "0010";
        wait for 30 ns;
        
        -- Test 2: Send a 'JMP' instruction (Opcode 0110)
        opcode <= "0110";
        wait for 30 ns;

        -- Test 3: Send a 'JZ' instruction but Zero Flag is 0 (Should not jump)
        opcode <= "0111";
        zero_flag <= '0';
        wait for 30 ns;

        wait;
    end process;
end behavior;