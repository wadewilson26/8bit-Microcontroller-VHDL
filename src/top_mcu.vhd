library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_mcu is
    Port ( 
        clk         : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        mcu_out     : out STD_LOGIC_VECTOR(7 downto 0); -- Monitor Accumulator
        pc_monitor  : out STD_LOGIC_VECTOR(7 downto 0)  -- Monitor Program Counter
    );
end top_mcu;

architecture Structural of top_mcu is
    -- Import all 5 modules (ALU, REG, CU, ROM, RAM)
    component alu is
        Port ( A, B : in STD_LOGIC_VECTOR(7 downto 0); ALU_Sel : in STD_LOGIC_VECTOR(2 downto 0); Result : out STD_LOGIC_VECTOR(7 downto 0); Zero : out STD_LOGIC);
    end component;
    
    component register_file is
        Port ( clk, rst, acc_we, pc_we, pc_inc : in STD_LOGIC; data_in, addr_in : in STD_LOGIC_VECTOR(7 downto 0); acc_out, pc_out : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    component control_unit is
        Port ( clk, rst : in STD_LOGIC; opcode : in STD_LOGIC_VECTOR(3 downto 0); zero_flag : in STD_LOGIC; alu_sel : out STD_LOGIC_VECTOR(2 downto 0); acc_we, pc_we, pc_inc, ram_we : out STD_LOGIC);
    end component;
    
    component rom is
        Port ( address : in STD_LOGIC_VECTOR(7 downto 0); data_out : out STD_LOGIC_VECTOR(7 downto 0));
    end component;
    
    component ram is
        Port ( clk : in STD_LOGIC; we : in STD_LOGIC; address, data_in : in STD_LOGIC_VECTOR(7 downto 0); data_out : out STD_LOGIC_VECTOR(7 downto 0));
    end component;

    -- Internal routing wires
    signal wire_alu_sel : STD_LOGIC_VECTOR(2 downto 0);
    signal wire_acc_we, wire_pc_we, wire_pc_inc, wire_zero_flag, wire_ram_we : STD_LOGIC;
    signal wire_alu_result, wire_acc_out, wire_pc_out : STD_LOGIC_VECTOR(7 downto 0);
    signal wire_instruction, wire_operand, wire_ram_out : STD_LOGIC_VECTOR(7 downto 0);
begin
    -- Pad the lower 4-bit operand from the fetched instruction to map to 8-bit buses
    wire_operand <= "0000" & wire_instruction(3 downto 0);
    
    -- Port Map 1: ROM (Instruction Memory)
    U_ROM: rom PORT MAP (address => wire_pc_out, data_out => wire_instruction);
    
    -- Port Map 2: RAM (Data Memory)
    U_RAM: ram PORT MAP (clk => clk, we => wire_ram_we, address => wire_operand, data_in => wire_acc_out, data_out => wire_ram_out);
    
    -- Port Map 3: ALU Integration
    U_ALU: alu PORT MAP (A => wire_acc_out, B => wire_operand, ALU_Sel => wire_alu_sel, Result => wire_alu_result, Zero => wire_zero_flag);
    
    -- Port Map 4: Register File Integration
    U_REG: register_file PORT MAP (clk => clk, rst => rst, acc_we => wire_acc_we, pc_we => wire_pc_we, pc_inc => wire_pc_inc, data_in => wire_alu_result, addr_in => wire_operand, acc_out => wire_acc_out, pc_out => wire_pc_out);
    
    -- Port Map 5: Control Unit Integration
    U_CU: control_unit PORT MAP (clk => clk, rst => rst, opcode => wire_instruction(7 downto 4), zero_flag => wire_zero_flag, alu_sel => wire_alu_sel, acc_we => wire_acc_we, pc_we => wire_pc_we, pc_inc => wire_pc_inc, ram_we => wire_ram_we);
    
    -- Wire to external pins for monitoring
    mcu_out <= wire_acc_out; 
    pc_monitor <= wire_pc_out;
end Structural;