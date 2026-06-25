library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity register_file is
    Port (
        clk      : in  STD_LOGIC;                      -- System Clock
        rst      : in  STD_LOGIC;                      -- Asynchronous Reset
        acc_we   : in  STD_LOGIC;                      -- Accumulator Write Enable
        pc_we    : in  STD_LOGIC;                      -- Program Counter Write Enable
        pc_inc   : in  STD_LOGIC;                      -- Program Counter Increment
        data_in  : in  STD_LOGIC_VECTOR (7 downto 0);  -- Data to load into Accumulator
        addr_in  : in  STD_LOGIC_VECTOR (7 downto 0);  -- Address to load into PC (for Jumps)
        acc_out  : out STD_LOGIC_VECTOR (7 downto 0);  -- Accumulator Output
        pc_out   : out STD_LOGIC_VECTOR (7 downto 0)   -- Program Counter Output
    );
end register_file;

architecture Behavioral of register_file is
    signal acc_reg : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
    signal pc_reg  : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
begin
    process(clk, rst)
    begin
        -- Asynchronous Reset: Clears memory instantly if the reset button is pushed
        if rst = '1' then
            acc_reg <= (others => '0');
            pc_reg  <= (others => '0');
            
        -- Synchronous Actions: Only happen exactly when the clock ticks upward
        elsif rising_edge(clk) then
            
            -- Accumulator Logic
            if acc_we = '1' then
                acc_reg <= data_in;
            end if;

            -- Program Counter Logic (Can either jump to an address, or just count up by 1)
            if pc_we = '1' then
                pc_reg <= addr_in;
            elsif pc_inc = '1' then
                pc_reg <= pc_reg + 1;
            end if;
            
        end if;
    end process;

    -- Wire the internal memory out to the physical pins
    acc_out <= acc_reg;
    pc_out  <= pc_reg;

end Behavioral;