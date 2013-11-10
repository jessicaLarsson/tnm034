function [ summedRows ] = staffDetection( greyImage,type )
%Take the grey image and calculate rows
% type = 1: only vertical edge detection
% type = 2: vertical and horizontal edge detection

s = size(greyImage);


bin = zeros(s(1),s(2));

filteredImage = sobelOperator(greyImage,type == 1 || type == 2, type == 2);

bin = makeBinary(filteredImage);


figure('name','BinaryFilteredImage');
imshow(bin);



% count white pixels in binary image
% ??? schneller machen
s = size(bin);
sum = zeros(s(1),1);
for i = 1:s(1)
    for j = 1:s(2)
        sum(i) = sum(i) + bin(i,j);
    end
end

figure('name','plot of horizontal projection');
plot(sum);

ylim([0 s(2)]);


summedRows = sum;

end

