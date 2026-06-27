library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ram is
    Port ( 
        clk      : in  STD_LOGIC;
        we       : in  STD_LOGIC;                     -- Write Enable
        address  : in  STD_LOGIC_VECTOR (7 downto 0);
        data_in  : in  STD_LOGIC_VECTOR (7 downto 0); -- From Accumulator
        data_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end ram;

architecture Behavioral of ram is
    type ram_type is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
    signal RAM_MEMORY : ram_type := (others => x"00");
begin
    process(clk)
    begin
        if rising_edge(clk) then
            -- Synchronous Write
            if we = '1' then
                RAM_MEMORY(conv_integer(address(3 downto 0))) <= data_in;
            end if;
        end if;
    end process;
    
    -- Asynchronous Read
    data_out <= RAM_MEMORY(conv_integer(address(3 downto 0)));
end Behavioral;