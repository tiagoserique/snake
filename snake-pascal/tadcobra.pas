unit tadcobra;

interface

const
	maxTam = 1000;
type
	Tcoord = record
		x,y:integer;
		end;

	Tcobra = record
		corpo: array [1 .. maxTam] of Tcoord;
		cauda: integer;
		cabeca: Tcoord;
		end;

function limiteCorpo(var cobra:Tcobra):boolean;
//Retorna true se a cobra atingiu tamanho maximo

function naoTemCorpo(var cobra:Tcobra):boolean;
//Retorna true se a cobra nao tem corpo

function diminuiCobra(var cobra:Tcobra):Tcoord;
//Diminui a cauda da cobra para dar movimento

procedure cresceCobra(var cobra:Tcobra; val:Tcoord);
//Adiciona mais uma unidade a cauda, aumentando o tamanho da cobra

procedure moveCabeca(var cobra:Tcobra);
//Adiciona mais uma unidade na frente do corpo, para dar movimento a cobra

procedure criaCobra(var cobra:Tcobra);
//Cria a cobra

implementation


function limiteCorpo(var cobra:Tcobra):boolean;
begin
	limiteCorpo:=cobra.cauda = maxTam;
end;


function naoTemCorpo(var cobra:Tcobra):boolean;
begin
        naoTemCorpo:= cobra.cauda = 0;
end;


function diminuiCobra(var cobra:Tcobra):Tcoord;
begin
	if (not naoTemCorpo(cobra)) then
	begin
		diminuiCobra.x:=cobra.corpo[cobra.cauda].x;
		diminuiCobra.y:=cobra.corpo[cobra.cauda].y;
		cobra.cauda:=cobra.cauda-1;
	end
	else
		writeln('ERRO - Cobra sem corpo');
end;


procedure cresceCobra(var cobra:Tcobra; val:Tcoord);
begin
	if (cobra.cauda <> maxTam) then
	begin
		cobra.cauda:=cobra.cauda+1;
		cobra.corpo[cobra.cauda].x:=val.x;
		cobra.corpo[cobra.cauda].y:=val.y;
	end
	else
		writeln('ERRO - limite do corpo');
end;


procedure moveCabeca(var cobra:Tcobra);
var
	val:Tcoord;
	temp,temp2:integer;
begin
	if (not limiteCorpo(cobra)) then
	begin
		temp2:=cobra.cauda+1;
		while (cobra.cauda <> 0) do
		begin
			temp:=cobra.cauda+1;
			val:=diminuiCobra(cobra);
			cobra.corpo[temp].x:=val.x;
			cobra.corpo[temp].y:=val.y;
		end;
		cobra.cauda:=temp2;
		cobra.corpo[1].x:=cobra.cabeca.x;
		cobra.corpo[1].y:=cobra.cabeca.y;
	end;
end;

procedure criaCobra(var cobra:Tcobra);
begin
	cobra.cauda:=0;
end;

end.
