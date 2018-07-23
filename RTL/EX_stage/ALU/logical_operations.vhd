library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.OP_CODES.all;


subtype logical_t is std_logic_vector(31 downto 0);
constant ZERO_LOGICAL : logical_t := (others => '0');


entity logical_operations is
    port
    (
        op : in op_t;
        operand_b : in logical_t;
        operand_c : in logical_t;
        
        result_a  : out logical_t;
    );
end entity logical_operations;

architecture functional of logical_operations is

begin

    with op_t select
        result_a <= not operand_c           when NOT_OP,
                    operand_b or operand_c  when OR_OP | ORI_OP,
                    operand_b and operand_c when AND_OP | ANDI_OP,
                    ZERO_LOGICAL            when others;

end architecture functional;
