library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity traffic_light is 
port (
	clk 				: in std_logic;
    mode 				: inout std_logic_vector (1 downto 0) := "10";
    red, green, yellow 	: out std_logic := '0';
	nRst 			: in std_logic;
	milliseconds	: in integer;
	seconds 		: in integer;
	enable			: in std_logic;
	nRstTimer		: inout std_logic := '0';
	mod_Maintenance : in std_logic_vector (1 downto 0) := "00"
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
	milliseconds	: inout integer := 0;
	seconds 		: inout integer := 0;
	nRstTimer		: in	std_logic
);
end counter;	

architecture traffic_light_behavior of traffic_light is
begin

	mode <= "00" when falling_edge(nRst);

	process (clk) is
	begin
		if (rising_edge(clk)) then
			report "traffic_light_behavior";
			if (milliseconds <= 10 and seconds = 0) then
				nRstTimer <= '0';
			end if;
			if (enable = '1') then
				report "enable 1";
				if (mode = "00") then
					--maintenance
					report  "maintenace";
					if (mod_Maintenance = "00") then
						if (seconds = 0 and milliseconds < 500) then
							red <= '1';
							yellow <= '0';
							green <= '0';
						else
							if (seconds < 1) then
								red <= '0';
								yellow <= '1';
							else
								if (milliseconds < 500 and seconds >= 1) then
									yellow <= '0';
									green <= '1';
								else
									nRstTimer <= '1';
									green <= '0';
								end if;
							end if;
						end if;
					else
						if (seconds < 6) then
							red <= '1';
						else
							if ((seconds < 9 and mod_Maintenance = "01") or (seconds < 12 and mod_Maintenance = "10") or (seconds < 18 and mod_Maintenance = "11")) then
								-- in base alla modalita la durata del giallo cambia
								red <= '0';
								yellow <= '1';
							else
								nRstTimer <= '1';
								yellow <= '0';
							end if;
						end if;
					end if;
				else
					if (mode = "01") then
						--standby
						report "standby";
						if (seconds < 1) then
							yellow <= '1';
						else
							if (seconds < 3) then
								yellow <= '0';
							else
								nRstTimer <= '1';
							end if;
						end if;
					else
						if (mode = "10") then
							--nominal
							report "nominal";
							if (seconds < 3) then
								red <= '1';
							else
								red <= '0';
								if (seconds < 8) then
									green <= '1';
									if (seconds >= 6) then
										yellow <= '1';
									end if;
								else 
									green <= '0';
									yellow <= '0';					
									nRstTimer <= '1';
								end if;
							end if;
							
							--timeprova := timeprova + 1;
							--report "tempo " & integer'image(timeprova);
							--r := '1';
							--red <= r;
							--report "red = " & std_logic'image(r);
						end if;			
					end if;
				end if;
			else
				-- enable a 0
				report "enable 0";
				red <= '0';
				yellow <= '0';
				green <= '0';
			end if;
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
			if nRstTimer = '1' then
				Ticks <= 0;
				milliseconds <= 0;
				seconds <= 0;
			end if;
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