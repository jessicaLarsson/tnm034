function [binaryImage ] = makeBinary(greyImage)
%MAKEBINARY Summary of this function goes here
%   Detailed explanation goes here

% make a histogram
vector = greyImage(:);
hist(vector,100);

binaryImage = greyImage > 0.8;
imshow(binaryImage);

end

