clc
clear all
close all

%--------COMPRESSION---------

file = uigetfile
[filepath,name,ext] = fileparts(file);
[A,colormap] = imread(strcat(name,'.bmp'));
C = strsplit(name,'_');
figure(1)
imshow(A,colormap)
size_img = size(A)

symbols = 0:255;
for i=1:256
    P(i) = 0;
end

for i=1:size_img(1)*size_img(2)
    P(A(i)+1) = P(A(i)+1) + 1;
end
for i=1:256
    P(i) = P(i)/(size_img(1)*size_img(2));
end

for i=1:size_img(1)
    for j=1:size_img(2)
        imageVector(j+(i-1)*size_img(2)) = A(i,j);
    end
end
imageVector = transpose(imageVector);

dict = huffmandict(symbols,P);
comp = huffmanenco(imageVector,dict);

binarySig = de2bi(imageVector);
seqLen = size(binarySig)

compLen = size(comp)

[compBinaryMat,paddedBin] = vec2mat(comp,8);

compDecimalVec = bi2de(compBinaryMat);

[compDecimalMat,paddedDec] = vec2mat(compDecimalVec,size_img(2));

imwrite(uint8(compDecimalMat),colormap,strcat(name,'_compressed.bmp'));
P = P.*(size_img(1)*size_img(2));
P(257) = size_img(1);
P(258) = size_img(2);
P(259) = paddedBin;
P(260) = paddedDec;
csvwrite(strcat(char(C(1)),'.dat'),P);
disp('Images compressed successfully')
Compression_Ratio = (seqLen(1)*seqLen(2)-compLen(1))/(seqLen(1)*seqLen(2))


