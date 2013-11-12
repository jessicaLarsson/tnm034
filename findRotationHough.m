function [ optimalRotation ] = findRotation( greyImage )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

s = size(greyImage);
choosenPrctile = 95;
choosenFilter = 1;

binaryImage = makeBinary(greyImage);

[H, theta, rho] = hough(binaryImage);

figure;
imshow(H);
axis([0 100 60 90]);

%disp('with rotation')
%tmpRotation
%staffDetection(imrotate(greyImage,tmpRotation),1,1);


% half degree, until maximum is reached



end

