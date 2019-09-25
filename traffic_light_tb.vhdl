library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity traffic_light_tb is 
end entity

architecture traffic_light_tb_behavior of traffic_light_tb is
	constant ClockFrequencyHz : integer := 100; -- 100 Hz
   	constant ClockPeriod      : time := 1000 ms / ClockFrequencyHz;
	