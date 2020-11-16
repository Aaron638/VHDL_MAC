library IEEE;
use IEEE.std_logic_1164.all;

entity mult_layer is
	generic (O_width : integer);
	port (
		in_O : std_logic_vector(O_width - 1 downto 0);
		in_P : std_logic;
		in_res : in std_logic_vector(O_width - 2 downto 0);
		in_c : in std_logic;
		out_f : out std_logic;
		out_res : out std_logic_vector(O_width - 2 downto 0);
		out_c : out std_logic
	);
end mult_layer;

architecture structure of mult_layer is

	component and2g is
		port (
			in_A : in std_logic;
			in_B : in std_logic;
			out_F : out std_logic
		);
	end component;

	component halfAdder is
		port (
			in_A : in std_logic;
			in_B : in std_logic;
			sum : out std_logic;
			carry : out std_logic
		);
	end component;

	component fullAdder is
		port (
			in_A : in std_logic;
			in_B : in std_logic;
			c_in : in std_logic;
			sum : out std_logic;
			c_out : out std_logic
		);
	end component;

	--signals
	signal andg_res : std_logic_vector(O_width - 1 downto 0);
	signal carry : std_logic_vector(O_width - 2 downto 0);

begin

	GEN_AND : for i in 0 to O_width - 1 generate
		ANDGY0 : and2g
		port map(
			in_A => in_O(i),
			in_B => in_P,
			out_F => andg_res(i)
		);
	end generate GEN_AND;

	HA_START : halfAdder
	port map(
		in_A => andg_res(0),
		in_B => in_res(0),
		sum => out_f,
		carry => carry(0)
	);

	FA_GEN : for j in 1 to O_width - 2 generate
		FA_j : fullAdder
		port map(
			in_A => andg_res(j),
			in_B => in_res(j),
			c_in => carry(j - 1),
			sum => out_res(j - 1),
			c_out => carry(j)
		);
	end generate FA_GEN;

	FA_END : fullAdder
	port map(
		in_A => andg_res(O_width - 1),
		in_B => in_c,
		c_in => carry(O_width - 2),
		sum => out_res(O_width - 2),
		c_out => out_c
	);

end structure;