

function [Imos] = mosaiqueN(list_I,list_H)

% On recupere la taille des deux images. 
[N,~] = size(list_I);
[nbl,nbc,~] = size(list_I{1});
nbh = legth(list_H);

list_H_inv = list_H;
xy_coins_R2 = [1 1; nbc 1; nbc nbl; 1 nbl];
list_xmin = zeros(nbh,1);
list_ymin = zeros(nbh,1);
list_xmax = zeros(nbh,1);
list_ymax = zeros(nbh,1);
for i=1:nbh
% On calcule l'homographie inverse, normalisee, 
% pour nous permettre d'effectuer la transformation de I2 vers I1.
    list_H_inv{i}=inv(list_H{i});
    list_H_inv{i}=list_H_inv{i}./list_H_inv{i};

    % Calcul des dimensions de la mosaique. 
    % Calcul des quatre coins dans l'image 2. 
    % les coins de l'image 2 sont ranges en ligne selon : 
    % haut_gauche, haut_droit, bas_droit, bas gauche. 
    % Lignes et colonnes sont inversees.  
    
    
    
    % Application de l'homographie Hinv sur ces coins. 
    % Calcul des images des coins dans I1. 
    xy_coinsR1 = appliquerHomographie(list_H_inv{i},xy_coinsI2_R2);
    
    % Determination des dimensions de l'image mosaique, 
    % les xmin ymin xmax ymax, ou :
    %  - xmin represente la plus petite abscisse parmi les abscisses des images 
    %    des coins de I2 projetes dans I1 et les coins dans I1, 
    %  - etc
    % Lignes et colonnes sont inversees. 
    
    list_xmin(i)=min([xy_coinsR1(:,1)' 1]);
    list_ymin(i)=min([xy_coinsR1(:,2)' 1]);
    list_xmax(i)=max([xy_coinsR1(:,1)' nbcI1]);
    list_ymax(i)=max([xy_coinsR1(:,2)' nblI1]);
   
end

 
% On arrondit de maniere a etre certain d'avoir les coordonnees initiales
% bien comprises dans l'image. 
xmin=floor(min(list_xmin));
ymin=floor(min(list_ymin));
xmax=ceil(max(list_xmax));
ymax=ceil(max(list_ymax));


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTRUCTION DE LA MOSAIQUE %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Calcul de la taille de la mosaique. 
% Lignes et colonnes sont inversees. 
nblImos=ymax-ymin+1;
nbcImos=xmax-xmin+1;

Imos=zeros(nblImos,nbcImos,3);

% Calcul de l'origine de l'image I1 dans le repere de la mosaique Imos. 
O1x_Rmos = 1-(xmin-1);
O1y_Rmos = 1-(ymin-1);

% Copie de l'image I1. 
% Lignes et colonnes sont inversees. 
Imos(O1y_Rmos:O1y_Rmos+nblI1-1, O1x_Rmos:O1x_Rmos+nbcI1-1,:) = list_I{1};

% Copie de l'image I2 transformee par l'homographie H. 
for x=1:nbcImos,
  for y=1:nblImos,
    list_xR2 = cell(nbh);
    list_yR2 = cell(nbh);
    list_xR1 = cell(nbh);
    list_yR1 = cell(nbh);
      for i=1:nbh
        % Calcul des coordonnees dans I1 connaissant les coordonnees du point origine de I1 dans Imos. 
        list_yR1{i}=y-O1y_Rmos;
        list_xR1{i}=x-O1x_Rmos;
        % Dans le repere attache a l'image I1, 
        % nous estimons les coordonnees du point image de (y_R1,x_R1)
        % par l'homographie H : (xy_R2). 
        xy_R2 = appliquerHomographie(H,[x_R1 y_R1]);
    
        % Il existe plusieurs strategies, mais, ici, 
        % pour estimer les coordonnees (entieres) , 
        % on choisit : sans interpolation, le plus proche voisin. 
        x_R2=round(xy_R2(1)); 
        y_R2=round(xy_R2(2));
    
        % On verifie que xy_R2 appartient bien a l'image I2 
        % avant d'affecter cette valeur a Imos
        % Lignes et colonnes sont inversees. 
      end
    
   

    if(x_R2>=1 & x_R2<=nbcI2 & y_R2>=1 & y_R2<=nblI2 & x_R1>=1 & x_R1<=nbcI1 & y_R1>=1 & y_R1<=nblI1 )
            d1 = nbcI1-x_R1;
            d2 = x_R2;
        
            p1 = d1/(d1+d2);
            p2 = d2/(d1+d2);
          Imos(y,x,:)= round(p2 * I2(y_R2,x_R2,:) + p1 * I1(y_R1,x_R1,:) );
    elseif (x_R2>=1 & x_R2<=nbcI2 & y_R2>=1 & y_R2<=nblI2)
        Imos(y,x,:) = I2(y_R2,x_R2,:);
    end
  end
end
