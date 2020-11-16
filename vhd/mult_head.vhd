library IEEE;
use IEEE.std_logic_1164.all;

-- The head of a fixed point multiplier is 2 rows of O_wide 2-bit AND gates.
-- In the second row, is O adders, half adders on the ends, and full adders in between.

entity mult_head is
	generic (O_width : integer);
	port (
		in_O : in std_logic_vector(O_width - 1 downto 0);
		in_P : in std_logic_vector(1 downto 0);
		out_f0 : out std_logic;
		out_f1 : out std_logic;
		out_res : out std_logic_vector(O_width - 2 downto 0);
		out_c : out std_logic
	);
end mult_head;

architecture structure of mult_head is

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

	component fullAdder
		port (
			in_A : in std_logic;
			in_B : in std_logic;
			c_in : in std_logic;
			sum : out std_logic;
			c_out : out std_logic
		);
	end component;

	--signals
	signal row_zero : std_logic_vector(O_width - 1 downto 0);
	signal row_one : std_logic_vector(O_width - 1 downto 0);
	signal carries : std_logic_vector(O_width - 1 downto 0);
	signal s_out_carry : std_logic;
	signal s_out_res : std_logic_vector(O_width - 2 downto 0);
	signal s_out0 : std_logic;

begin
	--Generate 2 rows of AND gates
	--First AND gate result is F0
	ANDGX0Y0 : and2g
	port map(
		in_A => in_O(0),
		in_B => in_P(0),
		out_F => out_f0
	);

	GEN_ROW0 : for x in 1 to O_width - 1 generate
		ANDGY0 : and2g
		port map(
			in_A => in_O(x),
			in_B => in_P(0),
			out_F => row_zero(x)
		);
	end generate GEN_ROW0;

	GEN_ROW1 : for xx in 0 to O_width - 1 generate
		ANDGY1 : and2g
		port map(
			in_A => in_O(xx),
			in_B => in_P(1),
			out_F => row_one(xx)
		);
	end generate GEN_ROW1;

	--Generate First Half adder, result is F1
	HA0 : halfAdder port map(
		in_A => row_zero(1),
		in_B => row_one(0),
		sum => out_f1,
		carry => carries(0)
	);

	--Generate full adders
	CHECK_2 : if O_width > 2 generate
		GEN_ADDERS : for i in 1 to O_width - 2 generate
			FAX : fullAdder port map(
				in_A => row_zero(i + 1),
				in_B => row_one(i),
				c_in => carries(i - 1),
				sum => out_res(i - 1),
				c_out => carries(i)
			);
		end generate GEN_ADDERS;
	end generate CHECK_2;

	--Generate half adder at end, result is carry output
	HA1 : halfAdder port map(
		in_A => carries(O_width - 2),
		in_B => row_one(O_width - 1),
		sum => out_res(O_width - 2),
		carry => out_c
	);

end architecture structure;