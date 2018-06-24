library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity EX_stage is
    port
    (
        clk, rst    : in std_logic;

        -- Operation code
        ctrl_op     : in op_t;

        -- ALU input B signals
        b_in        : in word_t;
        pc_in       : in address_t;
        ctrl_alu_b  : in std_logic;

        -- ALU input C signals
        c, imm      : in word_t;
        ctrl_alu_c  : in std_logic;

        status           : out status_t;
        pc_out           : out address_t;
        b_out            : out word_t;
        alu_res, mdr_out : out word_t
    );
end entity EX_stage;


architecture rtl of EX_stage is

    component alu is
        port
        (
            op   : in op_t;
            b, c : in word_t;

            a    : out word_t
        );
    end component alu;

    signal ctrl_op_reg : op_t;
    signal imm_reg, b_reg, c_reg, pc_reg : word_t;
    signal alu_b, alu_c : word_t;
    signal a : word_t;

begin

    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                ctrl_op_reg <= (others => '0');
                imm_reg     <= (others => '0');
                b_reg       <= (others => '0');
                c_reg       <= (others => '0');
                pc_reg      <= (others => '0');
            else
                ctrl_op_reg <= ctrl_op;
                imm_reg     <= imm;
                b_reg       <= b_in;
                c_reg       <= c;
                pc_reg      <= pc_in;
            end if;
        end if;
    end process;

    alu_inst : component alu port map (op => ctrl_op_reg,
                                       b  => alu_b,
                                       c  => alu_c,
                                       a  => a
                                      );

    set_status: process(a) is
        constant zero_word : word_t := (others => '0');
    begin
        if (a = zero_word) then
            status(Z) <= '1';
        else
            status(Z) <= '0';
        end if;
        status(S) <= a(a'high);
    end process set_status;

    alu_b <= b_reg when ctrl_alu_b = '0' else
             pc_in;

    alu_c <= c_reg when ctrl_alu_c = '0' else
             imm_reg;

    alu_res <= a;
    mdr_out <= b_reg;
    pc_out  <= pc_reg;
    b_out   <= b_reg;

end architecture rtl;
