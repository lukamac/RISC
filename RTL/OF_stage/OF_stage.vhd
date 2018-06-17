library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;


entity OF_stage is
    port
    (
        -- Immediate value buffering and signed extension
        imm_in      : in immediate_t;
        imm_out     : out word_t;

        -- PC buffering
        pc_in       : in address_t;
        pc_out      : out address_t;

        b, c        : out word_t
    );
end entity OF_stage;


architecture rtl of OF_stage is

    component regset is
        port (
                 clk : in std_logic; -- Clock
                 we  : in std_logic; -- Write enable for input port C
                 a   : in reg_address_t; -- Address for output port A
                 b   : in reg_address_t; -- Address for output port B
                 c   : in reg_address_t; -- Address for input port C
                 doa : out word_t; -- Data output for port A
                 dob : out word_t; -- Data output for port B
                 dic : in word_t -- Data input for port C
             );
    end component regset;

begin

end architecture rtl;
