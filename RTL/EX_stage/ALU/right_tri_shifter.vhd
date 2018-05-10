library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.RISC_const_and_types.all;
use work.OP_CODES.all;


entity right_tri_shifter is
    port
    (
        op      : in op_t;
        a       : in word_t;
        amt     : in s_amount_t;
        res     : out word_t
    );
end entity right_tri_shifter;


architecture rtl of right_tri_shifter is

    signal lv0_out, lv1_out, lv2_out, lv3_out, lv4_out : word_t;
    signal lv0_sin: std_logic;
    signal lv1_sin: std_logic_vector( 1 downto 0);
    signal lv2_sin: std_logic_vector( 3 downto 0);
    signal lv3_sin: std_logic_vector( 7 downto 0);
    signal lv4_sin: std_logic_vector(15 downto 0);

begin

    -- Level 0
    with op select
        lv0_sin <= a(31) when SHRA_OP,
                   a(0)  when SHC_OP,
                   '0'   when others;

    lv0_out <= lv0_sin & a(31 downto 1) when amt(0) = '1' else
               a;


    -- Level 1
    with op select
        lv1_sin <= (others => lv0_out(31))  when SHRA_OP,
                   lv0_out(1  downto  0)    when SHC_OP,
                   "00"                     when others;

    lv1_out <= lv1_sin & lv0_out(31 downto 2) when amt(1) = '1' else
               lv0_out;


    -- Level 2
    with op select
        lv2_sin <= (others => lv1_out(31))  when SHRA_OP,
                   lv1_out(3 downto 0)      when SHC_OP,
                   "0000"                   when others;

    lv2_out <= lv2_sin & lv1_out(31 downto 4) when amt(2) = '1' else
               lv1_out;


    -- Level 3
    with op select
        lv3_sin <= (others => lv2_out(31))  when SHRA_OP,
                   lv2_out(7  downto  0)    when SHC_OP,
                   "00000000"               when others;

    lv3_out <= lv3_sin & lv2_out(31 downto 8) when amt(3) = '1' else
               lv2_out;


    -- Level 4
    with op select
        lv4_sin <= (others => lv3_out(31))  when SHRA_OP,
                   lv3_out(15 downto  0)    when SHC_OP,
                   "0000000000000000"       when others;

    lv4_out <= lv4_sin & lv3_out(31 downto 16) when amt(4) = '1' else
               lv3_out;

    res <= lv4_out;

end architecture rtl;
