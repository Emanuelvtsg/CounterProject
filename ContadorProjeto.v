module ContadorProjeto (Key0, Key1, Key2, Key3, clk, Display0, Display1, Display2, Display3);

input Key0, Key1, Key2, Key3, clk;
output Display0, Display1, Display2, Display3;
reg[3:0] Display0, Display1, Display2, Display3;


parameter[2:0] Default = 3'd0, Esp_solt = 3'd1, Conta = 3'd2, Pausa = 3'd3, Para = 3'd4, Esp_despaus = 3'd5; 
/* Na linha acima cada estado recebe uma numeração de acordo. Esp_solt é o estado que espera o
botão que foi para nível lógico 0 voltar para 1 (espera para soltar), Esp_despaus é o estado que
espera o nível lógico do Key1 voltar para 1 e recomeçar a contagem (espera para despausar). */

reg[2:0] Estado_ant, Estado;
reg[3:0] Cont0, Cont1, Cont2, Cont3, Bgnd0, Bgnd1, Bgnd2, Bgnd3;
reg[2:0] Botao_apertd;
/* Essas variáveis serão utilizadas para: ContX = contagem, BgndX = contagem em background,
Estado_ant é o estado anterior no qual o circuito estava, Estado é o estado atual, Botao_apertd
armazena uma informação que se refere ao último botão que foi pressionado. Inicialmente, Botao_apertd
terá um valor diferente(3'd4) dos que serão possíveis quando algum botão for apertado (0 para botão
0, 1 para botão 1, e assim segue), apenas para garantir que ele não comece em um deles e ocorra
uma troca de estados errada.*/

initial begin
	Estado <= Default;
	Estado_ant <= Default;
	Botao_apertd <= 3'd4;
	Cont0 <= 4'd0;
	Cont1 <= 4'd0;
	Cont2 <= 4'd0;
	Cont3 <= 4'd0;
	Bgnd0 <= 4'd0;
	Bgnd1 <= 4'd0;
	Bgnd2 <= 4'd0;
	Bgnd3 <= 4'd0;
end 

always@(posedge clk) begin //Esse always atualiza os valores das variáveis de contagem para cada estado.
	if(clk && Estado == Default) begin
		Cont0 <= 4'd0;
		Cont1 <= 4'd0;
		Cont2 <= 4'd0;
		Cont3 <= 4'd0;
		Bgnd0 <= 4'd0;
		Bgnd1 <= 4'd0;
		Bgnd2 <= 4'd0;
		Bgnd3 <= 4'd0;
	end

	else if(clk && Estado == Esp_solt) begin 
	/*Se o estado for o de esperar soltar, as variáveis de contagem nele se comportarão de acordo
	com o estado que o circuito estava anteriormente, já que antes do botão ser efetivamente
	apertado, nada mudará, então ele continuará fazendo a mesma coisa que o estado anterior a ele fazia. */
		if(Estado_ant == Default) begin
			Cont0 <= 4'd0;
			Cont1 <= 4'd0;
			Cont2 <= 4'd0;
			Cont3 <= 4'd0;
			Bgnd0 <= 4'd0;
			Bgnd1 <= 4'd0;
			Bgnd2 <= 4'd0;
			Bgnd3 <= 4'd0;
		end

		else if(Estado_ant == Conta) begin
			if(Cont0 == 4'd9) begin
				Cont0 <= 4'd0;
				Bgnd0 <= 4'd0;
				Cont1 <= Bgnd1 + 4'd1;
				Bgnd1 <= Bgnd1 + 4'd1;
			end
			else begin
				Cont0 <= Bgnd0 + 4'd1;
				/* O Cont0 contará com base no Bgnd0 para previnir uma situação do tipo
				Conta-Pausa-Conta que faria com que os ContX ficassem atrasados em relação
				aos BgndX, já que no estado de Pausa os BgndX continuam a contagem, e o ContX fica
				pausado; dessa forma, os ContX no estado Conta serão sempre iguais aos BgndX. */
				Bgnd0 <= Bgnd0 + 4'd1;
			end
			if(Cont1 == 4'd9) begin
				if(Cont0 == 4'd9) begin
					Cont1 <= 4'd0;
					Bgnd1 <= 4'd0;
					Cont2 <= Bgnd2 + 4'd1;
					Bgnd2 <= Bgnd2 + 4'd1;
				end
			end
			if(Cont2 == 4'd9) begin
				if(Cont1 == 4'd9) begin
					if(Cont0 == 4'd9) begin
						Cont2 <= 4'd0;
						Bgnd2 <= 4'd0;
						Cont3 <= Bgnd3 + 4'd1;
						Bgnd3 <= Bgnd3 + 4'd1;
					end
				end
			end
			if(Cont3 == 4'd9) begin
				if(Cont2 == 4'd9) begin
					if(Cont1 == 4'd9) begin
						if(Cont0 == 4'd9) begin
							Cont3 <= 4'd0;
							Bgnd3 <= 4'd0;
						end
					end
				end
			end
		end
	
		else if(Estado_ant == Pausa) begin
			Cont0 <= Cont0;
			Cont1 <= Cont1;
			Cont2 <= Cont2;
			Cont3 <= Cont3;
			if(Bgnd0 == 4'd9) begin
				Bgnd0 <= 4'd0;
				Bgnd1 <= Bgnd1 + 4'd1;
			end
			else begin
				Bgnd0 <= Bgnd0 + 4'd1;
			end
			if(Bgnd1 == 4'd9) begin
				if(Bgnd0 == 4'd9) begin
					Bgnd1 <= 4'd0;
					Bgnd2 <= Bgnd2 + 4'd1;
				end
			end
			if(Bgnd2 == 4'd9) begin
				if(Bgnd1 == 4'd9) begin
					if(Bgnd0 == 4'd9) begin
						Bgnd2 <= 4'd0;
						Bgnd3 <= Bgnd3 + 4'd1;
					end
				end
			end
			if(Bgnd3 == 4'd9) begin
				if(Bgnd2 == 4'd9) begin
					if(Bgnd1 == 4'd9) begin
						if(Bgnd0 == 4'd9) begin
							Bgnd3 <= 4'd0;
						end
					end
				end
			end
		end

		else if(Estado_ant == Para) begin
			Cont0 <= Cont0;
			Cont1 <= Cont1;
			Cont2 <= Cont2;
			Cont3 <= Cont3;
			Bgnd0 <= Bgnd0;
			Bgnd1 <= Bgnd1;
			Bgnd2 <= Bgnd2;        
			Bgnd3 <= Bgnd3;        
		end
	end

	else if(clk && Estado == Conta) begin
		if(Cont0 == 4'd9) begin
			Cont0 <= 4'd0;
			Bgnd0 <= 4'd0;
			Cont1 <= Bgnd1 + 4'd1;
			Bgnd1 <= Bgnd1 + 4'd1;
		end
		else begin
			Cont0 <= Bgnd0 + 4'd1;
			Bgnd0 <= Bgnd0 + 4'd1;
		end
		if(Cont1 == 4'd9) begin
			if(Cont0 == 4'd9) begin
				Cont1 <= 4'd0;
				Bgnd1 <= 4'd0;
				Cont2 <= Bgnd2 + 4'd1;
				Bgnd2 <= Bgnd2 + 4'd1;
			end
		end
		if(Cont2 == 4'd9) begin
			if(Cont1 == 4'd9) begin
				if(Cont0 == 4'd9) begin
					Cont2 <= 4'd0;
					Bgnd2 <= 4'd0;
					Cont3 <= Bgnd3 + 4'd1;
					Bgnd3 <= Bgnd3 + 4'd1;
				end
			end
		end
		if(Cont3 == 4'd9) begin
			if(Cont2 == 4'd9) begin
				if(Cont1 == 4'd9) begin
					if(Cont0 == 4'd9) begin
						Cont3 <= 4'd0;
						Bgnd3 <= 4'd0;
					end
				end
			end
		end
	end

	else if(clk && Estado == Pausa) begin
		Cont0 <= Cont0;
		Cont1 <= Cont1;
		Cont2 <= Cont2;
		Cont3 <= Cont3;
		if(Bgnd0 == 4'd9) begin
			Bgnd0 <= 4'd0;
			Bgnd1 <= Bgnd1 + 4'd1;
		end
		else begin
			Bgnd0 <= Bgnd0 + 4'd1;
		end
		if(Bgnd1 == 4'd9) begin
			if(Bgnd0 == 4'd9) begin
				Bgnd1 <= 4'd0;
				Bgnd2 <= Bgnd2 + 4'd1;
			end
		end
		if(Bgnd2 == 4'd9) begin
			if(Bgnd1 == 4'd9) begin
				if(Bgnd0 == 4'd9) begin
					Bgnd2 <= 4'd0;
					Bgnd3 <= Bgnd3 + 4'd1;
				end
			end
		end
		if(Bgnd3 == 4'd9) begin
			if(Bgnd2 == 4'd9) begin
				if(Bgnd1 == 4'd9) begin
					if(Bgnd0 == 4'd9) begin
						Bgnd3 <= 4'd0;
					end
				end
			end
		end
	end

	else if(clk && Estado == Para) begin
		Cont0 <= Cont0;
		Cont1 <= Cont1;
		Cont2 <= Cont2;
		Cont3 <= Cont3;
		Bgnd0 <= Bgnd0;
		Bgnd1 <= Bgnd1;
		Bgnd2 <= Bgnd2;        
		Bgnd3 <= Bgnd3;   
	end

	else if(clk && Estado == Esp_despaus) begin
	/* Esse estado é semelhante ao de espera soltar, mas funciona apenas para quando o estado
	anterior é o de Pausa, portanto, ele continua fazendo as mesmas coisas que o Pausa faz. */
		Cont0 <= Cont0;
		Cont1 <= Cont1;
		Cont2 <= Cont2;
		Cont3 <= Cont3;
		if(Bgnd0 == 4'd9) begin
			Bgnd0 <= 4'd0;
			Bgnd1 <= Bgnd1 + 4'd1;
		end
		else begin
			Bgnd0 <= Bgnd0 + 4'd1;
		end
		if(Bgnd1 == 4'd9) begin
			if(Bgnd0 == 4'd9) begin
				Bgnd1 <= 4'd0;
				Bgnd2 <= Bgnd2 + 4'd1;
			end
		end
		if(Bgnd2 == 4'd9) begin
			if(Bgnd1 == 4'd9) begin
				if(Bgnd0 == 4'd9) begin
					Bgnd2 <= 4'd0;
					Bgnd3 <= Bgnd3 + 4'd1;
				end
			end
		end
		if(Bgnd3 == 4'd9) begin
			if(Bgnd2 == 4'd9) begin
				if(Bgnd1 == 4'd9) begin
					if(Bgnd0 == 4'd9) begin
						Bgnd3 <= 4'd0;
					end
				end
			end
		end
	end
end

always@(Key0, Key1, Key2, Key3) begin
	/* Esse always trabalha com as transições de estado para quando um botão vai para nível lógico
	0 e para quando ele volta para 1, mudando para o estado necessário. */
	if(~Key0) begin
		Botao_apertd <= 3'd0;
	end
	else if(~Key1) begin
		Botao_apertd <= 3'd1;
	end
	else if(~Key2) begin
		Botao_apertd <= 3'd2;
	end
	else if(~Key3) begin
		Botao_apertd <= 3'd3;
	end
	/* Essa sequência de ifs acima serviu para armazenar na variável Botao_apertd o valor referente
	ao botão apertado no momento. */
	
	/* Dentro do if abaixo serão feitas as trocas para os estados de espera quando alguma Key
	for para 0. */
	if(~Key0 || ~Key1 || ~Key2 || ~Key3) begin
		if(Estado == Default) begin
			Estado_ant <= Default;
			Estado <= Esp_solt;
		end
		else if(Estado == Conta) begin
			Estado_ant <= Conta;
			Estado <= Esp_solt;
		end
		else if(Estado == Pausa) begin
			if(~Key0 || ~Key3)begin
				Estado_ant <= Pausa;
				Estado <= Esp_solt;
			end
			if(~Key1) begin
				Estado_ant <= Pausa;
				Estado <= Esp_despaus;
			end
		/* Os 2 ifs acima são para identificar se o cronômetro está pausado e será resetado/parado
			ou se voltará a contar, despausando */
		end
		else if(Estado == Para) begin
			Estado_ant <= Para;
			Estado <= Esp_solt;
		end
	end
	
	/* O if a seguir opera quando todas as entradas estiverem em 1 e o Botao_apertd tiver algum
	valor válido já atribuído, e então serão feitas as devidas trocas de estados; os ifs dentro dele
	operam as trocas de estados de acordo com o botão que foi apertado e o estado atual. */
	if(Key0 && Key1 && Key2 && Key3) begin
		if(Botao_apertd == 3'd0) begin
			Estado <= Para;
			Estado_ant <= Esp_solt;
		end
		else if(Botao_apertd == 3'd1 && Estado == Esp_solt) begin
			Estado <= Pausa;
			Estado_ant <= Esp_solt;
		end
		else if(Botao_apertd == 3'd1 && Estado == Esp_despaus) begin
			Estado <= Conta;
			Estado_ant <= Esp_despaus;
		end
			/* Nos 2 else if acima foi necessária fazer a distinção entre se é necessário pausar o
		circuito ou se ele já estava pausado e precisa retomar a contagem. */
		else if(Botao_apertd == 3'd2) begin
			Estado <= Conta;
			Estado_ant <= Esp_solt;
		end
		else if(Botao_apertd == 3'd3) begin
			Estado <= Default;
			Estado_ant <= Esp_solt;
		end
		else if (Botao_apertd == 3'd4) begin
			Estado <= Default;
			Estado_ant <= Default;
		end
		/* O else if imediatamente acima é apenas para garantir que o valor inicial de Botao_apertd
		que está no bloco de initial, 3'd4, trabalha com os estados também nos seus valores iniciais,
		em Default. */
	end
end

always@(*) begin
	// Esse é o always que opera atribuindo para cada estado a sua saída.
	case(Estado)
		Default: begin
			Display0 <= 3'd0;
			Display1 <= 3'd0;
			Display2 <= 3'd0;
			Display3 <= 3'd0;
		end

		Esp_solt: begin
			if(Estado_ant == Default) begin
				Display0 <= 3'd0;
				Display1 <= 3'd0;
				Display2 <= 3'd0;
				Display3 <= 3'd0;
			end

			else if(Estado_ant == Conta) begin
				Display0 <= Bgnd0;
				Display1 <= Bgnd1;
				Display2 <= Bgnd2;
				Display3 <= Bgnd3;
			end

			else if(Estado_ant == Pausa) begin
				Display0 <= Cont0;
				Display1 <= Cont1;
				Display2 <= Cont2;
				Display3 <= Cont3;
			end

			else if(Estado_ant == Para) begin
				Display0 <= Bgnd0;
				Display1 <= Bgnd1;
				Display2 <= Bgnd2;
				Display3 <= Bgnd3;
			end
		end

		Conta: begin
			Display0 <= Bgnd0;
			Display1 <= Bgnd1;
			Display2 <= Bgnd2;
			Display3 <= Bgnd3;
		end

		Pausa: begin
			Display0 <= Cont0;
			Display1 <= Cont1;
			Display2 <= Cont2;
			Display3 <= Cont3;
		end

		Para: begin
			Display0 <= Bgnd0;
			Display1 <= Bgnd1;
			Display2 <= Bgnd2;
			Display3 <= Bgnd3;
		end

		Esp_despaus: begin
			Display0 <= Cont0;
			Display1 <= Cont1;
			Display2 <= Cont2;
			Display3 <= Cont3;
		end
		
		default: begin
			Display0 <= 3'd0;
			Display1 <= 3'd0;
			Display2 <= 3'd0;
			Display3 <= 3'd0;
		end
	endcase
end

endmodule