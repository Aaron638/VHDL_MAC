library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity carry_select_adder is
	generic (
		N : integer;
		P : integer);
	port (
		in_a : in std_logic_vector(N - 1 downto 0);
		in_b : in std_logic_vector(N - 1 downto 0);
		sum : out std_logic_vector(N - 1 downto 0);
		carry_out : out std_logic);

end carry_select_adder;

architecture structure of carry_select_adder is

	component carry_select_adder_block is
		generic (M : integer);
		port (
			in_a : in std_logic_vector(P - 1 downto 0);
			in_b : in std_logic_vector(P - 1 downto 0);
			sum : out std_logic_vector(P - 1 downto 0);
			carry_in : in std_logic;
			carry_out : out std_logic);

	end component;

	signal carry : std_logic_vector(N/P - 1 downto 0);

begin

	BLOCK_0 : carry_select_adder_block
	generic map(M => P)
	port map(
		in_a => in_a(P - 1 downto 0),
		in_b => in_b(P - 1 downto 0),
		sum => sum(P - 1 downto 0),
		carry_in => '0',
		carry_out => carry(0));

	BLOCK_GEN : for i in 1 to N/P - 1 generate
		BLOCK_I : carry_select_adder_block
		generic map(M => P)
		port map(
			in_a => in_a((P * i) + (P - 1) downto P * i),
			in_b => in_b((P * i) + (P - 1) downto P * i),
			sum => sum((P * i) + (P - 1) downto P * i),
			carry_in => carry(i - 1),
			carry_out => carry(i));

	end generate;
end structure;