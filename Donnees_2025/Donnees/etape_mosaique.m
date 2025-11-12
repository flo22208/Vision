function imosCoul = etape_mosaique(im1Coul,im2Coul,TailleFenetre,seuil,k,NbPoints)

Im1 = rgb2gray(im1Coul);
Im2 = rgb2gray(im2Coul);

[XY_1,Res_1] = harris(Im1,TailleFenetre,NbPoints,k);
[XY_2,Res_2] = harris(Im2,TailleFenetre,NbPoints,k);

[XY_C1,XY_C2] = apparier_POI(Im1,XY_1,Im2,XY_2,TailleFenetre,seuil);

H = homographie(XY_C1,XY_C2);

imosCoul = mosaiquecoul(im1Coul,im2Coul,H);

end

