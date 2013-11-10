function [ summedRows ] = staffDetection( greyImage, type , debug)
%Take the grey image and calculate rows
% type = 1: only vertical edge detection
% type = 2: vertical and horizontal edge detection

% Set default values if the argument wasn't passed in, or is empty, as in []
    if (nargin < 3)  ||  isempty(debug)
        debug = 0;
    end
    


s = size(greyImage);


bin = zeros(s(1),s(2));

filteredImage = sobelOperator(greyImage,type == 1 || type == 2, type == 2);

bin = makeBinary(filteredImage);

if debug
    figure('name','BinaryFilteredImage');
	imshow(bin);
end



% count white pixels in binary image
% ??? schneller machen
s = size(bin);
sum = zeros(s(1),1);
for i = 1:s(1)
    for j = 1:s(2)
        sum(i) = sum(i) + bin(i,j);
    end
end

if debug
	figure('name','plot of horizontal projection');
	plot(sum);
end

ylim([0 s(2)]);


summedRows = sum;

end

