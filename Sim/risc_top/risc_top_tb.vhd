library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.RISC_const_and_types.all;
use work.op_codes.all;


entity risc_top_tb is
end entity risc_top_tb;

architecture behavioural of risc_top_tb is

    component risc_top is
        port(
            clk         : in std_logic;
            rst         : in std_logic;

            -- instruction memory interface
            instr_addr  : out address_t;
            instr_data  : in word_t;
            wait_instr  : in std_logic;

            -- data memory interface
            data_addr   : out address_t;
            data_out    : out word_t;
            data_in     : in word_t;
            data_rd     : out std_logic;
            data_wr     : out std_logic;
            wait_data   : in std_logic
        );
    end component risc_top;

    signal clk, rst : std_logic := '0';

    -- instruction memroy interface
    signal instr_addr : address_t;
    signal instr_data : word_t;
    signal wait_instr : std_logic;

    -- data memory interface
    signal data_addr : address_t;
    signal data_out  : word_t;
    signal data_in   : word_t;
    signal data_rd   : std_logic;
    signal data_wr   : std_logic;
    signal wait_data : std_logic;

    constant t_clk : time := 20 ns;

begin

    uut: component risc_top port map (clk => clk,
                                      rst => rst,
                                      instr_addr => instr_addr,
                                      instr_data => instr_data,
                                      wait_instr => wait_instr,
                                      data_addr => data_addr,
                                      data_out => data_out,
                                      data_in => data_in,
                                      data_rd => data_rd,
                                      data_wr => data_wr,
                                      wait_data => wait_data
                                     );

    clk <= not clk after t_clk/2;

    rst <= '1', '0' after 100 ns;

    stimulus: process is
        variable op : op_t;
        variable addr_a, addr_b, addr_c : reg_address_t;
        variable imm12 : std_logic_vector(11 downto 0);
        variable imm17 : immediate_t;
        variable PC : integer;

        constant NOP_instr : word_t := (others => '0');
    begin

        wait_instr <= '0';
        wait_data  <= '0';
        wait until rst = '1';
        PC := 0;
        assert instr_addr = std_logic_vector(to_unsigned(PC, instr_addr'length))
            report "instr_addr not zero after rst";
        wait until rst = '0';
        op := ADDI_OP;
        addr_a := "00000";
        addr_b := "00001";
        imm17  := "00000000000000100";
        instr_data <= op & addr_a & addr_b & imm17;

        wait until clk = '1';
        instr_data <= NOP_instr;
        wait until clk = '0';
        PC := PC + 4;
        assert instr_addr = std_logic_vector(to_unsigned(PC, instr_addr'length))
            report "PC is invalid";
        wait until clk = '1';
        instr_data <= NOP_instr;
        wait until clk = '0';
        PC := PC + 4;
        assert instr_addr = std_logic_vector(to_unsigned(PC, instr_addr'length))
            report "PC is invalid";
        wait until clk = '1';
        instr_data <= NOP_instr;
        wait until clk = '0';
        PC := PC + 4;
        assert instr_addr = std_logic_vector(to_unsigned(PC, instr_addr'length))
            report "PC is invalid";
        assert data_addr = std_logic_vector(to_unsigned(4, data_addr'length))
            report "ALU_res wrong";

        wait until clk = '1';

        --------- PIPELINE TEST -----------
        -- in reg(0) we have 4 and rest is 0

        wait until clk = '0';

        op := SUBI_OP;
        addr_a := "00001";
        addr_b := "00000"; -- 4
        imm17  := std_logic_vector(to_unsigned(2, imm17'length));

        instr_data <= op & addr_a & addr_b & imm17;

        wait until clk = '1';

        wait until clk = '0';

        op := ORI_OP;
        addr_a := "00010";
        addr_b := "00000"; -- 4
        imm17  := "00000000000000011";

        instr_data <= op & addr_a & addr_b & imm17;

        wait until clk = '1';

        wait until clk = '0';

        op := SHLI_OP;
        addr_a := "00011";
        addr_b := "00000"; -- 4
        imm17  := std_logic_vector(to_unsigned(3, imm17'length));

        instr_data <= op & addr_a & addr_b & imm17;

        wait until clk = '1';

        wait until clk = '0';

        op := SHCI_OP;
        addr_a := "00100";
        addr_b := "00000";
        imm17  := std_logic_vector(to_unsigned(3, imm17'length));

        instr_data <= op & addr_a & addr_b & imm17;

        assert data_addr = std_logic_vector(to_unsigned(2, data_addr'length))
        report "Wrong result from SUBI_OP.";

        wait until clk = '1';

        wait until clk = '0';

        instr_data <= NOP_instr;

        assert data_addr = X"00000007"
        report "Wrong result from ORI_OP.";

        wait until clk = '1';

        wait until clk = '0';

        instr_data <= NOP_instr;

        assert data_addr = X"00000020"
        report "Wrong result from SHLI_OP.";

        wait until clk = '1';

        wait until clk = '0';

        instr_data <= NOP_instr;

        assert data_addr = X"80000000"
        report "Wrong result from SHCI_OP.";

        --------- END STIMULUS ------------
        wait;
    end process stimulus;

end architecture behavioural;
