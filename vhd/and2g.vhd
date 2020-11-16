library IEEE;
use IEEE.std_logic_1164.all;

-- Entity declaration

entity and2g is

    port(in_A  : in std_logic;      -- AND gate input
         in_B  : in std_logic;      -- AND gate input
         out_F : out std_logic);    -- AND gate output

end and2g;

-- Architecture definition

architecture andLogic of and2g is

 begin
    
    out_F <= in_A AND in_B;

end andLogic; 