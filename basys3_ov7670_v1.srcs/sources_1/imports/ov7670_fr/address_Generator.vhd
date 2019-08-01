
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Address_Generator is
    Port ( 	CLK25,enable : in  STD_LOGIC;								-- horloge de 25 MHz et signal d'activation respectivement
            rez_160x120  : IN std_logic;
            rez_320x240  : IN std_logic;
            vsync        : in  STD_LOGIC;
				address 		 : out STD_LOGIC_VECTOR (18 downto 0));	-- adresse généré
end Address_Generator;

architecture Behavioral of Address_Generator is
   signal val: STD_LOGIC_VECTOR(address'range):= (others => '0');		-- signal intermidiaire
begin
	address <= val;																		-- adresse généré

	process(CLK25)
		begin
         if rising_edge(CLK25) then
            if (enable='1') then													-- si enable = 0 on arrete la génération d'adresses
               if rez_160x120 = '1' then
                  if (val < 160*120) then										-- si l'espace mémoire est balayé complétement				
                     val <= val + 1 ;
                  end if;
               elsif rez_320x240 = '1' then
                  if (val < 320*240) then										-- si l'espace mémoire est balayé complétement				
                     val <= val + 1 ;
                  end if;
               else
                  if (val < 640*480) then										-- si l'espace mémoire est balayé complétement				
                     val <= val + 1 ;
                  end if;
               end if;
				end if;
            if vsync = '0' then 
               val <= (others => '0');
            end if;
			end if;	
		end process;
end Behavioral;

