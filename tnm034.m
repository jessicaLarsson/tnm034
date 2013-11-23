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

if up < 1
    up = 1;
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

if left < 1
    left = 1;
end

if right > s(2)
    right = s(2);
end

bin_rot = bin_rot(up:down,left:right);
img_rot = img_rot(up:down,left:right);
bin_rot_comp = bin_rot_comp(up:down,left:right);
s = size(bin_rot);

%recalculate start and end staff system
startStaffSystem = startStaffSystem - up;
endStaffSystem = endStaffSystem -up;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note heads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%se = strel('disk', 3);


% remove staff out of image
se = strel('line',3,90);
se2 = [1 1 1; 1 1 1; 1 1 1];
removedStaff = imopen(bin_rot_comp,se);
removedStaff = imopen(removedStaff,se);
%removedStaff = imerode(removedStaff,se);
figure('name','originalImage'), imshow(img_rot);
figure('name','originalImage binary'), imshow(bin_rot_comp);
figure('name','erodedImage - without staff'), imshow(removedStaff);
hold on;



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

% 1se 3
% 1s  2
% open with a disk to mark noteheads
se = strel('disk',ceil(staffSpace/2.0+0.5));
removedStaffDiskOpened = imopen(removedStaffDiskOpened,se);
figure('name','nach disk öffnen'), imshow(removedStaffDiskOpened)

% erode to focus points
se = [1 1 1; 1 1 1; 1 1 1];
noteHeadFocused = imerode(removedStaffDiskOpened, se);
figure('name','nach Fokusierung'), imshow(noteHeadFocused);


% % /1.5 works best for own picture 14
% se = strel('disk',ceil(staffSpace/2.0+0.5));
% noteHeadFocused = imopen(noteHeadFocused,se);
% figure('name','nach Fokusierung Und Öffnen'), imshow(noteHeadFocused);
% hold on;






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect connected notes
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get bounding boxes
boundaries = bwboundaries(removedStaff);
numberOfBoundaries = size(boundaries);

% extract elements, which are big enough
boxes = repmat( struct('x',[],'y',[],'minX',1,'minY',1,'maxX',1,'maxY',1),1,numberOfBoundaries);

i = 1;
for k = 1 : numberOfBoundaries
    
    thisBoundary = boundaries{k};
    y = thisBoundary(:,1);
    x = thisBoundary(:,2);
    height  = max(y) - min(y);
    width   = max(x) - min(x);
    
    if width >= staffSpace && height >= 2*staffSpace
        boxes(i).x = x;%
        boxes(i).y = y;%
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


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note heads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
L = bwlabel(noteHeadFocused);
noteHeads = regionprops(L,noteHeadFocused,'Centroid');
noteHeads = sortNotes(noteHeads,startStaffSystem,endStaffSystem);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure('name','originalImage'), imshow(img_rot);
hold on;

% draw the note heads

for staff = 1:length(startStaffSystem)
    % for all red note heads
    for i = 1:length(noteHeads(staff).data)
        
        noteX = noteHeads(staff).data(i,1);
        noteY = noteHeads(staff).data(i,2);
        plot(noteX,noteY,'--rs','LineWidth',2,'MarkerFaceColor','r','MarkerSize',2);
    end
end

%draw blue lines
for k = 1:sizeBoxes(2)
    plot(boxes(k).x, boxes(k).y, 'b', 'LineWidth', 2);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect value
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%noteValues = repmat( struct('data',[]),1,numOfValues);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure('name','originalImage'), imshow(img_rot);
hold on;

numberOfStaffSystems = length(startStaffSystem);

numOfValues = length(noteHeads(staff).data);


debug = 1
%1 eingefärbte noten
%2 histogramme
    
    

if debug == 1
    numOfValues = length(noteHeads(staff).data);
    noteStart = 1;
    staffStart = 1;
    staffEnd = numberOfStaffSystems;
end
vertis = repmat( struct('data',[]),1,numOfValues);
if debug == 2
    noteStart = 9;
    numberOfNotes = noteStart+4;
    staffStart = 3;
    staffEnd = 3;
end
    

for staff = staffStart:staffEnd
    % for all red note heads
    if debug == 1
        numberOfNotes=length(noteHeads(staff).data);
    end
    
    for i = noteStart:numberOfNotes
        
        noteX = noteHeads(staff).data(i,1);
        noteY = noteHeads(staff).data(i,2);
        
        % calculate boundaries
        unfinished = 1;
        k = sizeBoxes(2);
        % go through all boxes
        while k > 0 && unfinished
            
            % if red dot is in aabb
            %boxes(k).dim1
            if (boxes(k).minX <= noteX) &&(boxes(k).maxX >= noteX) && (boxes(k).minY <= noteY) && (boxes(k).maxY >= noteY)
                
                % make projection
                left =  noteX - 1.15*staffSpace;
                right = noteX + 1.15*staffSpace;
                
                currBox = [];
                currBox = [0 0];
                aabb = [];
                aabb = [aabb; left boxes(k).maxY];
                aabb = [aabb; left boxes(k).minY];
                aabb = [aabb; right boxes(k).minY];
                aabb = [aabb; right boxes(k).maxY];
                aabb = [aabb; left boxes(k).maxY];
                
                
                %plot(aabb(:,1),aabb(:,2), 'm', 'LineWidth', 2);
                
                
                left = floor(left);
                right = ceil(right);
                
                if left < 1
                    left = 1;
                end
                
                if right > s(2)
                    right = s(2);
                end
                
                pixelCut = round(noteY);
                
                upperHalf =  removedStaff(boxes(k).minY:pixelCut-1    ,left:right);
                upperHalf = flipdim(upperHalf,1);
                lowerHalf =  removedStaff(pixelCut     :boxes(k).maxY ,left:right);
                
                
                
                sUpperHalf = size(upperHalf);
                sLowerHalf = size(lowerHalf);
                
                %increase image to correct size
                if sUpperHalf(1) > sLowerHalf(1)
                    lowerHalf = [lowerHalf; zeros(sUpperHalf(1)-sLowerHalf(1),sLowerHalf(2))];
                    
                elseif sLowerHalf(1) > sUpperHalf(1)
                    upperHalf =[upperHalf; zeros(sLowerHalf(1)-sUpperHalf(1),sUpperHalf(2))];
                end
               
                
                % cut upper part to get only "faehnchen"
                res = upperHalf + lowerHalf;
                if debug == 2
                    figure('name','res'),imshow(res);
                end
                sizeRes = size(res,1);
                resultWidth = sizeRes-1.5*staffSpace;
                startCut    = sizeRes-resultWidth;
                res = res(startCut:sizeRes,:);
                
                if debug == 2
                    figure('name','res'),imshow(res);
                end
                
                
                summeV = sum(res,2);
                
                %lowpassfilter
                fil = [ 1 2 3 2 1];
                summeVertiFiltered = filter(fil,1,summeV);
                summeVertiFiltered = [1;summeVertiFiltered];
                summeVertiFiltered = [summeVertiFiltered;1];
                
                if debug == 2
                    %figure('name','plot of vert projection'),bar(summeVertiFiltered);
                     vertis(i).data = summeVertiFiltered;
                end
               
                
                
                [vertPiks] = findpeaks(summeVertiFiltered);
                numOfPeaks = sum(vertPiks > max(vertPiks)/2);
            
                
                color = 'c'
                switch numOfPeaks
                    case 0
                        color = 'r';
                    case 1
                        color = 'g';
                    otherwise
                        color = 'y';
                end
                
                if debug == 1
                	plot(noteX,noteY,'--rs','MarkerFaceColor',color,'MarkerSize',7);
                end
                
                unfinished = 0;
                
            end
            k = k-1;
        end
    end
end

if debug == 2
for i = 1:min(numOfValues, numberOfNotes)
    figure('name','plot of vert projection'),bar(vertis(i).data);
end
end

noteValues = 0;
buildString( startStaffSystem, endStaffSystem,noteHeads, noteValues, staffSpace, staffHeight)


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
