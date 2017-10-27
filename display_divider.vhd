library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.decoder.all;
use work.divider_const.all;

entity display_divider is
port(
clk_disp : in std_logic;

start_disp : in std_logic;
dividend_disp: in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
divisor_disp : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
--quotient_disp : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
--remainder_disp : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
out1: out std_logic_vector (6 downto 0);
out2: out std_logic_vector (6 downto 0);
out3: out std_logic_vector (6 downto 0);
out4: out std_logic_vector (6 downto 0);
out5: out std_logic_vector (6 downto 0); 
out6: out std_logic_vector (6 downto 0); 
overflow_disp : out std_logic

);
end entity display_divider;


architecture structural of display_divider is
----------------------------------------------
----------------------------------------------
component leddcd is 
port(
    data_in : in std_logic_vector(3 downto 0);
    segments_out : out std_logic_vector(6 downto 0)
		);

end component leddcd;
----------------------------------------------
----------------------------------------------
component divider is
port(
--Inputs
clk : in std_logic;
--COMMENT OUT clk signal for Part A.
start : in std_logic;
dividend : in std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
divisor : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
quotient : out std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
remainder : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
overflow : out std_logic
);
end component divider;
-------------------------------------------------
-------------------------------------------------
signal q_indicator :std_logic_vector(DIVIDEND_WIDTH - 1 downto 0);
signal r_indicator : std_logic_vector(DIVISOR_WIDTH-1 downto 0);

begin

d1 : divider
    port map (
	   clk => clk_disp,
      start => start_disp,
      dividend => dividend_disp,
      divisor => divisor_disp,
      quotient=> q_indicator,
      remainder=>r_indicator, 
      overflow=>overflow_disp
      );
		
 

l1:leddcd port map (q_indicator(3 downto 0), out1 (6 downto 0));
l2:leddcd port map (q_indicator(7 downto 4), out2 (6 downto 0));
l3:leddcd port map (r_indicator, out3 (6 downto 0));

p1:leddcd port map (dividend_disp(3 downto 0), out4(6 downto 0)); 
p2:leddcd port map (dividend_disp(7 downto 4), out5(6 downto 0)); 
p3:leddcd port map (divisor_disp, out6(6 downto 0)); 


--Structural design goes here
end architecture structural;
