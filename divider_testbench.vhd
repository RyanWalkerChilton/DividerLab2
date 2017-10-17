library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_textio.all;
use IEEE.numeric_std.all;
use work.decoder.all;
use work.divider_const.all;
use std.textio.all;

entity divider_testbench is 
end divider_testbench;

architecture divtest of divider_testbench is 
-----------------------------------------------------------------------------
-- Declare the Component Under Test
----------------------------------------------------------------------------

component divider is 
port(
--Inputs
-- clk : in std_logic;
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



----------------------------------------------------------------------------
-- Testbench Internal Signals
-----------------------------------------------------------------------------
--Inputs
signal start1 :std_logic:='1';
signal dividend1 :std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
signal divisor1 :std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
signal remain1:std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
signal quot1:std_logic_vector (DIVIDEND_WIDTH - 1 downto 0);
signal flag1 :std_logic;

begin 
-----------------------------------------------------------------------------
-- Instantiate and Map
-----------------------------------------------------------------------------
  tb1 : divider
    port map (
      start =>start1,
      dividend => dividend1,
      divisor => divisor1,
      remainder => remain1,
      quotient=> quot1,
      overflow=> flag1
      
      );
------------------------------------------------------------------
P1:process is 
begin
start1 <= '0';
wait for 20 ns;
start1 <= '1';
wait for 20 ns;
end process P1;

P2:process is 
variable t1:integer;
variable t2:integer;
variable iline: line; 
variable oline:line;
file infile:text;
file outfile:text;

begin



file_open(infile, "dividerIN16.in",  read_mode);
file_open(outfile, "dividerOUT16.out", write_mode);

while not(endfile(infile)) loop
readline(infile,iline);
read(iline,t1);
readline(infile,iline);
read(iline,t2);

write(oline,t1);
write(oline,string'("/"));
write(oline,t2);
write(oline,string'("="));


dividend1<=std_logic_vector(to_unsigned(t1,DIVIDEND_WIDTH));
divisor1<=std_logic_vector(to_unsigned(t2,DIVISOR_WIDTH));

wait for 50 ns;
write(oline,to_integer(unsigned(quot1)));
write(oline,string'(" -- "));
write(oline,to_integer(unsigned(remain1)));
writeline(outfile, oline);

end loop;

file_close(infile);
file_close(outfile);
wait;
end process;
end architecture divtest; 
