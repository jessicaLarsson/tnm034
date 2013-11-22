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

% cut up and down 
verticalOffset = (5*staffSpace+4*staffHeight);
up   = startStaffSystem(1) - verticalOffset;
down = endStaffSystem(end) + verticalOffset;

if up < 0
    up = 0;
end

if down > s(1)
    down = s(1);
end

% cut left and right

%figure('name','plot of vertical projection'),plot(summeVerti);
%figure('name','plot of summeVertiFiltered'),plot(summeVertiFiltered);

%lowpassfilter
summeVerti = sum(bin_rot_comp,1);
fil = [1 2 3 2 1];
summeVertiFiltered = filter(fil,1,summeVerti);

%identify "Notenschlüssel"-Pik and get first minima after that
[vertPiks, vertLocs] = findpeaks(summeVertiFiltered);
[maxWert, index] = max(vertPiks);
while  vertPiks(index) >= vertPiks(index+1)
    index = index +1;
end
    
left = vertLocs(index);
right = s(2);

bin_rot = bin_rot(up:down,left:right);
img_rot = img_rot(up:down,left:right);
bin_rot_comp = bin_rot_comp(up:down,left:right);
s = size(bin_rot);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note heads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%se = strel('disk', 3);


% remove staff out of image
se = strel('line',3,90);
%se = [1 1 1; 1 1 1; 1 1 1];
removedStaff = imopen(bin_rot_comp,se);
%removedStaff = imerode(removedStaff,se);
figure('name','originalImage'), imshow(img_rot);
figure('name','originalImage binary'), imshow(bin_rot_comp);
figure('name','erodedImage - without staff'), imshow(removedStaff);
hold on;

boundaries = bwboundaries(removedStaff);

numberOfBoundaries = size(boundaries);

% for k = 1 : numberOfBoundaries
% 
%     thisBoundary = boundaries{k};
%     x = max(thisBoundary(:,2))-min(thisBoundary(:,2));
%     y = max(thisBoundary(:,1))-min(thisBoundary(:,1));
% 
%     if x > staffSpace && y > 2*staffSpace
%         plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
%     end
% end

disp('ready');
%staffSpace

% se1 = [ 0 1 1; 0 1 1 ; 1 1 0];
% se2 = [ 1 1 0; 0 1 1 ; 0 1 1];
% faehnchen1 = imdilate(bin_rot_comp,se1);
% faehnchen2 = imdilate(bin_rot_comp,se2);
% figure('name','faehnchen'), imshow(faehnchen1+faehnchen2)

removedStaffDiskOpened = bin_rot_comp;
% fill small holes
% se = [0 1 0 ; 1 1 1; 0 1 0];
% removedStaffDiskOpened = imdilate(bin_rot_comp,se);
% figure('name','erstmal dilatieren'), imshow(removedStaffDiskOpened)


% open with a disk to mark noteheads
se = strel('disk',ceil(staffSpace/2.0+0.5));  
removedStaffDiskOpened = imopen(removedStaffDiskOpened,se);
figure('name','nach disk öffnen'), imshow(removedStaffDiskOpened)

% erode to focus points
se = [1 1 1; 1 1 1; 1 1 1];
noteHeadFocused = imerode(removedStaffDiskOpened, se);
figure('name','nach Fokusierung'), imshow(noteHeadFocused);
figure('name','originalImage'), imshow(img_rot);
hold on;

% % /1.5 works best for own picture 14
% se = strel('disk',ceil(staffSpace/2.0+0.5));  
% noteHeadFocused = imopen(noteHeadFocused,se);
% figure('name','nach Fokusierung Und Öffnen'), imshow(noteHeadFocused);
% hold on;


L = bwlabel(noteHeadFocused);
stats = regionprops(L,noteHeadFocused,'Centroid');

% for i = 1:length(stats)
%     
%     x = stats(i).Centroid(1);
%     y = stats(i).Centroid(2);
%     %plot(x,y,'--rs','LineWidth',2,'MarkerFaceColor','r','MarkerSize',3);
% end


i = 1;

% extract elements, which are big enough
for k = 1 : numberOfBoundaries 

    thisBoundary = boundaries{k};
    dim2 = thisBoundary(:,1);
    dim1 = thisBoundary(:,2);
    height  = max(dim1) - min(dim1);
    width   = max(dim2) - min(dim2);

    if width >= staffSpace && height >= staffSpace
        boxes(i).dim2 = thisBoundary(:,1);
        boxes(i).dim1 = thisBoundary(:,2);
        boxes(i).min1 = min(boxes(i).dim1);
        boxes(i).min2 = min(boxes(i).dim2);
        boxes(i).max1 = max(boxes(i).dim1);
        boxes(i).max2 = max(boxes(i).dim2);
        
        i = i+1;
    end
end

sizeBoxes = size(boxes);

% draw the elements
for i = 1:length(stats)
    
    dim1 = stats(i).Centroid(1);
    dim2 = stats(i).Centroid(2);
    
    % calculate boundaries
    unfinished = 1;
    k = sizeBoxes(2);
    while k > 0 && unfinished

        if (boxes(k).min1 <= dim1) &&(boxes(k).max1 >= dim1) && (boxes(k).min2 <= dim2) && (boxes(k).max2 >= dim2)
            % found the green box, containing this red dot    
            plot(dim1,dim2,'--rs','LineWidth',2,'MarkerFaceColor','r','MarkerSize',3);
            plot(boxes(k).dim1, boxes(k).dim2, 'b', 'LineWidth', 2);
            unfinished = 0;
        end
        k = k-1;
    end
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
