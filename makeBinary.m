function [binaryImage ] = makeBinary(greyImage)
%MAKEBINARY Summary of this function goes here
%   Detailed explanation goes here

% make a histogram
%greyImage;

%vector = greyImage(:);
%figure('name','Histogram of greyValues');
%hist(vector,100);

binaryImage = greyImage > 0.7;
%figure('name','BinaryImageOutOfGreyValues');
%imshow(binaryImage);

end

