----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Mike Field <hamster@sanp.net.nz> 
-- 
-- Description: Register settings for the OV7670 Caamera (partially from OV7670.c
--              in the Linux Kernel
------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_registers is
    Port ( clk      : in  STD_LOGIC;
           resend   : in  STD_LOGIC;
           advance  : in  STD_LOGIC;
           command  : out  std_logic_vector(15 downto 0);
           finished : out  STD_LOGIC);
end ov7670_registers;

architecture Behavioral of ov7670_registers is
	signal sreg   : std_logic_vector(15 downto 0);
	signal address : std_logic_vector(7 downto 0) := (others => '0');
begin
	command <= sreg;
	with sreg select finished  <= '1' when x"FFFF", '0' when others;
	
	process(clk)
	begin
		if rising_edge(clk) then
			if resend = '1' then 
				address <= (others => '0');
			elsif advance = '1' then
				address <= std_logic_vector(unsigned(address)+1);
			end if;

			case address is
				when x"00" => sreg <= x"1280"; -- COM7   Reset
				when x"01" => sreg <= x"1280"; -- COM7   Reset
				when x"02" => sreg <= x"1204"; -- COM7   Size & RGB output
				when x"03" => sreg <= x"1100"; -- CLKRC  Prescaler - Fin/(1+1)
				when x"04" => sreg <= x"0C00"; -- COM3   Lots of stuff, enable scaling, all others off
				when x"05" => sreg <= x"3E00"; -- COM14  PCLK scaling off
				
   			when x"06" => sreg <= x"8C00"; -- RGB444 Set RGB format
   			when x"07" => sreg <= x"0400"; -- COM1   no CCIR601
 				when x"08" => sreg <= x"4010"; -- COM15  Full 0-255 output, RGB 565
				when x"09" => sreg <= x"3a04"; -- TSLB   Set UV ordering,  do not auto-reset window
				when x"0A" => sreg <= x"1438"; -- COM9  - AGC Celling
				when x"0B" => sreg <= x"4fb3"; -- MTX1  - colour conversion matrix
				when x"0C" => sreg <= x"50b3"; -- MTX2  - colour conversion matrix
				when x"0D" => sreg <= x"5100"; -- MTX3  - colour conversion matrix
				when x"0E" => sreg <= x"523d"; -- MTX4  - colour conversion matrix
				when x"0F" => sreg <= x"53a7"; -- MTX5  - colour conversion matrix
				when x"10" => sreg <= x"54e4"; -- MTX6  - colour conversion matrix
				when x"11" => sreg <= x"589e"; -- MTXS  - Matrix sign and auto contrast
				when x"12" => sreg <= x"3dc0"; -- COM13 - Turn on GAMMA and UV Auto adjust
				when x"13" => sreg <= x"1100"; -- CLKRC  Prescaler - Fin/(1+1)
				
				when x"14" => sreg <= x"1711"; -- HSTART HREF start (high 8 bits)
				when x"15" => sreg <= x"1861"; -- HSTOP  HREF stop (high 8 bits)
				when x"16" => sreg <= x"32A4"; -- HREF   Edge offset and low 3 bits of HSTART and HSTOP
				
				when x"17" => sreg <= x"1903"; -- VSTART VSYNC start (high 8 bits)
				when x"18" => sreg <= x"1A7b"; -- VSTOP  VSYNC stop (high 8 bits) 
				when x"19" => sreg <= x"030a"; -- VREF   VSYNC low two bits
         
            when x"1A" => sreg <= x"0e61"; -- COM5(0x0E) 0x61
            when x"1B" => sreg <= x"0f4b"; -- COM6(0x0F) 0x4B 
            
            when x"1C" => sreg <= x"1602"; --
            when x"1D" => sreg <= x"1e37"; -- MVFP (0x1E) 0x07  -- FLIP AND MIRROR IMAGE 0x3x

            when x"1E" => sreg <= x"2102";
            when x"1F" => sreg <= x"2291";
            
            when x"20" => sreg <= x"2907";
            when x"21" => sreg <= x"330b";
                                  
            when x"22" => sreg <= x"350b";
            when x"23" => sreg <= x"371d";
                                  
            when x"24" => sreg <= x"3871";
            when x"25" => sreg <= x"392a";
                                   
            when x"26" => sreg <= x"3c78"; -- COM12 (0x3C) 0x78
            when x"27" => sreg <= x"4d40"; 
                                  
            when x"28" => sreg <= x"4e20";
            when x"29" => sreg <= x"6900"; -- GFIX (0x69) 0x00
                                   
            when x"2A" => sreg <= x"6b4a";
            when x"2B" => sreg <= x"7410";
                                  
            when x"2C" => sreg <= x"8d4f";
            when x"2D" => sreg <= x"8e00";
                                   
            when x"2E" => sreg <= x"8f00";
            when x"2F" => sreg <= x"9000";
                                  
            when x"30" => sreg <= x"9100";
            when x"31" => sreg <= x"9600";
                                  
            when x"32" => sreg <= x"9a00";
            when x"33" => sreg <= x"b084";
                                  
            when x"34" => sreg <= x"b10c";
            when x"35" => sreg <= x"b20e";
                                  
            when x"36" => sreg <= x"b382";
            when x"37" => sreg <= x"b80a";
--				when x"10" => sreg <= x"703a"; -- SCALING_XSC
--				when x"11" => sreg <= x"7135"; -- SCALING_YSC
--				when x"12" => sreg <= x"7200"; -- SCALING_DCWCTR  -- zzz was 11 
--				when x"13" => sreg <= x"7300"; -- SCALING_PCLK_DIV
--				when x"14" => sreg <= x"a200"; -- SCALING_PCLK_DELAY  must match COM14
--          when x"15" => sreg <= x"1500"; -- COM10 Use HREF not hSYNC
--				
--				when x"1D" => sreg <= x"B104"; -- ABLC1 - Turn on auto black level
--				when x"1F" => sreg <= x"138F"; -- COM8  - AGC, White balance
--				when x"21" => sreg <= x"FFFF"; -- spare
--				when x"22" => sreg <= x"FFFF"; -- spare
--				when x"23" => sreg <= x"0000"; -- spare
--				when x"24" => sreg <= x"0000"; -- spare
--				when x"25" => sreg <= x"138F"; -- COM8 - AGC, White balance
--				when x"26" => sreg <= x"0000"; -- spare
--				when x"27" => sreg <= x"1000"; -- AECH Exposure
--				when x"28" => sreg <= x"0D40"; -- COMM4 - Window Size
--				when x"29" => sreg <= x"0000"; -- spare
--				when x"2a" => sreg <= x"a505"; -- AECGMAX banding filter step
--				when x"2b" => sreg <= x"2495"; -- AEW AGC Stable upper limite
--				when x"2c" => sreg <= x"2533"; -- AEB AGC Stable lower limi
--				when x"2d" => sreg <= x"26e3"; -- VPT AGC fast mode limits
--				when x"2e" => sreg <= x"9f78"; -- HRL High reference level
--				when x"2f" => sreg <= x"A068"; -- LRL low reference level
--				when x"30" => sreg <= x"a103"; -- DSPC3 DSP control
--				when x"31" => sreg <= x"A6d8"; -- LPH Lower Prob High
--				when x"32" => sreg <= x"A7d8"; -- UPL Upper Prob Low
--				when x"33" => sreg <= x"A8f0"; -- TPL Total Prob Low
--				when x"34" => sreg <= x"A990"; -- TPH Total Prob High
--				when x"35" => sreg <= x"AA94"; -- NALG AEC Algo select
--				when x"36" => sreg <= x"13E5"; -- COM8 AGC Settings
				when others => sreg <= x"ffff";
			end case;
		end if;
	end process;
end Behavioral;
