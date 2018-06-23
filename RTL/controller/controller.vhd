library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity controller is
    port
    (
        rst, clk : in std_logic;
        instr    : in word_t;

        -- EX stage control signals
        alu_b, alu_c : out std_logic;
        alu_op       : out op_t;

        -- MEM stage control signals
        wait_data, wait_instr : in std_logic;
        mem_en, rw            : out std_logic;

        -- WB stage control signals
        wb_mux : out std_logic
    );
end entity controller;


architecture RTL of controller is

    type instr_array is array (natural range <>) of word_t;
    signal past_instr_reg, past_instr_next : instr_array(3 downto 0);

    constant OF_stage : natural := 0;
    constant EX_stage : natural := 1;
    constant ME_stage : natural := 2;
    constant WE_stage : natural := 3;

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

    past_instr_next(3 downto 1) <= past_instr_reg(2 downto 0);
    past_instr_next(0) <= instr;

    EX: process (past_instr_reg(EX_stage)) is
        variable EX_instr : word_t := past_instr_reg(EX_stage);
        variable op : op_t := EX_instr(31 downto 27);
    begin
        alu_op <= op;

        alu_b <= '0';
        alu_c <= '0';
        case op is
            when ADDI_OP | SUBI_OP | ORI_OP   | ANDI_OP |
                 SHRI_OP  | SHLI_OP | SHRAI_OP | SHCI_OP =>
                alu_c <= '1';
            when others =>
                null;
        end case;
    end process EX;


    MEM: process (past_instr_reg(ME_stage)) is
        variable MEM_instr : word_t := past_instr_reg(ME_stage);
        variable op : op_t := MEM_instr(31 downto 27);
    begin
        mem_en <= '0';
        rw <= '0';
        case op is
            --TODO When we add memory commands
            when others =>
                null;
        end case;
    end process MEM;


    WB: process (past_instr_reg(WE_stage)) is
        variable WB_instr : word_t := past_instr_reg(WE_stage);
        variable op : op_t := WB_instr(31 downto 27);
    begin
        wb_mux <= '0';
        case op is
            --TODO when we add memory commands
            when others =>
                null;
        end case;
    end process WB;

end architecture RTL;
