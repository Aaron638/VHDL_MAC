library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity carry_select_adder_block is
generic( M : integer);
port(
	in_a : in std_logic_vector(M-1 downto 0);
	in_b : in std_logic_vector(M-1 downto 0);
	sum : out std_logic_vector(M-1 downto 0);
	carry_in : in std_logic;
	carry_out : out std_logic);

end carry_select_adder_block;

architecture structure of carry_select_adder_block is
	
	component full_adder is
	port(
		in_A : in std_logic;
		in_B : in std_logic;
		c_in : in std_logic;
		sum : out std_logic;
		c_out : out std_logic);

	end component;

	component one_bit_mux is
	port(
		in_a : in std_logic;
		in_b : in std_logic;
		sel : in std_logic;
		output : out std_logic);

	end component;


	signal result_0 : std_logic_vector(M-1 downto 0);
	signal result_1 : std_logic_vector(M-1 downto 0);
	signal carry_0 : std_logic_vector(M-1 downto 0);
	signal carry_1 : std_logic_vector(M-1 downto 0);
begin
ADDER_0 : full_adder
port map(
	in_A => in_a(0),
	in_B => in_b(0),
	c_in => carry_in,
	sum => result_0(0),
	c_out => carry_0(0));

ADDER_1 : full_adder
port map(
	in_A => in_a(0),
	in_B => in_b(0),
	c_in => carry_in,
	sum => result_1(0),
	c_out => carry_1(0));

GEN_ADD : for i in 1 to M-1 generate
ADD_C0 : full_adder
port map(
	in_A => in_a(i),
	in_B => in_b(i),
	c_in => carry_0(i-1),
	sum => result_0(i),
	c_out => carry_0(i));

ADD_C1 : full_adder
port map(
	in_A => in_a(i),
	in_B => in_b(i),
	c_in => carry_1(i-1),
	sum => result_1(i),
	c_out => carry_1(i));

end generate;

GEN_MUX : for j in 0 to M-1 generate

SUM_MUX : one_bit_mux
port map(
	in_a => result_0(j),
	in_b => result_1(j),
	sel => carry_in,
	output => sum(j));
end generate;

CARRY_OUT_MUX : one_bit_mux
port map(
	in_a => carry_0(M-1),
	in_b => carry_1(M-1),
	sel => carry_in,
	output => carry_out);

end structure;