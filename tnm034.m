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

close all;

% plot of horizontal projection
    %%%%%% 
    s = size(bin_rot);
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
%weichzeichner
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fk = [1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1; 1 1 1 1 1 ];
% fk = fk./ sum(fk(:));
% fk
% w = conv2(fk,img_rot);
% figure
% imshow(w);
% r = makeBinary(w,1);
% figure
% imshow(r);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect staff to determine staffSpace and sattHeight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% erode once and get difference to increase importancy of staff lines
se = [1 1 1; 1 1 1; 1 1 1];
erodedBW = imerode(bin_rot_comp,se);
    %figure, imshow(bin_rot_comp), figure, imshow(erodedBW)
erodedBW_comp = imcomplement(erodedBW);
diff = erodedBW_comp - bin_rot;
diff = im2bw(diff);
    figure, imshow(diff);
% sum values of each row of diff, to get horizontal projection
summe = sum(diff,2);
% find peaks in horizontal projection
[pks,locs] = findpeaks(summe);
% normalize between 0 and 1
pksOfHorizProjection = mat2gray(pks);
vector = pksOfHorizProjection(:);
    figure('name','PikHistogram'), hist(vector,20);
% get level between staff and notes etc.
%level = graythresh(pksOfHorizProjection);
% alternative level calculation
level = 0.3
% binarize peaks with level
peaks = im2bw(pksOfHorizProjection, level);

figure
imshow(peaks);
locationOfPeaks = locs.*peaks;
locationOfPeaks(locationOfPeaks==0) = [];
length(locationOfPeaks)

disp('We expect clusters');
numOfStaffSystems = floor(length(locationOfPeaks)/5);
numOfStaffSystems

s = size(diff);
seedPointsDistance = floor((locationOfPeaks(end)-locationOfPeaks(1))/(numOfStaffSystems-1));
seedPoints = locationOfPeaks(1):seedPointsDistance:locationOfPeaks(end);

seeds_x = seedPoints;
seeds_y = floor(s(2)/2)*ones(numOfStaffSystems,1);
seeds_x
%x(1:10) = 5;

[IDX,C,sumd,D] = kmeans(locationOfPeaks,[],'start',seeds_x');
%??? sind wir sicher, dass jeder cluster nur 5 elemente hat?
%IDX
%C
%sumd
%D
%figure('name','D'),plot(mat2gray(D));

if mod(length(IDX),5) ~= 0
    disp('da passt was nicht');
    values = unique(IDX);
	instances = histc(IDX,values);
    
    for i = 1:values(end)
        if instances(i) < 5
            instances(i)
            error('There are less than 5 values in the cluster, please check!');
        elseif instances(i) > 5
            disp('entferne');
            startPoint = (i-1)*5+1;
            data = locationOfPeaks(startPoint:startPoint+4);
            out = getOutlierIndex(data);
            out
            locationOfPeaks(startPoint-1+out) = [];
            IDX(startPoint-1+out) = [];
        end
    end
end

figure('name','cluster'), imshow(diff);
hold on;
s = size(diff);
for i= 1:length(locationOfPeaks)
    switch IDX(i)
        case 1
            color = 'r';
        case 2 
            color = 'y';
        case 3
            color = 'g';
        case 4
            color = 'b';
        case 5 
            color = 'm';
        case 6 
            color = 'c';
        case 7 %orange
            color = [1.0, 0.5, 0.0];
        otherwise
            color = [0.5, 0.5, 0.5];
    end
    height = locationOfPeaks(i);
    plot([1,s(2)],[height,height],'Color',color,'LineWidth',2);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect size of staff paramters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startStaffSystem = zeros(numOfStaffSystems,1);
  endStaffSystem = zeros(numOfStaffSystems,1);
  
for i = 1:numOfStaffSystems
    startStaffSystem(i) = locationOfPeaks((i-1)*5+1);
      endStaffSystem(i) = locationOfPeaks((i-1)*5+5);
end

startStaffSystem
endStaffSystem

summedStaffDistance = sum(endStaffSystem-startStaffSystem);
staffSpace = summedStaffDistance/(4*numOfStaffSystems);
staffSpace = (floor(staffSpace-1.5));
staffSpace

staffHeight = (summedStaffDistance-staffSpace*4*numOfStaffSystems)/(5*numOfStaffSystems);
staffHeight

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cut image with staff information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dimensionsOfImage = size(bin_rot);

verticalOffset = (5*staffSpace+4*staffHeight);
up = max(startStaffSystem(1) - verticalOffset,1);
down = min(endStaffSystem(end) + verticalOffset, dimensionsOfImage(2)); ;

bin_rot = bin_rot(up:down,:);
img_rot = img_rot(up:down,:);
bin_rot_comp = bin_rot_comp(up:down,:);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note heads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%se = strel('disk', 3);
% remove staff
se = strel('line',3,90);
se = [1 1 1; 1 1 1; 1 1 1];
erodedBW = imerode(bin_rot_comp,se);
figure, imshow(bin_rot_comp), figure, imshow(erodedBW)

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
