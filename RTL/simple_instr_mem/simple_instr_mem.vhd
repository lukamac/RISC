library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity simple_instr_mem is
    port
    (
        rst, clk   : in std_logic;

        btn        : in std_logic;

        instr_addr : in address_t;

        instr_wait : out std_logic;
        instr_data : out word_t
    );
end entity simple_instr_mem;

architecture behavioural of simple_instr_mem is

    type ROM is array(0 to 15) of word_t;
    signal bootloader : ROM :=
        (
            LAI_OP  & "00000" & "00000" & "00000000000001010",
            LAI_OP  & "00001" & "00000" & "00000000000000101",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            STI_OP  & "00000" & "00000" & "00000000000000000",
            STI_OP  & "00001" & "00000" & "00000000000000000",
            ADDI_OP & "00000" & "00000" & "00000000000000000",
            ADDI_OP & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000",
            NOP_OP  & "00000" & "00000" & "00000000000000000"
        );

    signal db0_reg, db1_reg, db2_reg : std_logic;
    signal db0_next, db1_next, db2_next : std_logic;

    signal debounce_res : std_logic;

    signal osp_btn_reg, osp_btn_next : std_logic;

begin

    debounce: process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                db0_reg <= '0';
                db1_reg <= '0';
                db2_reg <= '0';
            else
                db0_reg <= db0_next;
                db1_reg <= db1_next;
                db2_reg <= db2_next;
            end if;
        end if;
    end process debounce;

    db0_next <= btn;
    db1_next <= db0_reg;
    db2_next <= db1_reg;

    debounce_res <= db0_reg and db1_reg and db2_reg;

    one_shot_pulse: process(clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then 
                osp_btn_reg <= '1';
            else
                osp_btn_reg <= osp_btn_next;
            end if;
        end if;
    end process one_shot_pulse;

    osp_btn_next <= debounce_res;

    instr_wait <= osp_btn_reg or (not debounce_res);

    -------------- READ MEM --------------
    process (clk) is
    begin
        if (rising_edge(clk)) then
            instr_data <= bootloader(to_integer(unsigned(instr_addr)));
        end if;
    end process;

end architecture behavioural;
