library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_top_mcu is
-- Testbenches have no ports
end tb_top_mcu;

architecture behavior of tb_top_mcu is
    -- Bring in the Top-Level Motherboard
    component top_mcu
        Port ( clk, rst : in STD_LOGIC; mcu_out, pc_monitor : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    -- Stimulus signals
    signal clk         : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '0';
    signal mcu_out     : STD_LOGIC_VECTOR(7 downto 0);
    signal pc_monitor  : STD_LOGIC_VECTOR(7 downto 0);
    
    constant clk_period : time := 10 ns;
begin
    -- Map signals to MCU
    uut: top_mcu PORT MAP ( clk => clk, rst => rst, mcu_out => mcu_out, pc_monitor => pc_monitor );

    -- Provide the system heartbeat (Clock generation)
    clk_process :process
    begin
        clk <= '0'; wait for clk_period/2;
        clk <= '1'; wait for clk_period/2;
    end process;

    -- Initialization Process
    stim_proc: process
    begin
        -- Press the reset button for 15ns to clear all registers
        rst <= '1';
        wait for 15 ns; 
        
        -- Release reset and let the MCU automatically fetch from the ROM
        rst <= '0'; 
        
        -- Pause testbench stimulus and let the simulation run
        wait; 
    end process;
end behavior;