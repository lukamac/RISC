library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity EX_stage is
    port
    (
        clk, rst            : in std_logic;
        op                  : in op_t;
        imm, b, c, pc       : in word_t;

        alu_res, mdr_out    : out word_t
    );
end entity EX_stage;


architecture rtl of EX_stage is

    component alu is
        port
        (
            op      : in op_t;
            b, c    : in word_t;

            a       : out word_t
        );
    end component alu;

    signal op_reg : op_t;
    signal imm_reg, b_reg, c_reg, pc_reg : word_t;
    signal alu_b, alu_c : word_t;

begin

    alu_inst : component alu port map (op => op_reg,
                                       b => alu_b,
                                       c => alu_c,
                                       a => alu_res
                                      );

    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                op_reg      <= (others => '0');
                imm_reg     <= (others => '0');
                b_reg       <= (others => '0');
                c_reg       <= (others => '0');
                pc_reg      <= (others => '0');
            else
                op_reg      <= op;
                imm_reg     <= imm;
                b_reg       <= b;
                c_reg       <= c;
                pc_reg      <= pc;
            end if;
        end if;
    end process;

    alu_b <= b_reg; -- TODO dodati kao i dolje ali za pc_reg

    with op select
        alu_c <= imm_reg when ADDI_OP | ANDI_OP | ORI_OP,
                 c_reg   when others;

    mdr_out <= b_reg;

end architecture rtl;
