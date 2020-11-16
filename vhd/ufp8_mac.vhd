library IEEE;
use IEEE.STD_LOGIC_1164.all;
use work.vec9Arr.all; -- importing vec9arr

-- unsigned fixed point 8 bit multiply and accumulate PE
-- filter size RS = 9
-- (total ifmap size is HW)
-- produces one index of feature map

-- Repeat (H-R)*(W-S) times, assuming stride size U = 1.

entity ufp8_mac is
	port (
		in_wt : in vec9Arr; -- weights
		in_act : in vec9Arr; -- activations
		out_psum : out std_logic_vector(15 downto 0) -- output 
	);
end ufp8_mac;

architecture structure of ufp8_mac is

	component multiplier is
		generic (
			O_width : integer;
			P_width : integer
		);
		port (
			in_O : in std_logic_vector(O_width - 1 downto 0);
			in_P : in std_logic_vector(P_width - 1 downto 0);
			out_F : out std_logic_vector((O_width + P_width) - 1 downto 0)
		);
	end component;

	component carry_select_adder is
		generic (
			N : integer;
			P : integer);
		port (
			in_a : in std_logic_vector(N - 1 downto 0);
			in_b : in std_logic_vector(N - 1 downto 0);
			sum : out std_logic_vector(N - 1 downto 0);
			carry_out : out std_logic);
	end component;

	signal products : vec9Arr;
	signal sums : vec9Arr;
	-- carries go nowhere
	signal carries : std_logic_vector(8 downto 0);

begin

	BLOCK_MULT : multiplier
	generic map(
		O_width => 8,
		P_width => 8)
	port map(
		in_O => in_wt(0),
		in_P => in_act(0),
		out_F => products(0)
	);

	GEN_LAYER : for i in 1 to 8 generate
		BLOCK_MULT : multiplier
		generic map(
			O_width => 8,
			P_width => 8)
		port map(
			in_O => in_wt(i),
			in_P => in_act(i),
			out_F => products(i)
		);

		BLOCK_ADD : carry_select_adder
		generic map(
			N => 16,
			P => 4)
		port map(
			in_a => products(i - 1),
			in_b => products(i),
			sum => sums(i-1),
			carry_out => carries(i-1)
		);

	end generate GEN_LAYER;

	--sums(8) goes nowhere
	sums(8) <= b"0000_0000_0000_0000";
	--final sum is the output
	out_psum <= sums(7);

end architecture structure;