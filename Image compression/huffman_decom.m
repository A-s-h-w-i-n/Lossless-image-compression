clc
clear all
close all

%-------DECOMPRESSION-------

file = uigetfile
[filepath,name,ext] = fileparts(file);
[compA,xcolorMap] = imread(strcat(name,'.bmp'));

compA = double(compA);

C = strsplit(name,'_');
datFile = strcat(C(1),'.dat')
Pn = csvread(char(datFile));

xpaddedDec = Pn(260);
xpaddedBin = Pn(259);
size_img_2 = Pn(258);
size_img_1 = Pn(257);

compSize = size(compA);

for i=1:compSize(1)
    for j=1:compSize(2)
        xcompVec(j+(i-1)*compSize(2)) = compA(i,j);
    end
end

xcompDecimalVec = xcompVec(1:numel(xcompVec)-xpaddedDec);
xcompDecimalVec = transpose(xcompDecimalVec);

xcompBinaryMat = de2bi(xcompDecimalVec);

X = size(xcompBinaryMat);
for i=1:X(1)-1
    for j=1:8
        xcomp(j+(i-1)*8) = xcompBinaryMat(i,j);
    end
end
for k=1:8-xpaddedBin
    xcomp(j+(i-1)*8 + k) = xcompBinaryMat(i+1,k);
end

xcomp = transpose(xcomp);
xcomp = double(xcomp);

xsymbols = 0:255;
xdict = huffmandict(xsymbols,(Pn(1:256)./(size_img_1*size_img_2)));

ximageVector = huffmandeco(xcomp,xdict);

for i=1:size_img_1
    for j=1:size_img_2
        xImage(i,j) = ximageVector(j+(i-1)*size_img_2);
    end
end

xImage = uint8(xImage);

figure(2)
imshow(xImage,xcolorMap)
imwrite(xImage,xcolorMap,strcat(name,'_recovered.bmp'));
disp('Image recovered successfully')