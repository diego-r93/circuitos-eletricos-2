% Leitura inicial dos dados
prompt = 'Digite o nome do arquivo - ';
fname = input(prompt, 's');
fid = fopen(fname, 'r');
netlist = textscan(fid, '%s');
fclose(fid);

% Inicialização
num_R = 0;
num_C = 0;
num_L = 0;
num_K = 0; % Número de transformadores ideiais
num_V = 0;
num_I = 0;
num_Nodes = 0; % Número de nós, excluindo o terra (nó 0)
num_VCVS = 0; % Voltage Controlled Voltage Sources
num_VCCS = 0; % Voltage Controlled Current Sources
num_CCVS = 0; % Current Controlled Voltage Sources
num_CCCS = 0; % Current Controlled Current Sources
num_OpAmp = 0; % Número de Amplificadores Operacionais
frequency = 0; % Frequência

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

if exist("R")
  num_R = size(R)(1); % Número de Resistores
else
  num_R = 0;
end

% Cria a estrutura de Capacitores
inicio = 1;
for indice = 1:length(netlist{1})
  s = netlist{1}{indice};
  switch(s(1))    
    case{'C'}
      if strcmp(netlist{1}{indice}, 'COS') == 0    
      Capacitors(inicio, 1) = cellstr(netlist{1}{indice});
      Capacitors(inicio, 2) = cellstr(netlist{1}{indice+1});
      Capacitors(inicio, 3) = cellstr(netlist{1}{indice+2});
      Capacitors(inicio, 4) = cellstr(netlist{1}{indice+3});
      inicio++;
      end      
  end    
end

if exist("Capacitors")
  num_C = size(Capacitors)(1); % Número de Capacitores
else
  num_C = 0;
end  

% Cria a estrutura de Indutores
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'L', 'X'}          
          Inductors(inicio, 1) = cellstr(netlist{1}{indice});
          Inductors(inicio, 2) = cellstr(netlist{1}{indice+1});
          Inductors(inicio, 3) = cellstr(netlist{1}{indice+2});
          Inductors(inicio, 4) = cellstr(netlist{1}{indice+3});
          inicio++;          
    end    
end

if exist("Inductors")
  num_L = size(Inductors)(1); % Número de Indutores
else
  num_L = 0;
end

% Cria a estrutura de Transformadores Ideais
inicio = 1;
for indice = 1:length(netlist{1})
  s = netlist{1}{indice};
  switch(s(1))    
    case{'K'}      
      Transformers(inicio, 1) = cellstr(netlist{1}{indice});
      Transformers(inicio, 2) = cellstr(netlist{1}{indice+1});
      Transformers(inicio, 3) = cellstr(netlist{1}{indice+2});
      Transformers(inicio, 4) = cellstr(netlist{1}{indice+3});
      Transformers(inicio, 5) = cellstr(netlist{1}{indice+4});
      Transformers(inicio, 6) = cellstr(netlist{1}{indice+5});
      inicio++;           
  end    
end

if exist("Transformers")
  num_K = size(Transformers)(1); % Número de Transformadores Ideais
else
  num_K = 0;
end  

% Cria a estrutura de Fontes de Tensão Independentes
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'V'}          
          Voltages(inicio, 1) = cellstr(netlist{1}{indice});
          Voltages(inicio, 2) = cellstr(netlist{1}{indice+1});
          Voltages(inicio, 3) = cellstr(netlist{1}{indice+2});
          Voltages(inicio, 4) = cellstr(netlist{1}{indice+3});
          if strcmp(Voltages{inicio, 4},'DC')
            Voltages(inicio, 5) = cellstr(netlist{1}{indice+4});
          else
            Voltages(inicio, 5) = cellstr(netlist{1}{indice+4});
            Voltages(inicio, 6) = cellstr(netlist{1}{indice+5});
            Voltages(inicio, 7) = cellstr(netlist{1}{indice+6});
            frequency = str2num(Voltages{inicio, 7});
            Voltages(inicio, 8) = cellstr(netlist{1}{indice+7});
            Voltages(inicio, 9) = cellstr(netlist{1}{indice+8});
            Voltages(inicio, 10) = cellstr(netlist{1}{indice+9});
            Voltages(inicio, 11) = cellstr(netlist{1}{indice+10});
          endif          
          inicio++;          
    end    
end

if exist("Voltages")
  num_V = size(Voltages)(1); % Número de V
else
  num_V = 0;
end  

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
          if strcmp(Currents{inicio, 4},'DC')
            Currents(inicio, 5) = cellstr(netlist{1}{indice+4});
          else
            Currents(inicio, 5) = cellstr(netlist{1}{indice+4});
            Currents(inicio, 6) = cellstr(netlist{1}{indice+5});
            Currents(inicio, 7) = cellstr(netlist{1}{indice+6});
            frequency = str2num(Currents{inicio, 7});
            Currents(inicio, 8) = cellstr(netlist{1}{indice+7});
            Currents(inicio, 9) = cellstr(netlist{1}{indice+8});
            Currents(inicio, 10) = cellstr(netlist{1}{indice+9});
            Currents(inicio, 11) = cellstr(netlist{1}{indice+10});
          endif          
          inicio++;          
    end    
end

if exist("Currents")
  num_I = size(Currents)(1); % Número de I
else
  num_I = 0;
end

% Cria a estrutura de Fontes de Tensão controladas por tensão (VCVS)
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'A','E'}          
          VCVS(inicio, 1) = cellstr(netlist{1}{indice});
          VCVS(inicio, 2) = cellstr(netlist{1}{indice+1});
          VCVS(inicio, 3) = cellstr(netlist{1}{indice+2});
          VCVS(inicio, 4) = cellstr(netlist{1}{indice+3});
          VCVS(inicio, 5) = cellstr(netlist{1}{indice+4});
          VCVS(inicio, 6) = cellstr(netlist{1}{indice+5});
          inicio++;          
    end    
end  

if exist("VCVS")
  num_VCVS = size(VCVS)(1); % Número de E
else
  num_VCVS = 0;
end

omega = frequency; % Frequência em radiandos

% Cria a estrutura de Fontes de Corrente controladas por tensão (VCCS)
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
  num_VCCS = size(VCCS)(1); % Número de G
else
  num_VCCS = 0;
end

% Cria a estrutura de Fontes de Corrente controladas por tensão (CCVS)
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'H'}          
          CCVS(inicio, 1) = cellstr(netlist{1}{indice});
          CCVS(inicio, 2) = cellstr(netlist{1}{indice+1});
          CCVS(inicio, 3) = cellstr(netlist{1}{indice+2});
          CCVS(inicio, 4) = cellstr(netlist{1}{indice+3});
          CCVS(inicio, 5) = cellstr(netlist{1}{indice+4});
          CCVS(inicio, 6) = cellstr(netlist{1}{indice+5});
          inicio++;          
    end    
end  

if exist("CCVS")
  num_CCVS = size(CCVS)(1); % Número de H
else
  num_CCVS = 0;
end

% Cria a estrutura de Fontes de Corrente controladas por tensão (CCCS)
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'B','F'}          
          CCCS(inicio, 1) = cellstr(netlist{1}{indice});
          CCCS(inicio, 2) = cellstr(netlist{1}{indice+1});
          CCCS(inicio, 3) = cellstr(netlist{1}{indice+2});
          CCCS(inicio, 4) = cellstr(netlist{1}{indice+3});
          CCCS(inicio, 5) = cellstr(netlist{1}{indice+4});
          CCCS(inicio, 6) = cellstr(netlist{1}{indice+5});
          inicio++;          
    end    
end  

if exist("CCCS")
  num_CCCS = size(CCCS)(1); % Número de F
else
  num_CCCS = 0;
end

% Cria a estrutura de Amplificadores Operacionais
inicio = 1;
for indice = 1:length(netlist{1})
    s = netlist{1}{indice};
    switch(s(1))
        case{'O'}          
          OpAmp(inicio, 1) = cellstr(netlist{1}{indice});
          OpAmp(inicio, 2) = cellstr(netlist{1}{indice+1});
          OpAmp(inicio, 3) = cellstr(netlist{1}{indice+2});
          OpAmp(inicio, 4) = cellstr(netlist{1}{indice+3});
          OpAmp(inicio, 5) = cellstr(netlist{1}{indice+4});
          inicio++;          
    end    
end

if exist("OpAmp")
  num_OpAmp = size(OpAmp)(1); % Número de Amplificadores Operacionais
else
  num_OpAmp = 0;
end  

% Descobre o número de nós
for indice = 1:length(netlist{1})
  s = netlist{1}{indice};  
  switch(s(1))
    case{'R', 'C', 'L', 'V', 'I', 'G', 'A', 'E', 'B', 'F', 'H', 'O', 'K'}
    if strcmp(s, 'COS') == 0
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
end

% Cria a matriz Gm zerada acrescentando o nó terra no início
Gm = zeros(num_Nodes + 1); 
% Cria o vetor in zerado acrescentando o nó terra no início
in = zeros(num_Nodes + 1, 1);

% Preenche a matriz Gm com as impedâncias
% Resistores
for indice = 1:num_R
  linha = str2num(R{indice,2}) + 1;
  coluna = str2num(R{indice,3}) + 1;
  condutancia = 1/str2num(R{indice,4});
  
  Gm(linha,linha) += condutancia;
  Gm(coluna,coluna) += condutancia;  
  Gm(linha,coluna) -= condutancia;
  Gm(coluna,linha) -= condutancia; 
end
% Capacitores
for indice = 1:num_C
  linha = str2num(Capacitors{indice,2}) + 1;
  coluna = str2num(Capacitors{indice,3}) + 1;
  impedancia = j*omega*str2num(Capacitors{indice,4});
  
  Gm(linha,linha) += impedancia;
  Gm(coluna,coluna) += impedancia;  
  Gm(linha,coluna) -= impedancia;
  Gm(coluna,linha) -= impedancia;
end
% Indutores
for indice = 1:num_L
  linha = str2num(Inductors{indice,2}) + 1;
  coluna = str2num(Inductors{indice,3}) + 1;
  impedancia = 1/(j*omega*str2num(Inductors{indice,4}));
  
  Gm(linha,linha) += impedancia;
  Gm(coluna,coluna) += impedancia;  
  Gm(linha,coluna) -= impedancia;
  Gm(coluna,linha) -= impedancia;
end    

% Preenche a matriz Gm com as transcondutâncias (VCCS)
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

% Preenche a matriz in com as fontes de corrente independentes
for indice = 1:num_I
  saindo = str2num(Currents{indice,2}) + 1;
  entrando = str2num(Currents{indice,3}) + 1;
  if strcmp(Currents{indice, 4},'DC')
    corrente = str2num(Currents{indice,5});
  else
    corrente = str2num(Currents{indice,6});
  endif
  
  
  in(saindo) += -corrente;
  in(entrando) += corrente;  
end

% Preenche a matriz Gm e o vetor in com as fontes de tensão independentes
for indice = 1:num_V
  positivo = str2num(Voltages{indice,2}) + 1;
  negativo = str2num(Voltages{indice,3}) + 1;
  if strcmp(Voltages{indice, 4},'DC')
    tensao = str2num(Voltages{indice,5});
  else
    tensao = str2num(Voltages{indice,6});
  endif
    
  % Aumenta a dimensão com zeros
  Gm = [Gm, zeros(size(Gm)(1),1)];
  Gm = [Gm; zeros(1,size(Gm)(2))];
  in = [in; 0];
  % Acrescenta a estampa de V
  Gm(positivo, size(Gm)(2)) += 1;
  Gm(negativo, size(Gm)(2)) += -1;
  Gm(size(Gm)(1), positivo) += -1;
  Gm(size(Gm)(1), negativo) += 1;
  in(size(in)) += -tensao;
end

% Preenche a matriz Gm e o vetor in com os Amps. de tensão (VCVS)
for indice = 1:num_VCVS
  positivo = str2num(VCVS{indice,2}) + 1;
  negativo = str2num(VCVS{indice,3}) + 1;
  referencia_positiva = str2num(VCVS{indice,4}) + 1;
  referencia_negativa = str2num(VCVS{indice,5}) + 1;
  ganho_de_tensao = str2num(VCVS{indice,6});
  % Aumenta a dimensão com zeros
  Gm = [Gm, zeros(size(Gm)(1),1)];
  Gm = [Gm; zeros(1,size(Gm)(2))];
  in = [in; 0];
  % Acrescenta a estampa de E
  Gm(positivo, size(Gm)(2)) += 1;
  Gm(negativo, size(Gm)(2)) += -1;
  Gm(size(Gm)(1), positivo) += -1;
  Gm(size(Gm)(1), negativo) += 1;
  Gm(size(Gm)(1), referencia_positiva) += ganho_de_tensao;
  Gm(size(Gm)(1), referencia_negativa) += -ganho_de_tensao;
end 

% Preenche a matriz Gm e o vetor in com os Amps. de corrente (CCCS)
for indice = 1:num_CCCS
  saindo = str2num(CCCS{indice,2}) + 1;
  entrando = str2num(CCCS{indice,3}) + 1;
  referencia_saindo = str2num(CCCS{indice,4}) + 1;
  referencia_entrando = str2num(CCCS{indice,5}) + 1;
  ganho_de_corrente = str2num(CCCS{indice,6});
  % Aumenta a dimensão com zeros
  Gm = [Gm, zeros(size(Gm)(1),1)];
  Gm = [Gm; zeros(1,size(Gm)(2))];
  in = [in; 0];
  % Acrescenta a estampa de F
  Gm(saindo, size(Gm)(2)) += ganho_de_corrente;
  Gm(entrando, size(Gm)(2)) += -ganho_de_corrente;
  Gm(referencia_saindo, size(Gm)(2)) += 1;
  Gm(referencia_entrando, size(Gm)(2)) += -1;
  Gm(size(Gm)(1), referencia_saindo) += -1;
  Gm(size(Gm)(1), referencia_entrando) += 1;
end 

% Preenche a matriz Gm e o vetor in com as transresistências CCVS)
for indice = 1:num_CCVS
  positivo = str2num(CCVS{indice,2}) + 1;
  negativo = str2num(CCVS{indice,3}) + 1;
  referencia_saindo = str2num(CCVS{indice,4}) + 1;
  referencia_entrando = str2num(CCVS{indice,5}) + 1;
  transresistencia = str2num(CCVS{indice,6});
  % Aumenta a dimensão com zeros
  Gm = [Gm, zeros(size(Gm)(1),1)];
  Gm = [Gm; zeros(1,size(Gm)(2))];
  in = [in; 0];
  % Acrescenta a primeira estampa de H
  Gm(referencia_saindo, size(Gm)(2)) += 1;
  Gm(referencia_entrando, size(Gm)(2)) += -1;
  Gm(size(Gm)(1), referencia_saindo) += -1;
  Gm(size(Gm)(1), referencia_entrando) += 1;
  % Aumenta mais uma vez a dimensão com zeros
  Gm = [Gm, zeros(size(Gm)(1),1)];
  Gm = [Gm; zeros(1,size(Gm)(2))];
  in = [in; 0];
  % Acrescenta a segunda estampa de H
  Gm(positivo, size(Gm)(2)) += 1;
  Gm(negativo, size(Gm)(2)) += -1;
  Gm(size(Gm)(1), positivo) += -1;
  Gm(size(Gm)(1), negativo) += 1;
  Gm(size(Gm)(1), size(Gm)(2) -1) += transresistencia;  
end     

% Preenche a matriz Gm e o vetor in com os Amplificadores Operacionais
for indice = 1:num_OpAmp
  vout1 = str2num(OpAmp{indice,2}) + 1;
  vout2 = str2num(OpAmp{indice,3}) + 1;
  vin1 = str2num(OpAmp{indice,4}) + 1;
  vin2 = str2num(OpAmp{indice,5}) + 1;
  % Aumenta a dimensão com zeros
  Gm = [Gm, zeros(size(Gm)(1),1)];
  Gm = [Gm; zeros(1,size(Gm)(2))];
  in = [in; 0];
  % Acrescenta a primeira estampa do Amplificador Operacional
  Gm(vout1, size(Gm)(2)) += 1;
  Gm(vout2, size(Gm)(2)) += -1;
  Gm(size(Gm)(1), vin1) += 1;
  Gm(size(Gm)(1), vin2) += -1;
end

% Preenche a matriz Gm e o vetor in com os Transformadores Ideais
for indice = 1:num_K
  positivo_1 = str2num(Transformers{indice,2}) + 1;
  negativo_1 = str2num(Transformers{indice,3}) + 1;
  positivo_2 = str2num(Transformers{indice,4}) + 1;
  negativo_2 = str2num(Transformers{indice,5}) + 1;
  acoplamento = str2num(Transformers{indice,6});
  % Aumenta a dimensão com zeros
  Gm = [Gm, zeros(size(Gm)(1),1)];
  Gm = [Gm; zeros(1,size(Gm)(2))];
  in = [in; 0];
  % Acrescenta a estampa de K
  Gm(positivo_1, size(Gm)(2)) += -acoplamento;
  Gm(negativo_1, size(Gm)(2)) += acoplamento;
  Gm(positivo_2, size(Gm)(2)) += 1;
  Gm(negativo_2, size(Gm)(2)) += -1;
  Gm(size(Gm)(1), positivo_1) += acoplamento;
  Gm(size(Gm)(1), negativo_1) += -acoplamento;
  Gm(size(Gm)(1), positivo_2) += -1;
  Gm(size(Gm)(1), negativo_2) += 1;
end 

% Elimina o nó 0 da matriz Gm
Gm(1,:) = [];
Gm(:,1) = [];

% Elimina o nó 0 do vetor in
in(1,:) = [];

% Calcula o resultado
resultado = inv(Gm)*in;

disp("\nResultado encontrado:\n");
for indice = 1:size(in)(1)
  sinal = '+';
  zmag = abs(resultado(indice));
  zdeg = angle(resultado(indice))*180/pi;
  if zdeg < 0
    zdeg = abs(zdeg);
    sinal = '-';
  end 
  if indice <= num_Nodes    
      printf("\te%d = %fcos(%ft %s %f°) V\n", indice, zmag, frequency, sinal, zdeg);
    else
      printf("\tj%d = %fcos(%ft %s %f°) A\n", indice, zmag, frequency, sinal, zdeg);
  end    
end