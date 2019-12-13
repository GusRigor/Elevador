library IEEE;
use ieee.std_logic_1164.all;                                                                                                                                   
use ieee.std_logic_unsigned.all; 
USE ieee.numeric_std.ALL;
use ieee.NUMERIC_STD.UNSIGNED;
                                                                                                                                                                                                                                        
ENTITY elevador is
   Port(
      SW          : in   std_logic_vector(17 downto 0);
      HEX6 	  : out  std_logic_vector(6 downto 0);
      LEDR        : out  std_logic_vector(0 downto 0);
		LEDG        : out  std_logic_vector(0 downto 0)
   );
 END ENTITY;

ARCHITECTURE arq OF elevador IS

-- Signals

signal andar1 : std_logic_vector(0 downto 0) := "0";
signal andar2 : std_logic_vector(0 downto 0) := "0";
signal andar3 : std_logic_vector(0 downto 0) := "0";
signal botao1 : std_logic_vector(0 downto 0) := "0";
signal botao2 : std_logic_vector(0 downto 0) := "0";
signal botao3 : std_logic_vector(0 downto 0) := "0";
signal result : std_logic_vector(0 downto 0) := "0";
signal resultd : std_logic_vector(0 downto 0) := "0";

 BEGIN
 
 andar1 <= SW(15 downto 15);
 andar2 <= SW(16 downto 16);
 andar3 <= SW(17 downto 17);
 botao1 <= SW(0 downto 0);
 botao2 <= SW(1 downto 1);
 botao3 <= SW(2 downto 2); 

 LEDR(0 downto 0) <= result;
 LEDG(0 downto 0) <= resultd;
 
proc_main:
 process(andar1,andar2,andar3,botao1,botao2,botao3)
  BEGIN
		if andar1 = "0" and andar2 = "0" and andar3 = "0" then
			HEX6(0) <= '0'; --A
			HEX6(1) <= '1'; --B
			HEX6(2) <= '1'; --C
			HEX6(3) <= '0'; --D
			HEX6(4) <= '1'; --E
			HEX6(5) <= '1'; --F
			HEX6(6) <= '0'; --G
			
			result <= "1";
			resultd <= "1";
		else
			if	andar1 = "1" then
				HEX6(0) <= '1'; --A
				HEX6(1) <= '0'; --B
				HEX6(2) <= '0'; --C
				HEX6(3) <= '1'; --D
				HEX6(4) <= '1'; --E
				HEX6(5) <= '1'; --F
				HEX6(6) <= '1'; --G

				if botao1 = "0" and botao2 = "0" and botao3 = "0" then
					result <= "0";
					resultd <= "0";
				elsif botao1 = "1" then
					result <= "0";
				else
					result <= "1";
				end if;
			end if;

			if andar2 = "1" then
				HEX6(0) <= '0'; --A
				HEX6(1) <= '0'; --B
				HEX6(2) <= '1'; --C
				HEX6(3) <= '0'; --D
				HEX6(4) <= '0'; --E
				HEX6(5) <= '1'; --F
				HEX6(6) <= '0'; --G

				if botao1 = "0" and botao2 = "0" and botao3 = "0" then
						result <= "0";
						resultd <= "0";
						
				elsif botao2 = "1" then
					result <= "0";
					resultd <= "0";
				else
				--SE o botao1 for para 1, ligar o verde
					if botao1 = "1" then
						result <= "0";
						resultd <= "1";
					end if;
				--SE o botao3 for para 1, ligar o vermelho
					if botao3 = "1" then
						result <= "1";
						resultd <= "0";
					end if;
				end if;
			end if;

			if andar3 = "1" then
				HEX6(0) <= '0'; --A
				HEX6(1) <= '0'; --B
				HEX6(2) <= '0'; --C
				HEX6(3) <= '0'; --D
				HEX6(4) <= '1'; --E
				HEX6(5) <= '1'; --F
				HEX6(6) <= '0'; --G

				if botao1 = "0" and botao2 = "0" and botao3 = "0" then
					result <= "0";
				elsif botao3 = "1" then
					result <= "0";
					resultd <= "0";
				else
					result <= "0";
					resultd <= "1";
				end if;
			end if;
		end if;
 end process;

END ARCHITECTURE arq;
