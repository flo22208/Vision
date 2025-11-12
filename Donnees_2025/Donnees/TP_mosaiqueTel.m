clear all;
close all;


Im1_coul = imread('ulahup_couleur1.jpg');
Im2_coul = imread('ulahup_couleur2.jpg');
Im3_coul = imread('ulahup_couleur3.jpg');

% Choix des parametres
TailleFenetre = 15;
NbPoints = 120 ; %%%% changer de 80 à 120
k = 0.05;
seuil = 0.91;%%%0.91;


mosaique = etape_mosaique(Im1_coul,Im2_coul,TailleFenetre,seuil,k,NbPoints);

mosaique = etape_mosaique(mosaique,Im3_coul,TailleFenetre,seuil,k,NbPoints);

figure;
affichage_image(uint8(mosaique),'Mosaique finale',1,1,1);
%SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES EN COULEUR VERSION 2

