library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_unit is
    Port (
        clk       : in  STD_LOGIC;
        rst       : in  STD_LOGIC;
        opcode    : in  STD_LOGIC_VECTOR (3 downto 0); -- The 4-bit instruction code
        zero_flag : in  STD_LOGIC;                     -- Flag from the ALU
        alu_sel   : out STD_LOGIC_VECTOR (2 downto 0); -- Tells ALU what math to do
        acc_we    : out STD_LOGIC;                     -- Tells Accumulator to save data
        pc_we     : out STD_LOGIC;                     -- Tells PC to jump
        pc_inc    : out STD_LOGIC                      -- Tells PC to count up by 1
    );
end control_unit;

architecture Behavioral of control_unit is
    -- Define the three states of our FSM
    type state_type is (FETCH, DECODE, EXECUTE);
    signal current_state, next_state : state_type;
begin
    -- 1. State Memory (Synchronous)
    process(clk, rst)
    begin
        if rst = '1' then
            current_state <= FETCH;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    -- 2. State Transition & Output Logic (Combinational)
    process(current_state, opcode, zero_flag)
    begin
        -- Default physical pin states to prevent accidental data overwrites
        alu_sel <= "110"; 
        acc_we  <= '0';
        pc_we   <= '0';
        pc_inc  <= '0';
        next_state <= current_state;

        case current_state is
            when FETCH =>
                pc_inc <= '1'; -- Move to the next instruction in memory
                next_state <= DECODE;

            when DECODE =>
                next_state <= EXECUTE;

            when EXECUTE =>
                -- Look at the 4-bit opcode and fire the correct hardware signals
                case opcode is
                    when "0000" => -- LOAD command
                        alu_sel <= "111"; -- Route data through ALU
                        acc_we  <= '1';   -- Save it to Accumulator
                        
                    when "0010" => -- ADD command
                        alu_sel <= "000"; -- Tell ALU to Add
                        acc_we  <= '1';   -- Save answer to Accumulator
                        
                    when "0110" => -- JMP (Unconditional Jump) command
                        pc_we   <= '1';   -- Overwrite PC with new address
                        
                    when "0111" => -- JZ (Jump if Zero) command
                        if zero_flag = '1' then
                            pc_we <= '1'; -- Only jump if ALU says result was 0
                        end if;
                        
                    when others =>
                        null; -- Do nothing for unknown codes
                end case;
                
                next_state <= FETCH; -- Loop back to start the next cycle
        end case;
    end process;
end Behavioral;