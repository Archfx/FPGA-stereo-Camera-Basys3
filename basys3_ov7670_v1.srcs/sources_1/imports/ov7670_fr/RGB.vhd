
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;



entity RGB is
    Port ( Din 	: in	STD_LOGIC_VECTOR (11 downto 0);			-- niveau de gris du pixels sur 8 bits
			  Nblank : in	STD_LOGIC;										-- signal indique les zone d'affichage, hors la zone d'affichage
																					-- les trois couleurs prendre 0
           R,G,B 	: out	STD_LOGIC_VECTOR (7 downto 0));			-- les trois couleurs sur 10 bits
end RGB;

architecture Behavioral of RGB is

signal Gray : std_logic_vector(7 downto 0);
begin
        Gray  <= (Din(7 downto 4) & Din(7 downto 4));
        --Gray  <= std_logic_vector(unsigned(Din(11 downto 8) & Din(11 downto 8)) + unsigned(Din(7 downto 4)  & Din(7 downto 4)) + unsigned(Din(3 downto 0)  & Din(3 downto 0))/3);--((Din(11 downto 8) & Din(11 downto 8))+(Din(7 downto 4)  & Din(7 downto 4))+(Din(3 downto 0)  & Din(3 downto 0)));
		R <= Gray when Nblank='1' else "00000000";
		G <= Gray  when Nblank='1' else "00000000";
		B <= Gray  when Nblank='1' else "00000000";

end Behavioral;

