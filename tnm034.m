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
se = strel('disk',ceil(staffSpace/3.0+0.5));  
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

i = 1;

boxes = repmat( struct('x',[],'y',[],'minX',1,'minY',1,'maxX',1,'maxY',1),1,numberOfBoundaries);

% extract elements, which are big enough
for k = 1 : numberOfBoundaries 

    thisBoundary = boundaries{k};
    y = thisBoundary(:,1);
    x = thisBoundary(:,2);
    height  = max(y) - min(y);
    width   = max(x) - min(x);

    if width >= staffSpace && height >= staffSpace
        boxes(i).x = x;
        boxes(i).y = y;
        boxes(i).minX = min(x);
        boxes(i).minY = min(y);
        boxes(i).maxX = max(x);
        boxes(i).maxY = max(y);
        
        i = i+1;
    end
end

% remove empty elements
boxes = boxes(1:i-1);
sizeBoxes = size(boxes);


% draw the elements
% for all red note heads
for i = 1:5%length(stats)
    
    noteY = stats(i).Centroid(2);
    noteX = stats(i).Centroid(1);
    
    % calculate boundaries
    unfinished = 1;
    k = sizeBoxes(2);
    % go through all boxes
    while k > 0 && unfinished

        % if red dot is in aabb
        %boxes(k).dim1
        if (boxes(k).minX <= noteX) &&(boxes(k).maxX >= noteX) && (boxes(k).minY <= noteY) && (boxes(k).maxY >= noteY)
            % found the green box, containing this red dot   
            %draw
            plot(noteX,noteY,'--rs','LineWidth',2,'MarkerFaceColor','r','MarkerSize',3);
            plot(boxes(k).x, boxes(k).y, 'b', 'LineWidth', 2);
            % make projection
            left =  noteX - staffSpace;
            right = noteX + staffSpace;
            left 
            right
            
            currBox = [];
            currBox = [0 0];
            aabb = [];
            aabb = [aabb; left boxes(k).maxY];
            aabb = [aabb; left boxes(k).minY];
            aabb = [aabb; right boxes(k).minY];
            aabb = [aabb; right boxes(k).maxY];
            aabb = [aabb; left boxes(k).maxY];
            
            plot(aabb(:,1),aabb(:,2), 'm', 'LineWidth', 2);
            
            % get all points out of blue box in this boundary
            %disp('boxes(k).dim1')
            %boxes(k).dim2
%             for j = 1:length(boxes(k).x)
%                 boderPointX = boxes(k).x(j);
%                 boderPointY = boxes(k).y(j);
%                 % if blue point is in our small box
%                 if left <= boderPointX && right >= boderPointX
%                     
%                     %disp('punkt gefunden');
%                    % d1 
%                    % d2
%                      currBox = [currBox; boderPointX boderPointY];
%                      %currBox
%                  end
%             end
            
            currBoxImage = removedStaff(boxes(k).minY:boxes(k).maxY,floor(left):ceil(right));
            
            
            figure('name','cut') ,imshow(currBoxImage);
            
            pixelCut = round(noteY);
            
            upperHalf =  removedStaff(boxes(k).minY:pixelCut-1    ,floor(left):ceil(right));
            upperHalf = flipdim(upperHalf,1);
            lowerHalf =  removedStaff(pixelCut     :boxes(k).maxY ,floor(left):ceil(right));
            

            
            sUpperHalf = size(upperHalf);
            sLowerHalf = size(lowerHalf);
            
            %increase image to correct size
            if sUpperHalf(1) > sLowerHalf(1)
                lowerHalf = [lowerHalf; zeros(sUpperHalf(1)-sLowerHalf(1),sLowerHalf(2))];
                
            elseif sLowerHalf(1) > sUpperHalf(1)
                upperHalf =[upperHalf; zeros(sLowerHalf(1)-sUpperHalf(1),sUpperHalf(2))];   
            end
            
            figure('name','upper'),imshow(upperHalf);
            figure('name','lower'),imshow(lowerHalf);
            res = upperHalf + lowerHalf;
            figure('name','res'),imshow(res);
            
            
            %summeH = sum(currBoxImage,1);
            %figure('name','plot of horizontal projection'),bar(summeH);
            summeV = sum(currBoxImage,2);
            figure('name','plot of vert projection'),bar(summeV);
           
            
          
            figure('name','cutori'),imshow(removedStaff);
            
%             
%             t = tabulate(currBox(:,2))
%             countSums = t(t(:,2)~=0, 2);
%             countSums
%             countValues = t(t(:,2)~=0, 1);
%             countValues
%             
            
            
            %plot(currBox(:,1), currBox(:,2), 'g');%, 'LineWidth', 2);
            for l = 1:length(currBox(:,1))
                plot(currBox(l,1), currBox(l,2), 'g');%, 'LineWidth', 2);
            end
            unfinished = 0;
            
            %figure('name','horizontale Zählung'),plot(countValues,countSums);
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
