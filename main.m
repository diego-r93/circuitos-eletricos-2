clc;
clear;
close all;
disp('<< Programa de análise de circuitos através de uma netlist >>');
disp('<< Digite 1 para análise nodal >>');
disp('<< Digite 2 para análise nodal sistemática >>');
disp('<< Digite 3 para análise em regime permanente senoidal >>');
choice = input('>>>> ');

switch (choice)
  case {1}
    run('nodal.m');
  case {2}
    run('systematic.m');
  case {3}
    run('steady-state.m');
  otherwise
    disp('Opção Inválida.');
end