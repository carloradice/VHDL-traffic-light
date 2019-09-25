library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity traffic_light is 
port (
	clk 				: in std_logic;
    mode 				: in std_logic_vector (1 downto 0);
    red, green, yellow 	: out std_logic
);
end traffic_light;

entity counter is 
port (
	clk 			: in std_logic;
	nRst 			: in std_logic;
	milliseconds 	: out integer;
	seconds 		: out integer;
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
end traffic_light_behavior;		
			
architecture counter_behavior of counter is
	-- Signal for counting clock periods
	signal Ticks : integer;

begin 
	process (clk) is 
	begin
		if rising_edge (clk) then
			-- if the negative reset signal is active
			if nRst = '0' then 
			else
				if Ticks = ClockFrequency - 1
					Ticks <= 0;
				else 
					Ticks <= Ticks + 1;
				end if; 
			end if;
		end if;
	end process;
end architecture;