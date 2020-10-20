library IEEE;
use IEEE.std_logic_1164.all;

entity fullAdder is
    port (
        in_A : in std_logic;
        in_B : in std_logic;
        c_in : in std_logic;
        sum : out std_logic;
        c_out : out std_logic
    );

end fullAdder;

architecture dataflow of fullAdder is

begin

    c_out <= in_A xor in_B xor c_in;
    c_out <= (in_A and in_B) or (c_in and in_A) or (c_in and in_B);

end architecture dataflow;

GEN_RES_LSB: for 0 to O_width - 1 generate
    
end generate GEN_RES_LSB;