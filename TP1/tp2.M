clear all;
close all;

%% VAR

fech = 8000;
fnote=261.6;
teta=2*pi*(fnote/fech);

f=-(fech/2):1/N:(fech/2) -1/N;

notetime=0.4;

R=0.95;

p1 = R*exp(1i*teta); %pôles du filtre
p2 = R*exp(-1i*teta);

bb = randn(1,N); 


%% FIGURES