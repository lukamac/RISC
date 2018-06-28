library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity simple_instr_mem_tb is
end entity simple_instr_mem_tb;

architecture beh of simple_instr_mem_tb is

    component simple_instr_mem is
        port
        (
            rst, clk   : in std_logic;

            btn        : in std_logic;

            instr_addr : in address_t;

            instr_wait : out std_logic;
            instr_data : out word_t
        );
    end component simple_instr_mem;

    signal rst, instr_wait : std_logic;
    signal btn, clk : std_logic := '0';
    signal instr_addr : address_t;
    signal instr_data : word_t;

    constant t_clk : time := 20 ns;
    constant t_rst : time := 100 ns;
    constant t_btn : time := 400 ns;

begin

    uut: component simple_instr_mem port map (rst => rst,
                                              clk => clk,
                                              btn => btn,
                                              instr_addr => instr_addr,
                                              instr_wait => instr_wait,
                                              instr_data => instr_data
                                             );

    clk <= not clk after t_clk/2;
    rst <= '1', '0' after t_rst;
    btn <= not btn after t_btn/2;

    stimulus: process is
        variable PC : integer := 0;
    begin

        wait until rst = '0';
        instr_addr <= std_logic_vector(to_unsigned(PC, instr_addr'length));
        PC := PC + 1;
        
        wait until instr_wait = '0';
        wait until instr_wait = '1';

        instr_addr <= std_logic_vector(to_unsigned(PC, instr_addr'length));
        PC := PC + 1;
        
        wait until instr_wait = '0';
        wait until instr_wait = '1';

        instr_addr <= std_logic_vector(to_unsigned(PC, instr_addr'length));
        PC := PC + 1;
        
        wait until instr_wait = '0';
        wait until instr_wait = '1';

        instr_addr <= std_logic_vector(to_unsigned(PC, instr_addr'length));
        PC := PC + 1;
        
        wait until instr_wait = '0';
        wait until instr_wait = '1';

        instr_addr <= std_logic_vector(to_unsigned(PC, instr_addr'length));
        PC := PC + 1;
        
        wait until instr_wait = '0';
        wait until instr_wait = '1';

        instr_addr <= std_logic_vector(to_unsigned(PC, instr_addr'length));
        PC := PC + 1;
        
        wait until instr_wait = '0';
        wait until instr_wait = '1';

        instr_addr <= std_logic_vector(to_unsigned(PC, instr_addr'length));
        PC := PC + 1;
        
        wait until instr_wait = '0';
        wait until instr_wait = '1';

        ---------- END STIMULUS ------------
        wait;
    end process stimulus;

end architecture beh;
