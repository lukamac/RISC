library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.OP_CODES.all;

----------------------------------------------
--                                          --
--                  ALU                     --
--                                          --
-- Performs operation, specified by op, on  --
-- operands b and c and gives produces a    --
-- result res.                              --
----------------------------------------------

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

    choose_result: process (op, b, c, adder_res, neg_c, not_c, b_and_c, b_or_c, rts_res, ls_res) is
    begin
        case (op) is
            when ADD_OP | ADDI_OP |
                 SUB_OP | SUBI_OP |
                 LA_OP  | LD_OP   | ST_OP =>
                a <= std_logic_vector(adder_res);
            when NEG_OP =>
                a <= neg_c;
            when NOT_OP =>
                a <= not_c;
            when AND_OP | ANDI_OP =>
                a <= b_and_c;
            when OR_OP | ORI_OP =>
                a <= b_or_c;
            when SHR_OP  | SHRA_OP  | SHC_OP |
                 SHRI_OP | SHRAI_OP | SHCI_OP =>
                a <= rts_res;
            when SHL_OP | SHLI_OP =>
                a <= ls_res;
            when others =>
                a <= c;
        end case;
    end process choose_result;


    -- Shifters
    s_amt <= c(s_amount_t'range);

    rts : component right_tri_shifter
        port map(
            op  => op,
            a   => b,
            amt => s_amt,
            res => rts_res);

    ls  : component left_shifter
        port map(
            a   => b,
            amt => s_amt,
            res => ls_res);

    -- TODO
    -- Implement structural abstraction for everything.
    --   Consistency in abstraction!

    -- Logical operations
    not_c <= not c;
    neg_c <= std_logic_vector(unsigned(not_c) + 1);

    b_or_c  <= b or  c;
    b_and_c <= b and c;


    -- Adder
    adder_b <= signed(b);
    adder_c <= signed(neg_c) when op = SUB_OP or op = SUBI_OP else
               signed(c);

    adder_res <= adder_b + adder_c;

end architecture rtl;
