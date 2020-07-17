program snake;
uses crt, tadcobra;

const

	// Teclas de movimentacao da cobra (valores da tabela ASCII)
	ESQUERDA = #97;  // a
	DIREITA  = #100; // d
	CIMA     = #119; // w
	BAIXO    = #115; // s

    // Valores de identificacao dos componentes do jogo no tabuleiro
    BARREIRA = -1;
    VAZIO    =  0;
    CORPO    =  1;
    COMIDA   =  2;
	MAX      = 24;

type
	Tjogo = record
		campo: array [0 .. MAX+1,0 .. MAX+1] of integer;
		perdeu,comida: boolean;
		score: integer;
		posicaoDaComida: Tcoord;
	end;


function checagemNoCorpo(cobra: Tcobra; posicaoX,posicaoY: longint): boolean;
var
    unidadeDeCorpo: Tcoord;
begin
    checagemNoCorpo := false;

	while (not naoTemCorpo(cobra) and (cobra.cauda <> 1)) do
	begin
		unidadeDeCorpo := diminuiCobra(cobra);

		if ((unidadeDeCorpo.x = posicaoX) 
        and (unidadeDeCorpo.y = posicaoY)) then
            checagemNoCorpo := true;		
	end;
end;


procedure perdeu(var jogo: Tjogo; cobra: Tcobra);
begin
	if ((jogo.campo[cobra.cabeca.x, cobra.cabeca.y] = BARREIRA)) then
		jogo.perdeu := true
    else
        jogo.perdeu := checagemNoCorpo(cobra,cobra.cabeca.x,cobra.cabeca.y);
end;


procedure geraComida(var jogo: Tjogo; var cobra: Tcobra);
var
	copiaCobra: Tcobra;
	temCobraNaPosicao: boolean;
begin
	randomize;

	if (jogo.comida) then
	begin
		jogo.posicaoDaComida.x := random(MAX) + 1;
		jogo.posicaoDaComida.y := random(MAX) + 1;
		copiaCobra := cobra;
		temCobraNaPosicao := false;

        temCobraNaPosicao := checagemNoCorpo(copiaCobra,jogo.posicaoDaComida.x,jogo.posicaoDaComida.y);

		if (not temCobraNaPosicao) then
		begin
			jogo.campo[jogo.posicaoDaComida.x, jogo.posicaoDaComida.y] := COMIDA;
			jogo.comida := false;
		end
		else
			geraComida(jogo,cobra); 
	end;
end;


procedure achaComida(var jogo: Tjogo; var cobra: Tcobra);
begin
        if ((jogo.campo[cobra.cabeca.x,cobra.cabeca.y] = COMIDA)) then
        begin
                jogo.campo[jogo.posicaoDaComida.x,jogo.posicaoDaComida.y] := VAZIO;
                jogo.comida := true;
                jogo.score := jogo.score + 1000;
                cobra.cauda := cobra.cauda + 1;
        end;
        geraComida(jogo,cobra);
end;


procedure movimenta(var cobra: Tcobra);
begin
	diminuiCobra(cobra);
	moveCabeca(cobra);
end;


procedure direcao(var cobra: Tcobra; var direcaoAtual,direcaoAnterior: char);
begin
	if (direcaoAtual = ESQUERDA) and (direcaoAnterior <> DIREITA) then
	begin
		cobra.cabeca.y := cobra.cabeca.y - 1;
		direcaoAnterior := direcaoAtual;
	end
	else if (direcaoAtual = DIREITA) and (direcaoAnterior <> ESQUERDA) then
	begin
		cobra.cabeca.y := cobra.cabeca.y + 1;
		direcaoAnterior := direcaoAtual;
	end
	else if (direcaoAtual = CIMA) and (direcaoAnterior <> BAIXO) then
	begin
		cobra.cabeca.x := cobra.cabeca.x - 1;
		direcaoAnterior := direcaoAtual;
	end
	else if (direcaoAtual = BAIXO) and (direcaoAnterior <> CIMA) then
	begin
		cobra.cabeca.x := cobra.cabeca.x + 1;
		direcaoAnterior := direcaoAtual;
	end;
	movimenta(cobra);
end;


procedure mostraJogo(var jogo: Tjogo; cobra: Tcobra);
var
	copiaJogo: Tjogo;
	i,j: integer;
	unidadeDeCorpo: Tcoord;
begin
	copiaJogo := jogo;

	while (not naoTemCorpo(cobra)) do
	begin
		unidadeDeCorpo := diminuiCobra(cobra);
		copiaJogo.campo[unidadeDeCorpo.x,unidadeDeCorpo.y] := CORPO;
	end;


	for i:=0 to MAX+1 do
	begin
		for j:=0 to MAX+1 do
		begin

			if (copiaJogo.campo[i,j] = BARREIRA) then
				write(' # ')
			else if (copiaJogo.campo[i,j] = CORPO) then
				write(' x ')
			else if (copiaJogo.campo[i,j] = COMIDA) then
                                write(' O ')
			else
				write('   ');
		end;
		writeln;
	end;
	writeln;
end;


procedure iniciaJogo(var jogo: Tjogo; var cobra: Tcobra; var proximaDirecao,direcaoAnterior: char);
var
	i,j: integer;
	unidadeDeCorpo: Tcoord;
begin
	for i:=0 to MAX+1 do
		for j:=0 to MAX+1 do
		begin

			if ((i <> 0) 
            and (j <> 0) 
            and (i <> MAX + 1) 
            and (j <> MAX + 1)) then
				jogo.campo[i,j] := VAZIO
			else
				jogo.campo[i,j] := BARREIRA;
		end;

	jogo.score := 0;
	jogo.perdeu := false;
	jogo.comida := true;
	
	proximaDirecao := #100;
	direcaoAnterior := #100;
	
	criaCobra(cobra);
	cobra.cabeca.x := (MAX + 2) div 2;
	cobra.cabeca.y := cobra.cabeca.x;
	unidadeDeCorpo.x := cobra.cabeca.x;
	unidadeDeCorpo.y := cobra.cabeca.y;
	cresceCobra(cobra,unidadeDeCorpo);

	geraComida(jogo,cobra);
end;


var
	jogo: Tjogo;
	proximaDirecao,direcaoAnterior: char;
	cobra: Tcobra;
begin
	iniciaJogo(jogo,cobra,proximaDirecao,direcaoAnterior);

	while (not jogo.perdeu) do
	begin
		mostraJogo(jogo,cobra);

		if (not keypressed) then
			direcao(cobra,proximaDirecao,direcaoAnterior)
		else
		begin
			proximaDirecao := readKey;

			if ((proximaDirecao = ESQUERDA) 
            or (proximaDirecao = DIREITA) 
            or (proximaDirecao = CIMA) 
            or (proximaDirecao = BAIXO)) then
				direcao(cobra,proximaDirecao,direcaoAnterior)
			else
				direcao(cobra,direcaoAnterior,direcaoAnterior);
		end;

		achaComida(jogo,cobra);
	    perdeu(jogo,cobra);
		mostraJogo(jogo,cobra);
		delay(150);
	end;

        if (jogo.perdeu) then
        begin
                writeln('PERDEU !!!!!');
                writeln('PONTUACAO: ',jogo.score);
        end;
end.
