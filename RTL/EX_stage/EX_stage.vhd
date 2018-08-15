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
        c          : in word_t;
        imm        : in word_t;
        ctrl_alu_c : in std_logic;

        ctrl_wait_mem : in std_logic;

        status        : out status_t;
        pc_out        : out address_t;
        b_out         : out word_t;
        alu_res       : out word_t;
        mdr_out       : out word_t
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

    component zero_comparator is
        port
        (
            a : in word_t;

            z_flag : out std_logic
        );
    end component zero_comparator;

    signal imm_reg, b_reg, c_reg, pc_reg     : word_t;
    signal alu_b, alu_c                      : word_t;

begin

    process (clk) is
        variable reg_en : std_logic;
    begin
        if (rising_edge(clk)) then
            reg_en := not ctrl_wait_mem;
            if (rst = '1') then
                imm_reg <= (others => '0');
                b_reg   <= (others => '0');
                c_reg   <= (others => '0');
                pc_reg  <= (others => '0');
            elsif (reg_en = '1') then
                imm_reg <= imm;
                b_reg   <= b_in;
                c_reg   <= c;
                pc_reg  <= pc_in;
            end if;
        end if;
    end process;

    -- TODO too complex
    --    * records for regs

    ----- ALU INSTANTIATION -------
    alu_inst : component alu
        port map (
            op => ctrl_op,
            b  => alu_b,
            c  => alu_c,
            a  => alu_res
        );
    -------------------------------------

    ---------- STATUS FLAGS -------------
    zc_inst : component zero_comparator
        port map (
            a => c_reg,
            z_flag => status(Z)
        );

    status(S) <= c_reg(c_reg'high);
    -------------------------------------

    ----------- ALU MUTEX -------------------
    alu_b <= b_reg when ctrl_alu_b = '0' else
             pc_in;

    alu_c <= c_reg when ctrl_alu_c = '0' else
             imm_reg;
    -----------------------------------------

    ------------- OUTPUT ----------------
    mdr_out <= c_reg;
    pc_out  <= pc_reg;
    b_out   <= b_reg;
    -------------------------------------

end architecture rtl;
