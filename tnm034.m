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
rotationDegree = detectRotationHough(bin);

bin_rot_comp = imrotate(imcomplement(bin), rotationDegree);
bin_rot = imcomplement(bin_rot_comp);
img_rot = imrotate(img, rotationDegree);

s = size(bin_rot);

close all;

% plot of horizontal projection
%%%%%%
%summe = sum(bin_rot_comp,2);
%figure('name','plot of horizontal projection'),plot(summe);
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
staffSpace


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cut image with staff information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[up, down, left, right] = detectCutBorders(bin_rot_comp,startStaffSystem, endStaffSystem, staffSpace, staffHeight);

bin_rot = bin_rot(up:down,left:right);
img_rot = img_rot(up:down,left:right);
bin_rot_comp = bin_rot_comp(up:down,left:right);
s = size(bin_rot);

%recalculate start and end staff system
startStaffSystem = startStaffSystem - up;
endStaffSystem = endStaffSystem -up;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create image variations for later
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ removedStaff, noteHeadFocused] = createImageVariations( bin_rot, img_rot, bin_rot_comp,staffSpace );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note heads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noteHeads = detectNoteHeads( noteHeadFocused, startStaffSystem, endStaffSystem);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect connected objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boxes = detectConnectedObjects(removedStaff, staffSpace);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noteValues = detectNoteValues( removedStaff,img_rot,startStaffSystem, staffSpace, boxes, noteHeads );

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%drawResult(img_rot,noteHeads,noteValues);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create String
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strout = buildString( startStaffSystem, endStaffSystem,noteHeads, noteValues, staffSpace, staffHeight)



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
