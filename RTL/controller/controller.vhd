library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity controller is
    port
    (
        rst, clk : in std_logic;
        instr : in word_t;

        ctrl_alu_b, ctrl_alu_c : out std_logic;
        ctrl_alu_op : out op_t
    );
end entity controller;


architecture RTL of controller is

    type instr_array is array (natural range <>) of word_t;
    signal past_instr_reg, past_instr_next : instr_array(2 downto 0);

    constant EX_stage : natural := 0;
    constant ME_stage : natural := 1;
    constant WE_stage : natural := 2;

begin

    process (clk) is
        variable init_word : word_t := (others => '0');
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                past_instr_reg <= (others => init_word);
            else
                past_instr_reg <= past_instr_next;
            end if;
        end if;
    end process;

    past_instr_next(2 downto 1) <= past_instr_reg(1 downto 0);
    past_instr_next(0) <= instr;

    ctrl_alu: process (past_instr_reg(EX_stage)) is
        variable EX_instr : word_t := past_instr_reg(EX_stage);
        variable op : op_t := EX_instr(31 downto 27);
    begin
        ctrl_alu_op <= op;

        ctrl_alu_b <= '0';
        ctrl_alu_c <= '0';
        case op is
            when ADDI_OP | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHI_OP  | SHLI_OP | SHRAI_OP | SHCI_OP =>
                ctrl_alu_c <= '1';
            when others =>
                null;
        end case;
    end process ctrl_alu;

end architecture RTL;
