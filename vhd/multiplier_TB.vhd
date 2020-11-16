library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier_TB is
    generic (
        O_width : integer := 8;
        P_width : integer := 8;
        gCLK_HPER : time := 50ns
    );
end entity multiplier_TB;

architecture behavior of multiplier_TB is

    constant cCLK_PER : time := gCLK_HPER * 2;

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

    signal s_O : std_logic_vector(O_width - 1 downto 0);
    signal s_P : std_logic_vector(P_width - 1 downto 0);
    signal s_F : std_logic_vector((O_width + P_width) - 1 downto 0);
    signal CLK : std_logic;
begin

    DUT : multiplier
    generic map(
        O_width => O_width,
        P_width => P_width
    )
    port map(s_O, s_P, s_F);

    P_CLK : process
    begin
        CLK <= '0';
        wait for gCLK_HPER;
        CLK <= '1';
        wait for gCLK_HPER;
    end process P_CLK;

    --Testbench process
    mult_TB : process
    begin
        -- 0000_0000 * 0000_0000 = 0000_0000_0000_0000
        s_O <= b"0000_0000";
        s_P <= b"0000_0000";
        wait for gCLK_HPER;

        -- 2 * 2 = 4
        s_O <= b"0001_0000";
        s_P <= b"0001_0000";
        wait for gCLK_HPER;

        -- 0.5 * 0.5 = 0.25 = "0000_0000_0100_0000"
        s_O <= b"0000_1000";
        s_P <= b"0000_1000";
        wait for gCLK_HPER;

        -- 4.5 * 2.0 = 9.0 = "1001_1000"
        s_O <= b"0100_1000";
        s_P <= b"0010_0000";
        wait for gCLK_HPER;

        -- 8.0 * 8.0 = 64.0
        --wait for gCLK_HPER;

        -- 0.3 * 0.3 = 0.9
        --wait for gCLK_HPER;

        -- 12.34 * 56.78 about = 700.66?
        --wait for gCLK_HPER;
    end process;

end architecture behavior;