library IEEE;
library STD;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.decoder.all;
use WORK.divider_const.all;

--Additional standard or custom libraries go here
entity comparator is
port(
--Inputs
DINL : in std_logic_vector (DIVISOR_WIDTH downto 0);
DINR : in std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
--Outputs
DOUT : out std_logic_vector (DIVISOR_WIDTH - 1 downto 0);
isGreaterEq : out std_logic
);
end entity comparator;


architecture behavioral of comparator is
--signal inputL:integer;
--signal inputR:integer;
--signal output:integer; 

begin  
process(DINL,DINR) is
variable inputL:integer;
variable inputR:integer;
begin

inputL:=to_integer(unsigned(DINL));
inputR:=to_integer(unsigned(DINR));

if(inputL>inputR OR inputL=inputR) then
    DOUT <= std_logic_vector(to_unsigned(abs(inputL-inputR),DIVISOR_WIDTH));
    isGreaterEq<='1';
else 
     DOUT <= std_logic_vector(to_unsigned(abs(inputL),DIVISOR_WIDTH));
     isGreaterEq<='0';
end if; 

end process;  
end architecture behavioral;
