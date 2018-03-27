library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regset is
    port (clk : in std_logic;
          we  : in std_logic;
          a   : in std_logic_vector(4 downto 0);
          b   : in std_logic_vector(4 downto 0);
          c   : in std_logic_vector(4 downto 0);
          dic  : in std_logic_vector(31 downto 0);
          doa  : out std_logic_vector(31 downto 0);
          dob  : out std_logic_vector(31 downto 0));
end regset;

architecture rtl of regset is
    type ram_type is array (31 downto 0) of std_logic_vector (31 downto 0);
    signal RAM : ram_type;
begin

    process (clk)
    begin
        if (rising_edge(clk)) then
            if (we = '1') then
                RAM(to_integer(unsigned(c))) <= dic;
            end if;
        end if;
    end process;

    doa <= RAM(to_integer(unsigned(a)));
    dob <= RAM(to_integer(unsigned(b)));

end rtl;
