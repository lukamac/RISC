library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.OP_CODES.all;
use work.arithmetic_pkg.all;


entity arithmetic is
    port
    (
        op        : in op_t;
        operand_b : in arithmetic_t;
        operand_c : in arithmetic_t;

        result_a  : out arithmetic_t
    );
end entity arithmetic;

architecture functional of arithmetic is
begin

    -- TODO
    -- Try to optimize with using only one adder.
    -- See performance vs. size after synthesis.

    with op select result_a <=
        operand_b + operand_c when ADD_OP | ADDI_OP |
                                   LA_OP  | LD_OP   |
                                   ST_OP,

        operand_b - operand_c when SUB_OP | SUBI_OP,

        -operand_c            when NEG_OP,

        ZERO                  when others;

end architecture functional;
