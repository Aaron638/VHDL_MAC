use library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

--Fixed point package
library ieee_proposed;
use ieee_proposed.fixed_pkg.all;

entity multiplier_TB is
    generic (gCLK_HPER : time := 50ns);
end entity multiplier_TB;

architecture behavior of multiplier_TB is

    constant cCLK_PER : time := gCLK_HPER * 2;

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

    component multiplier is
        generic (
            O_width : integer := 8;
            P_width : integer := 8
        );

        port (
            in_O : in std_logic_vector(O_width - 1 downto 0);
            in_P : in std_logic_vector(P_width - 1 downto 0);
            out_F : out std_logic_vector((O_width + P_width) - 1 downto 0)
        );
    end component;

    --unsigned floating point
    signal s_O_UFP : ufixed(O_width downto -1 * O_width);
    signal s_P_UFP : ufixed(P_width downto -1 * P_width);

    signal s_O : std_logic_vector(O_width - 1 downto 0);
    signal s_P : std_logic_vector(P_width - 1 downto 0);
    signal s_F : std_logic_vector((O_width + P_width) - 1 downto 0);
    signal CLK : std_logic;
begin

    DUT : multiplier port map(s_O, s_P, s_F);

    P_CLK : process
    begin
        CLK <= '0';
        wait for gCLK_HPER;
        CLK <= '1';
        wait for gCLK_HPER;
    end process P_CLK;

    -- 0 * 0 = 0

    wait for gCLK_HPER;

    -- 1.0 * 1.0 = 1.0

    wait for gCLK_HPER;

    -- 4.5 * 2.0 = 9.0
    wait for gCLK_HPER;

    -- 8.0 * 8.0 = 64.0
    wait for gCLK_HPER;

    -- 0.3 * 0.3 = 0.9
    wait for gCLK_HPER;

    -- 12.34 * 56.78 about = 700.66?
    wait for gCLK_HPER;

end architecture behavior;