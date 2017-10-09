library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.decoder.all;

--Additional standard or custom libraries go here
entity comparator is
generic(
DATA_WIDTH : natural := 4
);
port(
--Inputs
DINL : in std_logic_vector (DATA_WIDTH downto 0);
DINR : in std_logic_vector (DATA_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DATA_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
);
end entity comparator;


architecture behavioral of comparator is
signal inputL:integer;
signal inputR:integer;
signal output:integer; 

begin
inputL<=to_integer(unsigned(DINL));
inputR<=to_integer(unsigned(DINR));
P1: process(inputL, inputR)
begin
if(inputL>=inputR) then
    output<= inputL-inputR; 
    isGreaterEq<='1';
elsif(inputL<inputR) then 
     output<=inputL;
     isGreaterEq<='0';
end if; 

DOUT<=std_logic_vector(to_unsigned(output,DATA_WIDTH));
end process P1;  
end architecture behavioral;
