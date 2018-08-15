library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real."ceil";
use ieee.math_real."log2";

library work;
use work.RISC_const_and_types.all;

-- TODO generic zero comparator

entity zero_comparator is
    port
    (
        a : in word_t;
        
        z_flag : out std_logic
    );
end entity zero_comparator;


architecture behavioral of zero_comparator is
    constant zero_word : word_t := (others => '0');
begin
    z_flag <= '1' when a = zero_word else
              '0';
end architecture behavioral;


architecture rtl of zero_comparator is
    -- TODO define a function log2c()
            -- add package util?
    constant STAGE : natural :=
            natural(ceil(log2(real(WORD_SIZE))));
    type stage_t is array(STAGE downto 0) of word_t;
    signal p : stage_t;
begin

    -- rename input signal
    in_gen: for i in word_t'range generate
        p(STAGE)(i) <= a(i);
    end generate;

    -- reduce_or tree
    stage_gen:
    for s in (STAGE-1) downto 0 generate
        row_gen:
        for r in 0 to (2**s - 1) generate
            p(s)(r) <= p(s+1)(2*r) or p(s+1)(2*r + 1);
        end generate row_gen;
    end generate stage_gen;

    z_flag <= not p(0)(0);

end architecture rtl;
