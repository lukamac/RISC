library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.RISC_const_and_types.all;
use work.OP_CODES.all;


entity alu is
    port
    (
        op      : in op_t;
        b, c    : in word_t;

        a       : out word_t
    );
end entity alu;

architecture rtl of alu is

    component right_tri_shifter is
        port
        (
            op      : in op_t;
            a       : in word_t;
            amt     : in s_amount_t;

            res     : out word_t
        );
    end component right_tri_shifter;

    component left_shifter is
        port
        (
            a   : in word_t;
            amt : in s_amount_t;
            
            res : out word_t
        );
    end component left_shifter;

    signal adder_res, adder_b, adder_c : signed(word_t'range);
    signal b_or_c, b_and_c  : word_t;
    signal s_res : word_t;
    signal not_c : word_t;
    signal neg_c : word_t;
    signal rts_res, ls_res : word_t;
    signal s_amt : s_amount_t;

begin

    choose_result: process (op, b, adder_res, neg_c, not_c, b_and_c, b_or_c, rts_res, ls_res) is
    begin
        case (op) is
            when NEG_OP =>
                a <= neg_c;
            when NOT_OP =>
                a <= not_c;
            when AND_OP =>
                a <= b_and_c;
            when ANDI_OP =>
                a <= b_and_c;
            when OR_OP | ORI_OP =>
                a <= b_or_c;
            when SH_OP | SHRA_OP | SHC_OP =>
                a <= rts_res;
            when SHL_OP =>
                a <= ls_res;
            when others =>
                a <= std_logic_vector(adder_res);
        end case;
    end process choose_result;


    -- Shifters
    s_amt <= c(s_amount_t'range);

    rts : component right_tri_shifter port map(op => op,
                                               a => b,
                                               amt => s_amt,
                                               res => rts_res
                                              );

    ls  : component left_shifter      port map(a => b,
                                               amt => s_amt,
                                               res => ls_res
                                              );

    -- Logical operations
    not_c <= not c;
    neg_c <= std_logic_vector(unsigned(not_c) + 1);

    b_or_c  <= b or  c;
    b_and_c <= b and c;


    -- Adder
    adder_b <= signed(b);
    adder_c <= signed(neg_c) when op = SUB_OP else
               signed(c);

    adder_res <= adder_b + adder_c;

end architecture rtl;
