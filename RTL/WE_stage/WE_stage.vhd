library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;


entity WE_stage is
    port
    (
        rst, clk   : in std_logic;

        ctrl_we    : in std_logic;

        alu_res_in : in word_t;
        mdr_in     : in word_t;

        data_out   : out word_t
    );
end entity WE_stage;


architecture RTL of WE_stage is
    signal mdr_in_reg  , mdr_in_next  : word_t;
    signal alu_res_reg , alu_res_next : word_t;
begin
    process (clk) is
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                mdr_in_reg  <= (others => '0');
                alu_res_reg <= (others => '0');
            else
                mdr_in_reg  <= mdr_in_next;
                alu_res_reg <= alu_res_next;
            end if;
        end if;
    end process;

    mdr_in_next  <= mdr_in;
    alu_res_next <= alu_res_in;

    data_out <= alu_res_reg when ctrl_we = '0' else
                mdr_in_reg;
end architecture RTL;
