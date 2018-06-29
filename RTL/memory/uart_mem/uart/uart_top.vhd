library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_top is
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
end uart_top;

architecture rtl of uart_top is
	component uart_rx is
		generic(
			W 	: natural := 8
		);
		port(
			rx      : in std_logic;
			tick 	: in std_logic;
			clk 	: in std_logic;
			rst 	: in std_logic;
			d_out 	: out std_logic_vector(W-1 downto 0);
			rx_done	: out std_logic
		);
	end component uart_rx;
	
	component uart_tx is
		generic(
			W : natural := 8
		);
		port(
			d_in : in std_logic_vector (W - 1 downto 0);
			tx_start : in std_logic;
			tx_done : out std_logic;
			tx : out std_logic;
			tick : in std_logic;
			clk : in std_logic;
			rst : in std_logic
		);
	end component uart_tx;
	
	component baud_rate_gen is
		generic(
			BAUD_RATE : natural := 9600;
			CLK_FREQ : natural := 27000000
		);
		port(
			clk : in std_logic;
			rst : in std_logic;
			tick : out std_logic
		);
	end component baud_rate_gen;
	
	signal tick : std_logic;
	
begin

	uart_rx_inst: uart_rx generic map(W) port map (rx => rx,
																  tick => tick,
																  clk => clk,
																  rst => rst,
																  d_out => r_data,
																  rx_done => r_done);
	
	uart_tx_inst: uart_tx generic map(W) port map (d_in => w_data,
																  tx_start => w_start,
																  tx_done => w_done,
																  tx => tx,
																  tick => tick,
																  clk => clk,
																  rst => rst);
																  
	baud_rate_gen_inst: baud_rate_gen generic map(BAUD_RATE, CLK_FREQ)
												 port map (clk => clk,
																rst => rst,
																tick => tick);
																
end rtl;

