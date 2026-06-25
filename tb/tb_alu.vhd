library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu is
end tb_alu;

architecture behavior of tb_alu is
    component alu
    Port (
        A       : in  STD_LOGIC_VECTOR (7 downto 0);
        B       : in  STD_LOGIC_VECTOR (7 downto 0);
        ALU_Sel : in  STD_LOGIC_VECTOR (2 downto 0);
        Result  : out STD_LOGIC_VECTOR (7 downto 0);
        Zero    : out STD_LOGIC
    );
    end component;

    signal A       : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal B       : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal ALU_Sel : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
    signal Result  : STD_LOGIC_VECTOR (7 downto 0);
    signal Zero    : STD_LOGIC;

begin
    uut: alu PORT MAP (A => A, B => B, ALU_Sel => ALU_Sel, Result => Result, Zero => Zero);

    stim_proc: process
    begin
        -- Test 1: Addition (10 + 5 = 15 or '0F' in Hex)
        A <= x"0A"; 
        B <= x"05"; 
        ALU_Sel <= "000"; 
        wait for 10 ns;

        -- Test 2: Subtraction (10 - 5 = 5 or '05' in Hex)
        ALU_Sel <= "001"; 
        wait for 10 ns;

        -- Test 3: Logical AND (10 AND 5 = 0 or '00' in Hex)
        ALU_Sel <= "010"; 
        wait for 10 ns;

        wait;
    end process;
end behavior;