%%%%%%%%%%%%%%%%%%%%%%%%%%
function [strout] = tnm034(img)

warning('off', 'Images:initSize:adjustingMag');
%
% Im: Input image of captured sheet music. Im should be in
% double format, normalized to the interval [0,1]
% strout: The resulting character string of the detected
% notes. The string must follow a pre-defined format.
%
% Your program code.
%%%%%%%%%%%%%%%%%%%%%%%%%%
img = preprocessing(img);

img = rgb2gray(img);
bin = makeBinary(img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotate image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
rotationDegree = detectRotationHough(bin);
%rotationDegree

bin_rot_comp = imrotate(imcomplement(bin), rotationDegree);
bin_rot = imcomplement(bin_rot_comp);
img_rot = imrotate(img, rotationDegree);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect the staff - get information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ clusters startStaffSystem endStaffSystem staffHeight staffSpace ] = detectStaff(bin_rot_comp);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% cut image with staff information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



[up down left right] = detectCutBorders(bin_rot_comp,startStaffSystem, endStaffSystem, staffSpace, staffHeight);

bin_rot = bin_rot(up:down,left:right);
img_rot = img_rot(up:down,left:right);
bin_rot_comp = bin_rot_comp(up:down,left:right);

%recalculate start and end staff system
startStaffSystem = startStaffSystem - up;
endStaffSystem = endStaffSystem -up;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create image variations for later
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[ removedStaff_only,removedStaff_optimizedForBoxes, noteHeadFocused] = createImageVariations( bin_rot, img_rot, bin_rot_comp,staffSpace);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect note heads
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noteHeads = detectNoteHeads( noteHeadFocused, startStaffSystem, endStaffSystem, staffSpace);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect connected objects
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

boxes = detectConnectedObjects(removedStaff_optimizedForBoxes, staffSpace);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect values
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

noteValues = detectNoteValues( removedStaff_only,img_rot,startStaffSystem, staffSpace, boxes, noteHeads);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%drawResult(img_rot,noteHeads,noteValues, staffSpace );
        
generateSaveImage(img_rot,noteHeads,noteValues, staffSpace);
%figure('name','tmp'), imshow(h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create String
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
strout = buildString( startStaffSystem, endStaffSystem,noteHeads, noteValues, staffSpace, staffHeight);


end
