function [bw ] = makeBinary(greyImage,debug)
%MAKEBINARY Summary of this function goes here
%   Detailed explanation goes here


% Set default values if the argument wasn't passed in, or is empty, as in []
    if (nargin < 2)  ||  isempty(debug)
        debug = 0;
    end
%make histogram

greyImage;
if debug
    vector = greyImage(:);
    figure('name','Histogram of greyValues in makeBinary');
    hist(vector,100);
end

level = graythresh(greyImage);
%level
bw = im2bw(greyImage, level);


%imshow(bw);
%bw = greyImage > 0.7;
%figure('name','BinaryImageOutOfGreyValues');
%imshow(bw);


end

