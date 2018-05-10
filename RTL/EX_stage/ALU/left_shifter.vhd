library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity left_shifter is
    port
    (
        a   : in word_t;
        amt : in s_amount_t;

        res : out word_t
    );
end entity left_shifter;


architecture rtl of left_shifter is

    signal lv0_out, lv1_out, lv2_out, lv3_out, lv4_out : word_t;

    constant lv0_sin : std_logic := '0';
    constant lv1_sin : std_logic_vector( 1 downto 0) := "00";
    constant lv2_sin : std_logic_vector( 3 downto 0) := "0000";
    constant lv3_sin : std_logic_vector( 7 downto 0) := "00000000";
    constant lv4_sin : std_logic_vector(15 downto 0) := "0000000000000000";

begin

    lv0_out <= a(30 downto 0)       & lv0_sin when amt(0) = '1' else
               a;

    lv1_out <= lv0_out(29 downto 0) & lv1_sin when amt(1) = '1' else
               lv0_out;

    lv2_out <= lv1_out(27 downto 0) & lv2_sin when amt(2) = '1' else
               lv1_out;

    lv3_out <= lv2_out(23 downto 0) & lv3_sin when amt(3) = '1' else
               lv2_out;

    lv4_out <= lv3_out(15 downto 0) & lv4_sin when amt(4) = '1' else
               lv3_out;

    res <= lv4_out;

end architecture rtl;
