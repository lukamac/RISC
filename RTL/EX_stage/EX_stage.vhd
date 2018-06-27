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
        alu_res, mdr_out : out word_t;
        ctrl_wait_mem    : in std_logic
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

    signal imm_reg, b_reg, c_reg, pc_reg : word_t;
    signal imm_next, b_next, c_next, pc_next : word_t;
    signal alu_b, alu_c : word_t;
    signal a : word_t;
    signal s_flag, z_flag : std_logic;

begin

    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                imm_reg     <= (others => '0');
                b_reg       <= (others => '0');
                c_reg       <= (others => '0');
                pc_reg      <= (others => '0');
            else
                imm_reg     <= imm_next;
                b_reg       <= b_next;
                c_reg       <= c_next;
                pc_reg      <= pc_next;
            end if;
        end if;
    end process;
    imm_next <= imm when ctrl_wait_mem = '0' else
                imm_reg;
    b_next <= b_in when ctrl_wait_mem = '0' else
              b_reg;
    c_next <= c when ctrl_wait_mem = '0' else
              c_reg;
    pc_next <= pc_in when ctrl_wait_mem = '0' else
               pc_reg;
    

    alu_inst : component alu port map (op => ctrl_op,
                                       b  => alu_b,
                                       c  => alu_c,
                                       a  => a
                                      );

    set_flags: process(a) is
        constant zero_word : word_t := (others => '0');
    begin
        if (a = zero_word) then
            z_flag <= '1';
        else
            z_flag <= '0';
        end if;
        s_flag <= a(a'high);
    end process set_flags;

    status(S) <= s_flag;
    status(Z) <= z_flag;

    alu_b <= b_reg when ctrl_alu_b = '0' else
             pc_in;

    alu_c <= c_reg when ctrl_alu_c = '0' else
             imm_reg;

    alu_res <= a;
    mdr_out <= c_reg;
    pc_out  <= pc_reg;
    b_out   <= b_reg;

end architecture rtl;
