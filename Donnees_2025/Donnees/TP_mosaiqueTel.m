clear all;
close all;


Im1_coul = imread('diap1.jpg');
Im2_coul = imread('diap2.jpg');
Im3_coul = imread('diap3.jpg');
Im4_coul = imread('diap4.jpg');
Im1_coul = Im1_coul(1000:10:end,1:10:end,:);
Im2_coul = Im2_coul(1000:10:end,1:10:end,:);
Im3_coul = Im3_coul(1000:10:end,1:10:end,:);
Im4_coul = Im4_coul(1000:10:end,1:10:end,:);
Im1 = rgb2gray(Im1_coul);
Im2 = rgb2gray(Im2_coul);
Im3 = rgb2gray(Im3_coul);
Im4 = rgb2gray(Im4_coul);
 
% Affichage des deux premières images en niveaux de gris
figure;
affichage_image(Im1,'Image 1',1,2,1);
affichage_image(Im2,'Image 2',1,2,2);

% Choix des parametres
TailleFenetre = 15;
NbPoints = 80 ; %%%% changer de 80 à 120
k = 0.05;
seuil = 0.96;%%%0.91;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Detection des points d'interet avec Harris %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER POUR OBSERVER LA DETECTION DE HARRIS
[XY_1,Res_1] = harris(Im1,TailleFenetre,NbPoints,k);
[XY_2,Res_2] = harris(Im2,TailleFenetre,NbPoints,k);
[XY_3,Res_3] = harris(Im1,TailleFenetre,NbPoints,k);
[XY_4,Res_4] = harris(Im2,TailleFenetre,NbPoints,k);
figure;
affichage_POI(Im1,XY_1,'POI Image 1',1,2,1);
affichage_POI(Im2,XY_2,'POI Image 2',1,2,2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Appariement des points d'interet %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER POUR OBSERVER LA MISE EN CORRESPONDANCE 
%avec/sans verification des contraintes
[XY_C1,XY_C2] = apparier_POI(Im1,XY_1,Im2,XY_2,TailleFenetre,seuil);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Estimation (et verification) de l'homographie %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER QUAND HOMOGRAPHIE AURA ETE COMPLETEE
H1 = homographie(XY_C1,XY_C2);

%%%%%%%%%%%%%%%%%%%%%%%%%
% Calcul de la mosaique %
%%%%%%%%%%%%%%%%%%%%%%%%%
% A DECOMMENTER QUAND HOMOGRAPHIE AURA ETE VALIDEE
Imos = mosaiquecoul(Im1_coul,Im2_coul,H1);
figure; 
affichage_image(uint8(Imos),'Mosaique obtenue a partir des 2 images initiales',1,1,1);
%SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES
imwrite(uint8(Imos),'mosaique2.pgm');



%%%%% refaire une mosaique de l'image créer et l'image 3
Imos_non_coul = rgb2gray(Imos);
[XY_mos,Res_mos] = harris(Imos_non_coul,TailleFenetre,NbPoints,k);
[XY_Cmos_2,XY_C3_2] = apparier_POI(Imos_non_coul,XY_mos,Im3,XY_3,TailleFenetre,seuil); %%%% seulement 9 points apparayé d'après moi c'est trop peu donc imprésion sur l'équation de l'homographie, on ne peut pas baisser le seuil sinon mauvais point, il faut avoir plus de points
H2 = homographie(XY_Cmos_2,XY_C3_2);

figure;
affichage_POI(Imos_non_coul,XY_mos,'POI Image 1',1,2,1);
affichage_POI(Im3,XY_3,'POI Image 2',1,2,2);

Imoscoul2 = mosaiquecoul(Imos,Im3_coul,H2);

%%% refaire pour image 3

Imos_non_coul2 = rgb2gray(Imoscoul2);
[XY_mos,Res_mos] = harris(Imos_non_coul2,TailleFenetre,NbPoints,k);
[XY_3,Res_3] = harris(Im3,TailleFenetre,NbPoints,k);
[XY_Cmos_2,XY_C3_2] = apparier_POI(Imos_non_coul2,XY_mos,Im4,XY_4,TailleFenetre,seuil); %%%% seulement 9 points apparayé d'après moi c'est trop peu donc imprésion sur l'équation de l'homographie, on ne peut pas baisser le seuil sinon mauvais point, il faut avoir plus de points
H3 = homographie(XY_Cmos_2,XY_C3_2);

figure;
affichage_POI(Imos_non_coul2,XY_mos,'POI Image 1',1,2,1);
affichage_POI(Im3,XY_3,'POI Image 2',1,2,2);

Imoscoul3 = mosaiquecoul(Imoscoul2,Im4_coul,H3);



figure;
affichage_image(uint8(Imoscoul3),'Mosaique obtenue a partir des N images couleur initiales (version 2)',1,1,1);
%SAUVEGARDE DE LA MOSAIQUE A DEUX IMAGES EN COULEUR VERSION 2
imwrite(uint8(Imoscoul3),'mosaiqueN_coul.pgm');

