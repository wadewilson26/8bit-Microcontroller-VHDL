library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity rom is
    Port ( 
        address  : in  STD_LOGIC_VECTOR (7 downto 0);
        data_out : out STD_LOGIC_VECTOR (7 downto 0)
    );
end rom;

architecture Behavioral of rom is
    -- Create a 16-byte memory array
    type rom_type is array (0 to 15) of STD_LOGIC_VECTOR(7 downto 0);
    
    -- Hardcode your program here!
    constant ROM_MEMORY : rom_type := (
        0 => x"05", -- 1. LOAD 5 (Opcode 0000, Operand 0101)
        1 => x"24", -- 2. ADD 4  (Opcode 0010, Operand 0100)
        2 => x"8F", -- 3. STORE Accumulator to RAM Address 'F' (Opcode 1000)
        others => x"00"
    );
begin
    -- Output the instruction at the current PC address
    data_out <= ROM_MEMORY(conv_integer(address(3 downto 0)));
end Behavioral;