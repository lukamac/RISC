library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.OP_CODES.all;
use work.shifter_pkg.all;
use work.arithmetic_pkg.all;
use work.logical_pkg.all;

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

    signal s_res   : word_t;
    signal rts_res : word_t;
    signal ls_res  : word_t;
    signal aop_res : arithmetic_t;
    signal lop_res : logical_t;
    signal s_amt   : s_amount_t;

begin

    with op select a <=
        std_logic_vector(aop_res) when ADD_OP   | ADDI_OP |
                                       SUB_OP   | SUBI_OP |
                                       LA_OP    | LD_OP   |
                                       ST_OP    | NEG_OP,

        std_logic_vector(lop_res) when NOT_OP   |
                                       AND_OP   | ANDI_OP |
                                       OR_OP    | ORI_OP,

        rts_res                   when SHR_OP   | SHRA_OP |
                                       SHC_OP   | SHRI_OP |
                                       SHRAI_OP | SHCI_OP,

        ls_res                    when SHL_OP   | SHLI_OP,

        c                         when others;


    s_amt <= c(s_amount_t'range);

    -- Consistency in abstraction!
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

    aop : component arithmetic
        port map(
            op        => op,
            operand_b => arithmetic_t(b),
            operand_c => arithmetic_t(c),
            result_a  => aop_res);

    lop : component logical
        port map(
            op        => op,
            operand_b => logical_t(b),
            operand_c => logical_t(c),
            result_a  => lop_res);

end architecture rtl;
