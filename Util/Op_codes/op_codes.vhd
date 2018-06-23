library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;

package op_codes is
    constant ADD_OP     : op_t := "00000";
    constant ADDI_OP    : op_t := "00001";
    constant SUB_OP     : op_t := "00010";
    constant SUBI_OP    : op_t := "00011";
    constant NEG_OP     : op_t := "00100";
    constant NOT_OP     : op_t := "00101";
    constant AND_OP     : op_t := "00110";
    constant ANDI_OP    : op_t := "00111";
    constant OR_OP      : op_t := "01000";
    constant ORI_OP     : op_t := "01001";
    constant SH_OP      : op_t := "01010";
    constant SHI_OP     : op_t := "01011";
    constant SHL_OP     : op_t := "01100";
    constant SHLI_OP    : op_t := "01101";
    constant SHRA_OP    : op_t := "01110";
    constant SHRAI_OP   : op_t := "01111";
    constant SHC_OP     : op_t := "10000";
    constant SHCI_OP    : op_t := "10001";
end package op_codes;
