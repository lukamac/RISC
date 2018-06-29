library ieee;
use ieee.std_logic_1164.all;

library work;
use work.RISC_const_and_types.all;

entity uart_mem is
	generic(CLK_FREQ : natural := 125000000);
    port
    (
    	clk   		: in std_logic;
        rst 		: in std_logic;

        addr 		: in address_t;
        
        rd			: in std_logic;
        wr			: in std_logic;
        wait_btn	: in std_logic;

        data_wait 	: out std_logic;
        data_in 	: in word_t;
        data_out    : out word_t;
        rx			: in std_logic;
        tx			: out std_logic
    );
end entity uart_mem;

architecture rtl of uart_mem is

	component uart_top is
		generic(
			W : natural := 8;
			BAUD_RATE : natural := 9600;
			CLK_FREQ : natural := 27000000
		);
		port(
			clk : in std_logic;
			rst : in std_logic;
			
			rx : in std_logic;
			tx : out std_logic;
			
			r_data : out std_logic_vector(W - 1 downto 0);
			r_done : out std_logic;
			
			w_data : in std_logic_vector(W - 1 downto 0);
			w_start : in std_logic;
			w_done : out std_logic
		);
	end component uart_top;

	signal tx_data	: std_logic_vector(7 downto 0);
	signal rx_data	: std_logic_vector(7 downto 0);
	signal r_done, w_done : std_logic;
	signal w_start	: std_logic;
	
begin

	uart: uart_top
		generic map(
			CLK_FREQ => CLK_FREQ
		)
		port map (
			clk => clk,
			rst => rst,
			rx => rx,
			tx => tx,
			r_data => rx_data,
			r_done => r_done,
			w_data => tx_data,
			w_start => w_start,
			w_done => w_done
		);
	
	w_start <= wr and (not wait_btn);
	
	tx_data <= data_in(7 downto 0);
	
	data_out <= X"000000" & rx_data when rd = '1' else
				X"00000000";
	data_wait <= '0';
	
	
end architecture rtl;