clear all;
close all;

%% VAR

%%étape 1 : réponse impulsionelle du filtre
moyenne = 0;
sigma2=1; %= puissance théorique d'un bruit blanc, on le modifie pour modifier la puissance du bruit blanc (puissance dsp linéaire)
teta = pi/3; %décale fréquentiellement la localisation des pôles/zéros et donc dsp
r=0.98; %r=coef des des zéros et R=coef des pôles
R=0.95; %filtre stable si R < 1 et donc à l'intérieur du cercle unité, %+ proche du cercle + résonnance puissante, même chose avec zéros
N=1000;
fech=1;
f=-(fech/2):1/N:(fech/2) -1/N; %-fech/2 à fech/2 %fréquence normalisée, pas d'unité car divisé par fech
%on enleve le dernier avec - 1/N pour que les tailles de vecteurs
%correspondent
p1 = R*exp(1i*teta); %pôles
p2 = R*exp(-1i*teta);

B1 = [ 1 ]; %zeros
A1 = [ 1 -(p1+p2) R^2 ]; %poles
h1=freqz(B1,A1,2*pi*f); %seulement 2 pôles


%%étape 2 : filtrage et étude d'un bruit blanc

bb = randn(1,N); 
bbf=filter(B1,A1,bb); %bruit blanc filtré par le filtre précédent

%spectre de puissance = norme au carré de la transformée de fourrier, divisé par N
%spectre de puissance dépendant de réalisation du signal y(n) mais pas dsp
powerscpectre = (fftshift(abs(fft(bbf))).^2)/N;

% dsp = norme carré(transformé de fourrier du filtre) * variance
dsp = (abs(h1).^2)*sigma2; %ici le filte et déjà en fft, %DSP + lisse que spectre de puissance


%%étape 3 : filtre caractérisé par uniquement des zéros
%A FAIRE, même chose que pour les pôles


%%étape 4 : filtre caractérisé par des zéros et des pôles

%zéros
z1 = r*exp(1i*teta); 
z2 = r*exp(-1i*teta);

B2 = [ 1 -(z1+z2) r^2 ]; %zéros
A2 = [ 1 ]; %poles
h2=freqz(B2,A2,2*pi*f); %seulement 2 zéros


B3 = [ 1 -(z1+z2) r^2 ]; %zéros
A3 = [ 1 -(p1+p2) R^2 ]; %poles
h3=freqz(B3,A3,2*pi*f); %2 pôles et 2 zéros
%(Réjections des zéros si r>R, qui devient sélective grâce aux pôles)
% cool mais créer distorsion de phase


%% FIGURES

%%étape 1 : réponse impulsionelle du filtre

% cercle unité avec les pôles et les zéros
subplot(2,2,1);
zplane(B1,A1); 
title('Cercle unité')

% résonnance des poles
subplot(2,2,2);

%localisation fréquentielle des résonnances
reso1 = (teta/pi)*fech/2;
reso2 = -reso1;

% réponse en fréquence de son module
subplot(2,2,2);
plot(f,abs(h1)); % résonnance des pôles en fech/6 fo/fech=pi/3 etc 
                %(on prend le module avec abs()) %ici représente le gain (pas d'unité) et
                %si on multiplie par 10log10(abs(h)) alors en dB
title('Réponse en fréquence de h1 (Résonnance des pôles)')
xlabel('Fréquence normalisée')
ylabel('Gain')

% réponse en fréquence de sa phase (on prend l'argument avec angle())
subplot(2,2,3);
plot(f,angle(h1)); 
title('Réponse en phase de h1')
xlabel('Fréquence normalisée')
ylabel('Radian')



%%étape 2 : filtrage et étude d'un bruit blanc

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


%%étape 3 : filtre caractérisé par uniquement des zéros
%même chose que pour les pôles, donc voir h3


%%étape 4 : filtre caractérisé par des zéros et des pôles
figure;
%filtre1 h1: 2 pôles
subplot(3,2,1);
plot(f,abs(h1));
title('Réponse en fréquence de h1 (Résonnance des pôles)')
xlabel('Fréquence normalisée')
ylabel('Gain')
subplot(3,2,2);
plot(f,angle(h1));
title('Réponse en phase de h1')
xlabel('Fréquence normalisée')
ylabel('Radian')

%filtre2 h2: 2 zéros
subplot(3,2,3);
plot(f,abs(h2));
title('Réponse en fréquence de h2 (Réjections des zéros)')
xlabel('Fréquence normalisée')
ylabel('Gain')
subplot(3,2,4);
plot(f,angle(h2));
title('Réponse en phase de h2')
xlabel('Fréquence normalisée')
ylabel('Radian')

%filtre3 h3: 2 pôles et 2 zéros
subplot(3,2,5);
plot(f,abs(h3));
title('Réponse en fréquence de h3')
xlabel('Fréquence normalisée (r>R)')
ylabel('Gain')
subplot(3,2,6);
plot(f,angle(h3));
title('Réponse en phase de h3')
xlabel('Fréquence normalisée')
ylabel('Radian')


