library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Fixed point multiplier   

entity multiplier is
	generic (
		O_width : integer;
		P_width : integer
	);

	port (
		in_O : in std_logic_vector(O_width - 1 downto 0);
		in_P : in std_logic_vector(P_width - 1 downto 0);
		out_F : out std_logic_vector((O_width + P_width) - 1 downto 0)
	);

end multiplier;

architecture structure of multiplier is

	component mult_head is
		generic (O_width : integer);
		port (
			in_O : in std_logic_vector(O_width - 1 downto 0);
			in_P : in std_logic_vector(1 downto 0);
			out_f0 : out std_logic;
			out_f1 : out std_logic;
			out_res : out std_logic_vector(O_width - 2 downto 0);
			out_c : out std_logic
		);
	end component;

	component mult_layer is
		generic (O_width : integer);
		port (
			in_O : std_logic_vector(O_width - 1 downto 0);
			in_P : std_logic;
			in_res : in std_logic_vector(O_width - 1 downto 0);
			in_c : in std_logic;
			out_f : out std_logic;
			out_res : out std_logic_vector(O_width - 1 downto 0);
			out_c : out std_logic
		);
	end component;

	--For mult_head, take the first 2 inputs of P
	alias s_P01 is in_P(1 downto 0);

	type vecArr is array (P_width - 2 downto 0) of std_logic_vector(O_width - 1 downto 0);
	signal row_res : vecArr;

begin

	--Place input into mult_head
	-- outputs F[0:1]
	BLOCK_HEAD : mult_head
	generic map(O_width => O_width)
	port map(
		in_O => in_O,
		in_P => s_P01,
		out_f0 => out_F(0),
		out_f1 => out_F(1),
		out_res => row_res(0)(O_width - 2 downto 0),
		out_c => row_res(0)(O_width - 1)
	);

	--Generate layers P-2 times
	--outputs F[2 : P_width-1]
	GEN_LAYER : for y in 1 to P_width - 2 generate
		BLOCK_LAYER : mult_layer
		generic map(O_width => O_width)
		port map(
			in_O =>	in_O,
			in_P =>	in_P(y+1),
			in_res => row_res(y-1)(O_width - 2 downto 0),
			in_c => row_res(y-1)(O_width - 1),
			out_f => out_F(y+1),
			out_res => row_res(y)(O_width - 2 downto 0),
			out_c => row_res(y)(O_width-1)
		);
	end generate GEN_LAYER;

	--Assign outputs F[P_width-1 : (P_width-1) + O_width]
	out_F( (P_width-1) + O_width downto O_width ) <= row_res(P_width - 2);

end architecture structure;