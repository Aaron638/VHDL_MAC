library IEEE;
use IEEE.std_logic_1164.all;

entity halfAdder is
    port (
        in_A : in std_logic;
        in_B : in std_logic;
        sum : out std_logic;
        carry : out std_logic
    );
end entity halfAdder;

architecture dataflow of halfAdder is

begin

    sum <= in_A xor in_B;
    carry <= in_A and in_B;

end architecture dataflow;