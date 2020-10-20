library IEEE;
use IEEE.STD_LOGIC_1164.all;

-- Fixed point multiplier   

entity multiplier is
	generic (
		O_width : integer := 8;
		P_width : integer := 8
	);

	port (
		in_O : in std_logic_vector(O_width - 1 downto 0);
		in_P : in std_logic_vector(P_width - 1 downto 0);
		out_F : out std_logic_vector((O_width + P_width) - 1 downto 0)
	);

end multiplier;

architecture Behavioral of multiplier is

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

	subtype result_MSB_range is natural range (P_width - 1) to ((O_width + P_width) - 1);

	signal and_res : std_logic_vector(O_width - 1 downto 0); -- and gate result
	signal prev_res : std_logic_vector(O_width downto 0); -- previous adder result with carry
	signal row_res : std_logic_vector(O_width - 1 downto 0); -- current adder result
	signal carry : std_logic;
begin

	-- O * P and gates
	-- P halfAdders
	-- (O-1 * P-1) - 1 fullAdders

	carry <= '0';

	GEN_ROW :
	for ROW in 0 to P_width - 1 generate
		GEN_COL :
		for COL in 0 to O_width - 1 generate
		begin

			and_res(COL) <= in_P(ROW) and in_O(COL);

			-- First row places and gate results into row_res
			GEN_ROW1 : if (ROW = 0) generate
				row_res(COL) <= and_res(COL);
			end generate;

			-- generate halfAdders
			-- first column or first carry
			GEN_HA : if (((ROW > 0) and (COL = 0)) or ((ROW = 1) and (COL = P_width - 1))) generate

				HA_X : halfAdder port map(
					prev_res(COL),
					and_res(COL),
					row_res(COL),
					carry
				);
			end generate GEN_HA;

			-- generate full Adders
			GEN_FA : if (ROW > 0) generate
				FA_X : fullAdder port map(
					in_A => prev_res(COL),
					in_B => and_res(COL),
					c_in => carry,
					sum => row_res(COL),
					c_out => carry
				);
			end generate GEN_FA;

		end generate GEN_COL;

		--check if at bottom of matrix, then extract the other result bits
		-- ex: P = 4, O = 4, so loop from 3 to 7
		-- out_F(3) <= row_res(0)
		-- out_F(4) <= row_res(1)
		-- out_F(5) <= row_res(2)
		-- out_F(6) <= row_res(3)
		-- out_F(7) <= row_res(4) <= carry

		GEN_F_END : if (ROW = P_width - 1) generate
			GEN_RES_MSBS : for Z in result_MSB_range generate
				out_F(Z) <= row_res(Z - (P_width - 1));
			end generate GEN_RES_MSBS;
		end generate GEN_F_END;

		-- Extract a result bit
		-- Move current results => previous results
		-- Move carry => preivous result
		-- Reset carry
		GEN_F_START : if (ROW < P_width - 1) generate
			out_F(ROW) <= row_res(0);
			GEN_RES_LSB : for K in 0 to O_width - 1 generate
				prev_res(K) <= row_res(K);
			end generate GEN_RES_LSB;
			prev_res(O_width) <= carry;
			carry <= '0';
		end generate;

	end generate GEN_ROW;

end architecture Behavioral;