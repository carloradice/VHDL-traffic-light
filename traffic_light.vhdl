library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light is 
port (
	clk 				: in std_logic;
    mode 				: in std_logic_vector (1 downto 0);
    red, green, yellow 	: out std_logic
);
end traffic_light;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity counter is 
generic (ClockFrequencyHz : integer);
port (
	clk				: in std_logic;
	nRst 			: in std_logic;
	milliseconds	: inout integer;
	seconds 		: inout integer
);
end counter;	

architecture traffic_light_behavior of traffic_light is
begin
	process (clk) is
	variable r : std_logic := '0';
	variable g : std_logic := '0';
	variable y : std_logic := '0';
	begin
		if (rising_edge(clk)) then
			r := '1';
			red <= r;
			report "red = " & std_logic'image(r);
			
		end if;
	end process;
end architecture;	

architecture counter_behavior of counter is
	-- Signal for counting clock periods
	signal Ticks : integer;

begin 
	process (clk) is 
	begin
		if rising_edge (clk) then
			-- if the negative reset signal is active
			if nRst = '0' then 
				Ticks <= 0;
				milliseconds <= 0;
				seconds <= 0;
			else
				report "reset = 1";
				-- True one every 10 milliseconds
				if Ticks = ClockFrequencyHz - 10 then
					report "tick = 0";
					Ticks <= 0;
					-- True every second
					if milliseconds = 900 then
						report "aggiorno i secondi";
						milliseconds <= 0;
						seconds <= seconds + 1;
					else
						report "aggiorno i millisecondi";
						milliseconds <= milliseconds + 100;
					end if;
				else 
					Ticks <= Ticks + 10;
				end if; 
			end if;
		end if;
	end process;
end architecture;