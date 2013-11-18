%%%%%%%%%%%%%%%%%%%%%%%%%%
function strout = tnm034(img)
%
% Im: Input image of captured sheet music. Im should be in
% double format, normalized to the interval [0,1]
% strout: The resulting character string of the detected
% notes. The string must follow a pre-defined format.
%
% Your program code.
%%%%%%%%%%%%%%%%%%%%%%%%%%

bin = makeBinary(img);



rotationDegree = findRotationHough(bin);
%rotationDegree = findRotationHoughIterative(im,b,1);
%rotationDegree = findRotationIterative(im);
bin_rot = imrotate(bin, rotationDegree);
img_rot = imrotate(img, rotationDegree);
close all;
%figure
%imshow(bin)
%figure
%imshow(bin_rot);
%figure
%imshow(img_rot);
%staffDetection(imrotate(img,rotationDegree),2,1);

% fk = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1 ];
% fk = fk./ sum(fk(:));
% fk
% w = conv2(fk,img_rot);
% figure
% imshow(w);
% r = makeBinary(w,1);
% figure
% imshow(r);

bin_rot_comp = imcomplement(bin_rot);
%se = strel('disk', 3);
se = strel('line',3,90);
se = [1 1 1; 1 1 1; 1 1 1];
erodedBW = imerode(bin_rot_comp,se);
figure, imshow(bin_rot_comp), figure, imshow(erodedBW)

se = strel('disk', 4);
erodedBW2 = imerode(bin_rot_comp,se);
figure, imshow(erodedBW2)

diff = erodedBW - erodedBW2;
figure, imshow(diff);

%temp = rgb2gray(im2double(imread('templates/Notenkopf4.bmp')));
%cc = normxcorr2(erodedBW,temp); 
%figure, imshow(cc);




end
