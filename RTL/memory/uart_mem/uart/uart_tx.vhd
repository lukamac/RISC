library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.MATH_REAL."CEIL";
use IEEE.MATH_REAL."LOG2";
--use IEEE.NUMERIC_STD.to_integer;

entity uart_tx is
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
end uart_tx;

architecture rtl of uart_tx is
	
	type state_type is (IDLE, START, WRITE_TX, STOP);
	
	signal state_reg, state_next 		: state_type := IDLE;
	signal tc_reg, tc_next 				: std_logic_vector(3 downto 0) := (others => '0');
	signal bc_reg, bc_next 				: std_logic_vector(integer(ceil(log2(real(W)))) - 1 downto 0) := (others => '0');
	signal data_buf					 	: std_logic_vector(W - 1 downto 0) := (others => '0');

begin
	
	-- Registering d_in on START state
	data_buffer: process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				data_buf <= (others => '0');
			elsif(state_next = START and state_reg = IDLE) then 
				data_buf <= d_in;
			end if;
		end if;
	end process data_buffer;
	
	-- Memory logic
	synchronous: process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				state_reg <= IDLE;
				tc_reg <= (others => '0');
				bc_reg <= (others => '0');
			else
				state_reg <= state_next;
				tc_reg <= tc_next;
				bc_reg <= bc_next;
			end if;
		end if;
	end process synchronous;
	
	-- Next state + output
	combinatorial: process(state_reg, tick, data_buf, tx_start, tc_reg, bc_reg) is
	begin
		state_next <= state_reg;
		tc_next <= tc_reg;
		bc_next <= bc_reg;
		tx <= '1';
		tx_done <= '0';
		case state_reg is
			when IDLE =>
				if(tx_start = '1') then
					state_next <= START;
				else
					state_next <= IDLE;
				end if;
			when START =>
				tx <= '0';
				if(tick = '1') then
					if(tc_reg = 15) then
						tc_next <= (others => '0');
						state_next <= WRITE_TX;
					else
						tc_next <= tc_reg + 1;
						state_next <= START;
					end if;
				end if;
			when WRITE_TX =>
				tx <= data_buf(conv_integer(bc_reg));
				if(tick = '1') then
					if(tc_reg = 15) then
						tc_next <= (others => '0');
						if (bc_reg = W - 1) then
							bc_next <= (others => '0');
							state_next <= STOP;
						else
							bc_next <= bc_reg + 1;
							state_next <= WRITE_TX;
						end if;
					else
						tc_next <= tc_reg + 1;
						state_next <= WRITE_TX;
					end if;
				else
					state_next <= WRITE_TX;
				end if;
			when STOP =>
				tx <= '1';
				tx_done <= '1';
				if(tick = '1') then
                    if(tc_reg = 15) then
                        state_next <= IDLE;
                        tc_next <= (others => '0');
                    else
                        state_next <= STOP;
                        tc_next <= tc_reg + 1;
                    end if;
                else
                    state_next <= STOP;
                end if;
		end case;
	end process combinatorial;
end rtl;
