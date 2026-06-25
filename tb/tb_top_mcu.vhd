library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_mcu is
end tb_top_mcu;

architecture behavior of tb_top_mcu is
    component top_mcu
    Port ( clk, rst : in STD_LOGIC; instruction : in STD_LOGIC_VECTOR(7 downto 0); mcu_out, pc_monitor : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    signal clk         : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '0';
    signal instruction : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal mcu_out     : STD_LOGIC_VECTOR(7 downto 0);
    signal pc_monitor  : STD_LOGIC_VECTOR(7 downto 0);

    constant clk_period : time := 10 ns;
begin
    uut: top_mcu PORT MAP ( clk => clk, rst => rst, instruction => instruction, mcu_out => mcu_out, pc_monitor => pc_monitor );

    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    stim_proc: process
    begin
        rst <= '1'; wait for 15 ns; rst <= '0';
        
        -- LOAD 5 into Accumulator (Opcode 0000, Operand 0101 -> Hex 05)
        instruction <= x"05";
        wait for 30 ns; -- Wait 3 cycles for Fetch, Decode, Execute
        
        -- ADD 4 to Accumulator (Opcode 0010, Operand 0100 -> Hex 24)
        instruction <= x"24";
        wait for 30 ns;

        wait;
    end process;
end behavior;