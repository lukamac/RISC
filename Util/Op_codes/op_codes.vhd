library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;

package op_codes is
    constant NOP_OP     : op_t := "00000";
    constant ADD_OP     : op_t := "00001";
    constant ADDI_OP    : op_t := "00010";
    constant SUB_OP     : op_t := "00011";
    constant SUBI_OP    : op_t := "00100";
    constant NEG_OP     : op_t := "00101";
    constant NOT_OP     : op_t := "00110";
    constant AND_OP     : op_t := "00111";
    constant ANDI_OP    : op_t := "01000";
    constant OR_OP      : op_t := "01001";
    constant ORI_OP     : op_t := "01010";
    constant SHR_OP     : op_t := "01011";
    constant SHRI_OP    : op_t := "01100";
    constant SHL_OP     : op_t := "01101";
    constant SHLI_OP    : op_t := "01110";
    constant SHRA_OP    : op_t := "01111";
    constant SHRAI_OP   : op_t := "10000";
    constant SHC_OP     : op_t := "10001";
    constant SHCI_OP    : op_t := "10010";
    constant BR_OP      : op_t := "10011";
    constant BRL_OP     : op_t := "10100";
    constant LD_OP      : op_t := "10101";
    constant LA_OP      : op_t := "10110";
    constant ST_OP      : op_t := "10111";
    constant LDI_OP     : op_t := "11000";
    constant LAI_OP     : op_t := "11001";
    constant STI_OP     : op_t := "11010";
    constant LDR_OP     : op_t := "11011";
    constant STR_OP     : op_t := "11100";
end package op_codes;
