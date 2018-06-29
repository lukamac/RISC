library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use IEEE.math_real."ceil";
use IEEE.math_real."log2";

entity baud_rate_gen is
	generic(
		BAUD_RATE : natural := 9600;
		CLK_FREQ : natural := 27000000
	);
	port(
		clk : in std_logic;
		rst : in std_logic;
		tick : out std_logic
	);
end entity baud_rate_gen;

architecture rtl of baud_rate_gen is

	constant SAMPLES : natural := 16;
   constant TICK_PERIOD : natural := natural(ceil(real(CLK_FREQ) / (real(SAMPLES) * real(BAUD_RATE))));
	signal counter16_reg, counter16_next :
					std_logic_vector(integer(ceil(log2(real(TICK_PERIOD)))) - 1 downto 0) := (others => '0');
	
begin

	process (clk) is
	
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				counter16_reg <= (others => '0');
			else
				counter16_reg <= counter16_next;
			end if;
		end if;
	end process;
	
	counter16_next <= (others => '0') when counter16_reg = TICK_PERIOD - 1 else
                      counter16_reg + 1;
	tick <= '1' when counter16_reg = TICK_PERIOD - 1 else 
			  '0';
	
end architecture rtl;
