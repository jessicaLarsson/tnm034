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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotate image 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rotationDegree = findRotationHough(bin);
%rotationDegree = findRotationHoughIterative(im,b,1);
%rotationDegree = findRotationIterative(im);
bin_rot = imrotate(bin, rotationDegree);
img_rot = imrotate(img, rotationDegree);
bin_rot_comp = imcomplement(bin_rot);
s = size(bin_rot);

close all;

% plot of horizontal projection
    %%%%%% 
    summe = sum(bin_rot_comp,2);
    figure('name','plot of horizontal projection'),plot(summe);
    summe = sum(bin_rot_comp,1);
    figure('name','plot of vertical projection'),plot(summe);
    %%%%%%


%figure
%imshow(bin)
%figure
%imshow(bin_rot);
%figure
%imshow(img_rot);
%staffDetection(imrotate(img,rotationDegree),2,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect the staff - get information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ clusters,startStaffSystem, endStaffSystem,staffHeight,staffSpace ] = detectStaff(bin_rot_comp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cut image with staff information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dimensionsOfImage = size(bin_rot);

verticalOffset = (5*staffSpace+4*staffHeight);
up = max(startStaffSystem(1) - verticalOffset,1);
down = min(endStaffSystem(end) + verticalOffset, dimensionsOfImage(2));

bin_rot = bin_rot(up:down,:);
img_rot = img_rot(up:down,:);
bin_rot_comp = bin_rot_comp(up:down,:);

figure('name','cuttedImage'), imshow(bin_rot);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note heads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%se = strel('disk', 3);
% remove staff

se = strel('line',3,90);
se = [1 1 1; 1 1 1; 1 1 1];
erodedBW = imerode(bin_rot_comp,se);
figure('name','originalImage'), imshow(bin_rot_comp);
figure('name','erodedImage'), imshow(erodedBW)

se = strel('disk', 2);
erodedBW2 = imopen(bin_rot_comp,se);
figure, imshow(erodedBW2)

diff = erodedBW - erodedBW2;
figure, imshow(diff);

temp = rgb2gray(im2double(imread('templates/Note4_14paint.bmp')));
cc = normxcorr2(temp,imcomplement(erodedBW));
cc = mat2gray(cc);
figure, imshow(cc);

vector = cc(:);
    figure('name','Histogram of greyValues in makeBinary');
    hist(vector,100);

bw = im2bw(cc, 0.8);
se = [ 0 1 0; 1 1 1 ; 0 1 0];
bw = imerode(bw,se);
figure, imshow(bw);

end
