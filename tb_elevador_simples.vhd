
library ieee;
use ieee.std_logic_1164.all;

entity tb_elevador_simples is

end entity tb_elevador_simples;

architecture interface of tb_elevador_simples is
	signal  RESETn, CLK								: std_logic; 	
	signal  SNS_ANDAR,  BOTAO						: std_logic_vector (1 to 3);
	signal  MOTOR										: std_logic_vector (1 downto 0);
	
begin

uut:  entity work.elevador_3
port map
	(
		RESETn, CLK,
		SNS_ANDAR,  BOTAO,
		MOTOR,
		TRAVA_PORTA

	);
	
	
	
Gera_Clock:
		process
		begin
		--	simulação do pressionamento do botão de reset.
			resetn <= '0' after 0 ms,
						'1' after 1  ms,
						'0' after 300 ms;

			CLK <= '0';
			wait for 1 ms;
		-- rotina de geração de clock
			while resetn = '1' loop
				CLK <= not CLK;
				wait for 20833 ps;
			end loop;		
		
			wait;
		end process;

elevador:
process
begin
	SNS_ANDAR <= "000";
	BOTAO <= "000";


	
	SNS_ANDAR <= "100";
	wait for 20ms;
	-- Pressionamento do botão do 3º andar
	BOTAO <= "001";
	wait for 20ms;
	BOTAO <= "000";
	wait for 20ms;
	

	while ( MOTOR = "00") loop
		wait for 10 ms;
	end loop;	
		
	SNS_ANDAR <= "000";
	wait for 15ms;

	SNS_ANDAR <= "010";
	wait for 5ms;
	
	SNS_ANDAR <= "000";
	wait for 15ms;

	SNS_ANDAR <= "001";
	wait for 10ms;
	-- Pressionamento do botão do 2º andar
	BOTAO <= "010";
	wait for 10ms;
	BOTAO <= "000";
	wait for 5ms;

	-- Pressionamento do botão do 1º andar
	BOTAO <= "100";
	wait for 5ms;
	BOTAO <= "000";
	wait for 5ms;

	while ( MOTOR = "00") loop
		wait for 5 ms;
	end loop;	

	SNS_ANDAR <= "000";
	wait for 10ms;

	SNS_ANDAR <= "010";	--Chegou ao segundo andar...
	wait for 10ms;

	while ( MOTOR = "00") loop
		wait for 5 ms;
	end loop;	

	SNS_ANDAR <= "000";
	wait for 10ms;
	
	BOTAO <= "010";
	wait for 5ms;
	BOTAO <= "00000";
	wait for 20ms;
	
	SNS_ANDAR <= "001";	--Chegou ao primeiro andar...
	wait for 5ms;
	
	-- Pressionamento do botão do 3º andar quando está descendo
	BOTAO <= "100";
	wait for 5ms;
	BOTAO <= "000";
	wait for 20ms;
	SNS_ANDAR <= "000";
	
	wait for 10ms;
	
	SNS_ANDAR <= "001";	--Chegou ao primeiro andar...
	wait for 5ms;
	
	wait;
end process;

end architecture interface;
