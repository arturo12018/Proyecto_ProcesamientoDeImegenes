clc;
close all;
clear;

%volume_image
load('VOLUME_IMAGE.mat'); %El modelo esta en hounsfield units 

V = squeeze(volume_image);

sizeO = size(V);
figure(1)
slice(double(V),sizeO(2)/2,sizeO(1)/2,sizeO(3)/2);
shading interp
colormap("gray")
title("Original")

%Vista con volumeViewer
%V = im2single(V);
%volumeViewer(V);

%%
%Segmentacion en XY

XY = V(:,:,134);
figure(2)
imshow(XY,[],"Border","tight")


mask=(XY*0);
mask(XY>250)=1; 
figure(3)
imshow(mask)

%Se uso para generar el segmento
%imageSegmenter(mask)


%Funcion del segmento

% Adjust data to span data range.
X = imadjust(mask);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Flood fill
row = 352;
column = 432;
tolerance = 5.000000e-02;
addedRegion = grayconnected(X, row, column, tolerance);
BW = BW | addedRegion;

% Create masked image.
maskedImageXY = X;
maskedImageXY(~BW) = 0;



figure(4)
imshow(maskedImageXY)

%%
%Segmentacion en XZ

XZ= squeeze(V(348,:,:));
figure(5)
imshow(XZ,[],"Border","tight");

mask1=(XZ*0);
mask1(XZ>340)=1;
SE=strel('disk',4);
E1=imerode(mask1,SE);


figure(6)
imshow(E1)

%Se uso para generar el segmento
%imageSegmenter(E1)



% Adjust data to span data range.
X = imadjust(E1);

% Create empty mask.
BW = false(size(X,1),size(X,2));

% Flood fill
row = 422;
column = 130;
tolerance = 5.000000e-02;
addedRegion = grayconnected(X, row, column, tolerance);
BW = BW | addedRegion;

% Create masked image.
maskedImageXZ = X;
maskedImageXZ(~BW) = 0;

figure(7)
imshow(maskedImageXZ)

%%
M1=imfuse(XY,maskedImageXY)
figure(8)
imshow(M1)

M2=imfuse(XZ,maskedImageXZ)
figure(9)
imshow(M2)



%%

%Mascara 3D

mask3 = false(size(V));
mask3(:,:,134) = maskedImageXY;
mask3(348,:,:) = mask3(348,:,:)|reshape(maskedImageXZ,[1,763,267]);
%
% %Masks 
% figure(8)
% subplot(1,2,1), imshow(mask), title('XY Mask');
% subplot(1,2,2), imshow(mask1), title('XZ Mask');
% 
 volumeViewer(mask3);


%%
%Creacion del modelo 3D

% V = histeq(V);
% 
% BW = activecontour(V,mask3,200,"Chan-Vese");
% 
% segmentedImage = V.*single(BW); 
% 
% volumeViewer(segmentedImage)



