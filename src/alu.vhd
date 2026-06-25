library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity alu is
    Port (
        A       : in  STD_LOGIC_VECTOR (7 downto 0);
        B       : in  STD_LOGIC_VECTOR (7 downto 0);
        ALU_Sel : in  STD_LOGIC_VECTOR (2 downto 0);
        Result  : out STD_LOGIC_VECTOR (7 downto 0);
        Zero    : out STD_LOGIC
    );
end alu;

architecture Behavioral of alu is
    signal temp_result : STD_LOGIC_VECTOR (7 downto 0);
begin
    process(A, B, ALU_Sel)
    begin
        case ALU_Sel is
            when "000" => temp_result <= A + B;       
            when "001" => temp_result <= A - B;       
            when "010" => temp_result <= A and B;     
            when "011" => temp_result <= A or B;      
            when "100" => temp_result <= A xor B;     
            when "101" => temp_result <= not A;       
            when "110" => temp_result <= A;           
            when others => temp_result <= B;          
        end case;
    end process;

    Result <= temp_result;
    Zero <= '1' when temp_result = "00000000" else '0';
end Behavioral;