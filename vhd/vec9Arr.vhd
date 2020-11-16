library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--Array of 9 16-bit numbers
package vec9Arr is 
	type vec9Arr is array (8 downto 0) of std_logic_vector(15 downto 0);
end package;