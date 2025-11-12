clear all;
close all;

% Lecture des images
Im1 = imread('ulahup1.pgm');
Im2 = imread('ulahup2.pgm');
Im3 = imread('ulahup3.pgm');
Im1_coul = imread('ulahup_couleur1.jpg');
Im2_coul = imread('ulahup_couleur2.jpg');
Im3_coul = imread('ulahup_couleur3.jpg');
 
% Affichage des deux premières images en niveaux de gris
figure;
affichage_image(Im1,'Image 1',1,2,1);
affichage_image(Im2,'Image 2',1,2,2);

% Choix des parametres
TailleFenetre = 15;
NbPoints = 120 ; %%%% changer de 80 à 120
k = 0.05;
seuil = 0.91;%%%0.91;

%%% entre l'image 2 et 3
[XY_1,Res_1] = harris(Im1,TailleFenetre,NbPoints,k);
[XY_2,Res_2] = harris(Im2,TailleFenetre,NbPoints,k);
[XY_3,Res_3] = harris(Im3,TailleFenetre,NbPoints,k);


[XY_C23,XY_C32] = apparier_POI(Im2,XY_2,Im3,XY_3,TailleFenetre,seuil);

H = homographie(XY_C23,XY_C32);

Imoscoul23 = mosaiquecoul(Im2_coul,Im3_coul,H);


%%% entre le résultat et 1
Im23 = rgb2gray(Imoscoul23);

[XY_23,Res_23] = harris(Im23,TailleFenetre,NbPoints,k);

[XY_C123,XY_C231] = apparier_POI(Im1,XY_1,Im23,XY_23,TailleFenetre,seuil);

H1 = homographie(XY_C123,XY_C231);

Imoscoul = mosaiquecoul(Im1_coul,Imoscoul23,H1);


figure;
affichage_image(uint8(Im1_coul),'Mosaique 1',1,1,1);
%SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES EN COULEUR VERSION 2
imwrite(uint8(Imoscoul),'mosaique1_coul.pgm');

figure;
affichage_image(uint8(Imoscoul23),'Mosaique 2',1,1,1);
%SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES EN COULEUR VERSION 2
imwrite(uint8(Imoscoul),'mosaique2_coul.pgm');

figure;
affichage_image(uint8(Imoscoul),'Mosaique finale',1,1,1);
%SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES EN COULEUR VERSION 2
imwrite(uint8(Imoscoul),'mosaique2final_coul.pgm');



