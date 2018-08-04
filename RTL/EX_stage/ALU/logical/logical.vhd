library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.OP_CODES.all;
use work.logical_pkg.all;


entity logical is
    port
    (
        op        : in op_t;
        operand_b : in logical_t;
        operand_c : in logical_t;

        result_a  : out logical_t
    );
end entity logical;


architecture functional of logical is
begin

    with op select result_a <=
        operand_b or  operand_c when OR_OP  | ORI_OP,
        operand_b and operand_c when AND_OP | ANDI_OP,
        not operand_c           when NOT_OP,
        ZERO                    when others;

end architecture functional;
