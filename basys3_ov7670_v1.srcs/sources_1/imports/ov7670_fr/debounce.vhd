----------------------------------------------------------------------------------
-- Engineer: Mike Field <hamster@snap.net.nz>
-- 
-- Description: Convert the push button to a 1PPS that can be used to restart
--              camera initialisation
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce is
    Port ( clk : in  STD_LOGIC;
           i : in  STD_LOGIC;
           o : out  STD_LOGIC);
end debounce;

architecture Behavioral of debounce is
	signal c : unsigned(23 downto 0);
begin
	process(clk)
	begin
		if rising_edge(clk) then
		   if i = '1' then
		      if c = x"FFFFFF" then
					o <= '1';
				else
					o <= '0';
				end if;
				c <= c+1;
			else
				c <= (others => '0');
				o <= '0';
			end if;
		end if;
	end process;

end Behavioral;

