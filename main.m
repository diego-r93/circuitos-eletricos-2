clc;
clear;
close all;
disp('<< Programa de an�lise de circuitos atrav�s de uma netlist >>');
disp('<< Digite 1 para an�lise nodal >>');
disp('<< Digite 2 para an�lise nodal sistem�tica >>');
disp('<< Digite 3 para an�lise em regime permanente senoidal >>');
choice = input('>>>> ');

switch (choice)
  case {1}
    run('nodal.m');
  case {2}
    run('systematic.m');
  case {3}
    run('steady-state.m');
  otherwise
    disp('Op��o Inv�lida.');
end