-----------------------------------------------------------------------------------------------
--                                                                                            -
--    Projeto: elevador_simples_5                                                             -
--                                                                                            -
--    Este projeto foi desenvolvido para ilustrar o conceito de maquina de estados            -
--		O projeto controla um elevador de carga de 5 andares.                                   -
--                                                                                            -
--    Por:  Prof. Edson Melo                                                                  -
-----------------------------------------------------------------------------------------------

library ieee; 
use ieee.std_logic_1164.all;		-- Definição das bibliotecas a serem utilizadas no projeto.

entity elevador_simples_5 is		-- Início do projeto, onde será definido as entradas e saídas
											-- utilizadas
	port
	(
		RESETn, CLK				: in std_logic;
		SNS_ANDAR, BOTAO		: in std_logic_vector (1 to 5);
		MOTOR						: out std_logic_vector (1 downto 0);
		TRAVA_PORTA				: out std_logic
	);
end entity elevador_simples_5;

architecture comportamento of elevador_simples_5 is
   -- CHAMADOS registra os andares em que o elevador foi solicitado
	-- ANDAR registra o ultimo andar pelo qual o elevador passou
	signal  CHAMADOS, ANDAR				: std_logic_vector (1 to 5);
	
	-- SENTIDO apresenta o sentido que o elevador esta indo
	-- '1' = subindo e '0' = descendo
	signal  PAUSA_ANDAR		: std_logic;
	
	-- Estados associados ao comportamento do elevador:
	type ESTADO is (ESPERA, PARTIDA, PARADO, DESCENDO, SUBINDO);
	
	-- Estado atual da maquina de estados
	signal MAQUINA_ELEVADOR	: ESTADO;
	signal flag : std_logic := '1';

begin


	process (RESETn, CLK, SNS_ANDAR, BOTAO, CHAMADOS, MAQUINA_ELEVADOR)
		variable ANDAR_CHAMADO: std_logic_vector (1 to 5) := "00000";
	begin

		if (CLK'event and CLK = '1' ) then
			if  (SNS_ANDAR /= "00000") then
				ANDAR <= SNS_ANDAR;
			end if;

			if (BOTAO /= "00000") then
			-- Se o botao for apertado, ANDAR_CHAMADO seta o bit correspondente ao andar
			-- de forma que ele nao registra duas vezes o mesmo andar 
				ANDAR_CHAMADO := ANDAR_CHAMADO or BOTAO;
			end if;
		
			if  (MAQUINA_ELEVADOR = PARADO) then
					ANDAR_CHAMADO := ANDAR_CHAMADO and (not SNS_ANDAR);
			end if;
		end if;
		CHAMADOS <= ANDAR_CHAMADO;

	end process;

	-- Maquina de estados
    process (RESETn, CLK, MAQUINA_ELEVADOR, ANDAR, PAUSA_ANDAR) is
	 begin
		if (RESETn = '0') then
			MAQUINA_ELEVADOR <= ESPERA;
			
		elsif (CLK'event and CLK = '1' ) then
			
			case MAQUINA_ELEVADOR is
			
			-- Se o elevador chega a algum andar ele vai para o estado PARADO
				when ESPERA =>
						MAQUINA_ELEVADOR <= PARTIDA;
				
				when PARTIDA =>
					if (SNS_ANDAR /= "00000") then
						MAQUINA_ELEVADOR <= PARADO;
					end if;

			-- O elevador sobe até o andar mais alto e depois vai descendo e parando
				when SUBINDO =>
					-- Rotina de detecçao do andar mais alto solicitado
					if CHAMADOS(5) = '1' then
						if SNS_ANDAR (5) /= '0'  then
						MAQUINA_ELEVADOR <=  PARADO;
						flag <= '0';
						end if;
					elsif CHAMADOS(4) = '1' then
						if SNS_ANDAR (4) /= '0'  then
						MAQUINA_ELEVADOR <=  PARADO;
						flag <= '0';
						end if;
					elsif CHAMADOS(3) = '1' then
						if SNS_ANDAR (3) /= '0'  then
						MAQUINA_ELEVADOR <=  PARADO;
						flag <= '0';
						end if;						
					elsif CHAMADOS(2) = '1' then
						if SNS_ANDAR (2) /= '0'  then
						MAQUINA_ELEVADOR <=  PARADO;
						flag <= '0';
						end if;
					elsif CHAMADOS(1) = '1' then
						if SNS_ANDAR (1) /= '0'  then
						MAQUINA_ELEVADOR <=  PARADO;
						flag <= '0';
						end if;
					end if;
						
				-- Se o elevador passar por algum andar solicitado, ele vai para o estado PARADO,
				-- e desce até o andar mais baixo solicitado antes de voltar a subir.
				when DESCENDO =>
					if ( SNS_ANDAR and CHAMADOS) /= "00000"  then
						MAQUINA_ELEVADOR <= PARADO;
					end if;
					-- Rotina de detecção do andar solicitado mais baixo para possibilitar a habilitação
					-- de subida novamente
					if CHAMADOS(1) = '1' then
						if SNS_ANDAR (1) /= '0'  then
						flag <= '1';
						end if;
					elsif CHAMADOS(2) = '1' then
						if SNS_ANDAR (2) /= '0'  then
						flag <= '1';
						end if;
					elsif CHAMADOS(3) = '1' then
						if SNS_ANDAR (3) /= '0'  then
						flag <= '1';
						end if;						
					elsif CHAMADOS(4) = '1' then
						if SNS_ANDAR (4) /= '0'  then
						flag <= '1';
						end if;
					elsif CHAMADOS(5) = '1' then
						if SNS_ANDAR (5) /= '0'  then
						flag <= '1';
						end if;
					end if;
						
				
				when others =>  -- Ou seja, quando PARADO:
					if (PAUSA_ANDAR = '0') and (CHAMADOS /= "00000") then
						if (CHAMADOS < ANDAR) and flag = '1' then
							MAQUINA_ELEVADOR <= SUBINDO;						 
						else
							MAQUINA_ELEVADOR <= DESCENDO;
						end if;
					end if;
			end case;						 
		end if;
	end process;

	-- Pausa no Andar:
	process (RESETn, CLK, MAQUINA_ELEVADOR)
		variable CONTAGEM	: integer range 0 to 8000 :=0;
	begin
		if (RESETn = '0')	then
				CONTAGEM :=0;
		elsif (CLK'event and CLK = '1') then
		   if (MAQUINA_ELEVADOR = PARADO) then
				if CONTAGEM < 2000 then
					CONTAGEM := CONTAGEM + 1;
					PAUSA_ANDAR <= '1';
				else
					PAUSA_ANDAR <= '0';
				end if;
			else
				PAUSA_ANDAR <= '1';
				CONTAGEM :=0;
			end if;
		end if;
		
	end process;
	
	controla_saidas:
	with MAQUINA_ELEVADOR select
	    MOTOR <=	"10" when PARTIDA,
						"01" when SUBINDO,
						"10" when DESCENDO,
						"00" when OTHERS;

	with MAQUINA_ELEVADOR select
	    TRAVA_PORTA  <= '0' when  PARADO,
							  '1' when OTHERS;
							  
end architecture comportamento;
