function [binaryImage ] = makeBinary(greyImage)
%MAKEBINARY Summary of this function goes here
%   Detailed explanation goes here

% make a histogram
vector = greyImage(:);
hist(vector,100);

binaryImage = greyImage > 0.7;
imshow(binaryImage);

end

