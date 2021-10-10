% Leitura inicial dos dados
prompt = 'Digite o nome do arquivo - ';
fname = input(prompt, 's');
fid = fopen(fname, 'r');
netlist = textscan(fid, '%s');
fclose(fid);

% Inicializa��o
num_R = 0;
num_V = 0;
num_I = 0;
num_Nodes = 0; % N�mero de n�s, excluindo o terra (n� 0)
num_VCVS = 0; % Voltage Controlled Voltage Sources
num_VCCS = 0; % Voltage Controlled Current Sources
num_CCVS = 0; % Current Controlled Voltage Sources
num_CCCS = 0; % Current Controlled Current Sources

% Cria a estrutura de Resistores
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'R'}          
          R(inicio, 1) = cellstr(netlist{1}{indice});
          R(inicio, 2) = cellstr(netlist{1}{indice+1});
          R(inicio, 3) = cellstr(netlist{1}{indice+2});
          R(inicio, 4) = cellstr(netlist{1}{indice+3});
          inicio++;          
    end    
end
num_R = size(R)(1); % N�mero de R

% Cria a estrutura de Fontes de Corrente Independentes
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'I'}          
          Currents(inicio, 1) = cellstr(netlist{1}{indice});
          Currents(inicio, 2) = cellstr(netlist{1}{indice+1});
          Currents(inicio, 3) = cellstr(netlist{1}{indice+2});
          Currents(inicio, 4) = cellstr(netlist{1}{indice+3});
          inicio++;          
    end    
end

if exist("Currents")
  num_I = size(Currents)(1); % N�mero de I
else
  num_I = 0;
end

% Cria a estrutura de Fontes de Corrente controladas por tens�o
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'G'}          
          VCCS(inicio, 1) = cellstr(netlist{1}{indice});
          VCCS(inicio, 2) = cellstr(netlist{1}{indice+1});
          VCCS(inicio, 3) = cellstr(netlist{1}{indice+2});
          VCCS(inicio, 4) = cellstr(netlist{1}{indice+3});
          VCCS(inicio, 5) = cellstr(netlist{1}{indice+4});
          VCCS(inicio, 6) = cellstr(netlist{1}{indice+5});
          inicio++;          
    end    
end  

if exist("VCCS")
  num_VCCS = size(VCCS)(1); % N�mero de G
else
  num_VCCS = 0;
end

% Descobre o n�mero de n�s
for indice = 1:length(netlist{1})
  s = netlist{1}{indice};  
  switch(s(1))
    case{'R', 'V', 'I', 'G', 'E', 'F', 'H'}
      maior = str2num(netlist{1}{indice+1});
      menor = str2num(netlist{1}{indice+2});  
      
      if (menor > maior)
        maior = menor;
      end
      
      if (maior > num_Nodes)
        num_Nodes = maior;
      end    
  end 
end

% Cria a matriz Gm zerada acrescentando o n� terra no in�cio
Gm = zeros(num_Nodes + 1); 
% Cria o vetor in zerado acrescentando o n� terra no in�cio
in = zeros(num_Nodes + 1, 1);

% Preenche a matriz Gm com as condut�ncias
for indice = 1:num_R
  linha = str2num(R{indice,2}) + 1;
  coluna = str2num(R{indice,3}) + 1;
  condutancia = 1/str2num(R{indice,4});
  
  Gm(linha,linha) += condutancia;
  Gm(coluna,coluna) += condutancia;  
  Gm(linha,coluna) -= condutancia;
  Gm(coluna,linha) -= condutancia; 
end

% Preenche a matriz Gm com as transcondut�ncias
for indice = 1:num_VCCS
  saindo = str2num(VCCS{indice,2}) + 1;
  entrando = str2num(VCCS{indice,3}) + 1;
  positivo = str2num(VCCS{indice,4}) + 1;
  negativo = str2num(VCCS{indice,5}) + 1;
  transcondutancia = str2num(VCCS{indice,6});  
   
  Gm(saindo,positivo) += transcondutancia;
  Gm(saindo,negativo) += -transcondutancia;
  Gm(entrando,positivo) += -transcondutancia;
  Gm(entrando,negativo) += transcondutancia;
end

% Preenche a matriz in com as fontes de corrente ligadas aos n�s
for indice = 1:num_I
  saindo = str2num(Currents{indice,2}) + 1;
  entrando = str2num(Currents{indice,3}) + 1;
  valorAbsoluto = str2num(Currents{indice,4});
  
  in(saindo) += -valorAbsoluto;
  in(entrando) += valorAbsoluto;
end

% Elimina o n� 0 da matriz Gm
Gm(1,:) = [];
Gm(:,1) = [];

% Elimina o n� 0 do vetor in
in(1,:) = [];

% Calcula o resultado
resultado = inv(Gm)*in;

disp("\nTens�es nodais encontradas: ");
for indice = 1:num_Nodes
  printf("\tv%d = %d\n", indice, resultado(indice));
end