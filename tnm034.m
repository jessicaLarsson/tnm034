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

bin_rot_comp = imrotate(imcomplement(bin), rotationDegree);
bin_rot = imcomplement(bin_rot_comp);
img_rot = imrotate(img, rotationDegree);

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

% remove staff out of image
%se = strel('line',3,90);
se = [1 1 1; 1 1 1; 1 1 1];
removedStaff = imerode(bin_rot_comp,se);
figure('name','originalImage'), imshow(bin_rot_comp);
figure('name','erodedImage - without staff'), imshow(removedStaff);

staffSpace

% se1 = [ 0 1 1; 0 1 1 ; 1 1 0];
% se2 = [ 1 1 0; 0 1 1 ; 0 1 1];
% faehnchen1 = imdilate(bin_rot_comp,se1);
% faehnchen2 = imdilate(bin_rot_comp,se2);
% figure('name','faehnchen'), imshow(faehnchen1+faehnchen2)

% open with a disk to mark noteheads
se = strel('disk',ceil(staffSpace/2.0+0.5));  
removedStaffDiskOpened = imopen(bin_rot_comp,se);
figure('name','nach disk �ffnen'), imshow(removedStaffDiskOpened)

% erode to focus points
se = [1 1 1; 1 1 1; 1 1 1];
noteHeadFocused = imerode(removedStaffDiskOpened, se);
figure('name','nach Fokusierung'), imshow(noteHeadFocused);
hold on;

L = bwlabel(noteHeadFocused)
stats = regionprops(L,noteHeadFocused,'Centroid')

for i = 1:length(stats)
    
    x = stats(i).Centroid(1);
    y = stats(i).Centroid(2);
    plot(x,y,'--rs','LineWidth',2,'MarkerFaceColor','r','MarkerSize',2);
end

disp('ready');

% 
% % show diff to see, that every note was detected
% diff = removedStaffDiskOpened - removedStaff;
% figure('name','diffImage'), imshow(diff);
% 
% se = strel('line',3*staffSpace,90);
% %se = [1 1 1; 1 1 1; 1 1 1];
% removedVertLine = imopen(bin_rot_comp,se);
% figure('name','originalImage'), imshow(bin_rot_comp);
% figure('name','erodedImage - without staff'), imshow(removedVertLine);
% 
% 
% % show diff to see, that every note was detected
% diff = removedStaffDiskOpened + removedVertLine;
% figure('name','diffImageVert'), imshow(diff);
% 
% %choose correct height for head
% temp = rgb2gray(im2double(imread('templates/NotenkopfVoll.bmp')));
% temp = imresize(temp, [(staffSpace*1.3) NaN]);
% 
% figure('name','temp'),imshow(temp);
% 
% cc = normxcorr2(imcomplement(temp),erodedBW);
% cc = mat2gray(cc);
% figure('name','templateMatchin'), imshow(cc);
% 
% vector = cc(:);
%     figure('name','Histogram of greyValues in makeBinary');
%     hist(vector,100);
% 
% bw = im2bw(cc, 0.6);
% se = [ 0 1 0; 1 1 1 ; 0 1 0];
% bw = imerode(bw,se);
% figure, imshow(bw);

end
