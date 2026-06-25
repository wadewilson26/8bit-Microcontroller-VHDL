library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_mcu is
    Port (
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        instruction : in  STD_LOGIC_VECTOR (7 downto 0); -- Top 4 bits: Opcode, Bottom 4: Operand
        mcu_out     : out STD_LOGIC_VECTOR (7 downto 0); -- Expose Accumulator to see the answer
        pc_monitor  : out STD_LOGIC_VECTOR (7 downto 0)  -- Expose PC to see what line we are on
    );
end top_mcu;

architecture Structural of top_mcu is
    -- 1. Declare the components we built earlier
    component alu is
        Port ( A, B : in STD_LOGIC_VECTOR(7 downto 0); ALU_Sel : in STD_LOGIC_VECTOR(2 downto 0); Result : out STD_LOGIC_VECTOR(7 downto 0); Zero : out STD_LOGIC);
    end component;

    component register_file is
        Port ( clk, rst, acc_we, pc_we, pc_inc : in STD_LOGIC; data_in, addr_in : in STD_LOGIC_VECTOR(7 downto 0); acc_out, pc_out : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    component control_unit is
        Port ( clk, rst : in STD_LOGIC; opcode : in STD_LOGIC_VECTOR(3 downto 0); zero_flag : in STD_LOGIC; alu_sel : out STD_LOGIC_VECTOR(2 downto 0); acc_we, pc_we, pc_inc : out STD_LOGIC);
    end component;

    -- 2. Create the "copper wires" to connect them together
    signal wire_alu_sel   : STD_LOGIC_VECTOR(2 downto 0);
    signal wire_acc_we    : STD_LOGIC;
    signal wire_pc_we     : STD_LOGIC;
    signal wire_pc_inc    : STD_LOGIC;
    signal wire_zero_flag : STD_LOGIC;
    
    signal wire_alu_result : STD_LOGIC_VECTOR(7 downto 0);
    signal wire_acc_out    : STD_LOGIC_VECTOR(7 downto 0);
    signal wire_pc_out     : STD_LOGIC_VECTOR(7 downto 0);
    signal wire_operand    : STD_LOGIC_VECTOR(7 downto 0);

begin
    -- Pad the 4-bit operand (e.g., the number '5') with zeros so the 8-bit ALU can read it
    wire_operand <= "0000" & instruction(3 downto 0);

    -- 3. Snap the pieces into the motherboard and solder the wires
    U_ALU: alu PORT MAP (
        A       => wire_acc_out,    -- Accumulator feeds into A
        B       => wire_operand,    -- Instruction operand feeds into B
        ALU_Sel => wire_alu_sel,
        Result  => wire_alu_result,
        Zero    => wire_zero_flag
    );

    U_REG: register_file PORT MAP (
        clk     => clk,
        rst     => rst,
        acc_we  => wire_acc_we,
        pc_we   => wire_pc_we,
        pc_inc  => wire_pc_inc,
        data_in => wire_alu_result, -- ALU answer goes back into Accumulator
        addr_in => wire_operand,
        acc_out => wire_acc_out,
        pc_out  => wire_pc_out
    );

    U_CU: control_unit PORT MAP (
        clk       => clk,
        rst       => rst,
        opcode    => instruction(7 downto 4), -- Top 4 bits of instruction go to the Brain
        zero_flag => wire_zero_flag,
        alu_sel   => wire_alu_sel,
        acc_we    => wire_acc_we,
        pc_we     => wire_pc_we,
        pc_inc    => wire_pc_inc
    );

    -- Wire internal signals to external pins so we can see them in the waveform
    mcu_out <= wire_acc_out;
    pc_monitor <= wire_pc_out;

end Structural;