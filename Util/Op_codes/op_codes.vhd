library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;

package op_codes is
    constant ADD_OP     : op_t := "00000";
    constant SUB_OP     : op_t := "00001";
    constant ADDI_OP    : op_t := "00010";
    constant NEG_OP     : op_t := "00011";
    constant NOT_OP     : op_t := "00100";
    constant AND_OP     : op_t := "00101";
    constant ANDI_OP    : op_t := "00110";
    constant OR_OP      : op_t := "00111";
    constant ORI_OP     : op_t := "11000";
    constant SH_OP      : op_t := "01000";
    constant SHL_OP     : op_t := "01001";
    constant SHRA_OP    : op_t := "01010";
    constant SHC_OP     : op_t := "01011";
end package op_codes;
