clear all;
close all;

%% VAR

notetime=0.4;
fech = 8000; % => 1 SECONDE = 8000 ECHANTILLONS, ici une note dure 0,4s
Tech = 1/fech

do=261.6;
re=293.7;
mi=329.7;
fa=349.2;
sol=392;
la=440;
si=493.9;


%note que l'on veut jouer
fnote=fa;

teta=2*pi*(fnote/fech);

N = fech*notetime; %nombres d'échantilles d'une note

f=-fech/2:fech/N:fech/2 -fech/N;

%filtre avec des résonances GIGA sélectives ENVIRON 10 PUISSANCE 1000
R=0.9999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999999;
% r=0.98;
%
% z1 = r*exp(1i*teta);
% z2 = r*exp(-1i*teta);

p1 = R*exp(1i*teta); %pôles du filtre
p2 = R*exp(-1i*teta);

% B2 = [ 1 -(z1+z2) r^2 ]; %zéros
% A2 = [ 1 ]; %poles
% h2=freqz(B2,A2,2*pi*f); %seulement 2 zéros

B = [ 1 ]; %zéros
A = [ 1 -(p1+p2) R^2 ]; %poles
%FREQZ PREND DES FREQUENCES NORMALISEES
h=freqz(B,A,2*pi*f/fech); %2 pôles et 2 zéros
%(Réjections des zéros si r>R, qui devient sélective grâce aux pôles)
% cool mais créer distorsion de phase

sigma2=1; %= puissance théorique d'un bruit blanc, on le modifie pour modifier la puissance du bruit blanc (puissance dsp linéaire)
bb = randn(1,N);
bbf=filter(B,A,bb);

%spectre de puissance = norme au carré de la transformée de fourrier, divisé par N
%spectre de puissance dépendant de réalisation du signal y(n) mais pas dsp
powerscpectre = (fftshift(abs(fft(bbf))).^2)/N;

% dsp = norme carré(transformé de fourrier du filtre) * variance
dsp = (abs(h).^2)*sigma2; %ici le filte et déjà en fft, %DSP + lisse que spectre de puissance

%% FIGURES

%Caractérisations du filtre
subplot(2,2,1);
zplane(B,A);
title('Cercle unité')

% résonnance des poles
subplot(2,2,2);

%localisation fréquentielle des résonnances
reso1 = (teta/pi)*fech/2;
reso2 = -reso1;

% réponse en fréquence de son module
subplot(2,2,2);
plot(f,abs(h)); % résonnance des pôles en fech/6 fo/fech=pi/3 etc
%(on prend le module avec abs()) %ici représente le gain (pas d'unité) et
%si on multiplie par 10log10(abs(h)) alors en dB
title('Réponse en fréquence de h1 (Résonnance des pôles)')
xlabel('Fréquence normalisée')
ylabel('Gain')

% réponse en fréquence de sa phase (on prend l'argument avec angle())
subplot(2,2,3);
plot(f,angle(h));
title('Réponse en phase de h')
xlabel('Fréquence normalisée')
ylabel('Radian')

%BB d'entrée
figure
subplot(4,1,1);
plot(bb);
title('Signal temporel en entrée de filtre')
xlabel('échantillons')
ylabel('amplitude')

%BB filtré par le filtre partie 1
subplot(4,1,2);
plot(bbf);
title('Signal temporel en sortie de filtre')
xlabel('échantillons')
ylabel('amplitude')

%Spectre de puissance bbf
subplot(4,1,3);
plot(f,powerscpectre);
title('Spectre de puissance du signal filtré')
xlabel('Fréquence normalisée')
ylabel('Puissance') % en puissance

subplot(4,1,4);
plot(f, dsp);
title('DSP du signal filtré')
xlabel('Fréquence normalisée')
ylabel('Puissance') % en puissance

audiowrite('notematlab.wav',bbf,fech) %ECRIT LE SIGNAL DANS FICHIER AUDIO
%il faut spécifier le format avec .wav à la fin

%% Génération de la partition

nbnotem=11;
Nm = fech*notetime*nbnotem; %nombres d'échantilles d'une note

bbm = randn(1,Nm);

%1=do
tetado=2*pi*(do/fech);
p1do = R*exp(1i*tetado); %pôles du filtre
p2do = R*exp(-1i*tetado);
Bdo = [ 1 ]; %zéros
Ado = [ 1 -(p1do+p2do) R^2 ]; %poles
%FREQZ PREND DES FREQUENCES NORMALISEES
hdo=freqz(Bdo,Ado,2*pi*f/fech); %2 pôles et 2 zéros
bbdo=filter(Bdo,Ado,bb);
%2=fa
tetami=2*pi*(fa/fech);
p1fa = R*exp(1i*tetami); %pôles du filtre
p2fa = R*exp(-1i*tetado);
Bfa = [ 1 ]; %zéros
Afa = [ 1 -(p1fa+p2fa) R^2 ]; %poles
%FREQZ PREND DES FREQUENCES NORMALISEES
hfa=freqz(Bfa,Afa,2*pi*f/fech); %2 pôles et 2 zéros
bbfa=filter(Bfa,Afa,bb);

%3=sol
tetasol=2*pi*(sol/fech);
p1sol = R*exp(1i*tetasol); %pôles du filtre
p2sol = R*exp(-1i*tetasol);
Bsol = [ 1 ]; %zéros
Asol = [ 1 -(p1sol+p2sol) R^2 ]; %poles
%FREQZ PREND DES FREQUENCES NORMALISEES
hsol=freqz(Bsol,Asol,2*pi*f/fech); %2 pôles et 2 zéros
bbsol=filter(Bsol,Asol,bb);

%1=re
tetare=2*pi*(re/fech);
p1re = R*exp(1i*tetare); %pôles du filtre
p2re = R*exp(-1i*tetare);
Bre = [ 1 ]; %zéros
Are = [ 1 -(p1re+p2re) R^2 ]; %poles
%FREQZ PREND DES FREQUENCES NORMALISEES
hre=freqz(Bre,Are,2*pi*f/fech); %2 pôles et 2 zéros
bbre=filter(Bre,Are,bb);
%2=re
tetami=2*pi*(fa/fech);
p1mi = R*exp(1i*tetami); %pôles du filtre
p2mi = R*exp(-1i*tetami);
Bmi = [ 1 ]; %zéros
Ami = [ 1 -(p1mi+p2mi) R^2 ]; %poles
%FREQZ PREND DES FREQUENCES NORMALISEES
hmi=freqz(Bmi,Ami,2*pi*f/fech); %2 pôles et 2 zéros
bbmi=filter(Bmi,Ami,bb);

%FREQZ PREND DES FREQUENCES NORMALISEES
hsol=freqz(Bsol,Asol,2*pi*f/fech); %2 pôles et 2 zéros
bbsol=filter(Bsol,Asol,bb);

%NOTES A JOUER
partition = [ do do do re mi re do mi re re do; 1 1 1 1 2 2 1 1 1 1 2]
%1ere ligne = note
%2eme ligne = durée de la note associée

%On génère un bruit blanc durant un temps correspondant
%au nombre de notes * leur durée


musique = [];
for i=1:nbnotem
    
    if(partition(1,i)==do)
        
        if(partition(2,i)==2)
            musique = [musique bbdo bbdo];
        else
            musique = [musique bbdo];
            
        end
        
    end
    
    if(partition(1,i)==mi)
        
        if(partition(2,i)==2)
            
            if(partition(2,i)==2)
                
                musique = [musique bbmi bbmi];
            else
                musique = [musique bbmi];
                
            end
            
        end
        
        if(partition(1,i)==re)
            
            if(partition(2,i)==2)
                
                musique = [musique bbre bbre];
            else
                musique = [musique bbre];
                
            end
           
        end
        
    end
end

figure;
plot(musique);
title('loop oklm')
xlabel('échantillons')
ylabel('amplitude')
audiowrite('musique.wav',musique,fech) %ECRIT LE SIGNAL DANS FICHIER AUDIO

