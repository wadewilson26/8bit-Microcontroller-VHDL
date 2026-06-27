library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port ( 
        clk       : in  STD_LOGIC;                     
        rst       : in  STD_LOGIC;                     
        opcode    : in  STD_LOGIC_VECTOR (3 downto 0); 
        zero_flag : in  STD_LOGIC;                     
        alu_sel   : out STD_LOGIC_VECTOR (2 downto 0); 
        acc_we    : out STD_LOGIC;                     
        pc_we     : out STD_LOGIC;                     
        pc_inc    : out STD_LOGIC;
        ram_we    : out STD_LOGIC                      -- NEW: RAM Write Enable
    );
end control_unit;

architecture Behavioral of control_unit is
    type state_type is (FETCH, DECODE, EXECUTE);
    signal current_state, next_state : state_type;
begin
    -- 1. Synchronous State Register
    process(clk, rst)
    begin
        if rst = '1' then 
            current_state <= FETCH; 
        elsif rising_edge(clk) then 
            current_state <= next_state; 
        end if;
    end process;

    -- 2. Combinational Next-State and Output Logic
    process(current_state, opcode, zero_flag)
    begin
        -- Default physical pin states to prevent unintended data latches
        alu_sel <= "110"; 
        acc_we <= '0'; 
        pc_we <= '0'; 
        pc_inc <= '0'; 
        ram_we <= '0'; -- Default to no RAM writing
        next_state <= current_state;
        
        case current_state is
            when FETCH => 
                next_state <= DECODE;
                
            when DECODE => 
                next_state <= EXECUTE; 
                
            when EXECUTE =>
                pc_inc <= '1';
                case opcode is
                    when "0000" => alu_sel <= "111"; acc_we <= '1'; -- LOAD Command
                    when "0010" => alu_sel <= "000"; acc_we <= '1'; -- ADD Command
                    when "0110" => pc_we <= '1';                    -- JMP Command
                    when "0111" => if zero_flag = '1' then pc_we <= '1'; end if; -- JZ Command
                    when "1000" => ram_we <= '1';                   -- STORE Command (Save ACC to RAM)
                    when others => null;                            
                end case;
                next_state <= FETCH; 
        end case;
    end process;
end Behavioral;