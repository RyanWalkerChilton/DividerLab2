library STD;
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_textio.all;
use IEEE.numeric_std.all;
use work.decoder.all;
use std.textio.all;

entity comparator_testbench is 
end comparator_testbench;

architecture testbench of comparator_testbench is 
-----------------------------------------------------------------------------
-- Declare the Component Under Test
-----------------------------------------------------------------------------
component comparator is
generic(
DATA_WIDTH : natural := 16
);
port(
--Inputs
DINL : in std_logic_vector (DATA_WIDTH downto 0);
DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
);
end component comparator;
----------------------------------------------------------------------------
-- Testbench Internal Signals
-----------------------------------------------------------------------------
--Inputs

signal inp1 : std_logic_vector (16  downto 0);
signal inp2 : std_logic_vector (15 downto 0);
signal out1 : std_logic_vector (15 downto 0);
signal flag : std_logic;

begin
-----------------------------------------------------------------------------
-- Instantiate and Map UUT
-----------------------------------------------------------------------------
  tb1 : comparator
    generic map (DATA_WIDTH   => 16) --NO SEMICOLON
    port map (
      DINL => inp1,
      DINR => inp2,
      DOUT => out1,
      isGreaterEq=> flag
      );
------------------------------------------------------------------
process is 
variable t1:integer;
variable t2:integer;
variable iline: line; 
variable oline:line;
file infile:text;
file outfile:text;

begin
file_open(infile, "d_tb.in",  read_mode);
file_open(outfile, "d_tb.out", write_mode);

while not(endfile(infile)) loop
readline(infile,iline);
read(iline,t1);
readline(infile,iline);
read(iline,t2);

write(oline,t1);
write(oline,string'(","));
write(oline,t2);
write(oline,string'("="));


inp1<=std_logic_vector(to_unsigned(t1,17));
inp2<=std_logic_vector(to_unsigned(t2,16));

wait for 20 ns;
write(oline,to_integer(unsigned(out1)));
writeline(outfile, oline);
end loop;

file_close(infile);
file_close(outfile);
wait;
end process;
end architecture testbench; 
