function [ removedStaff_only,removedStaff_optimizedForBoxes,  noteHeadFocused] = createImageVariations( bin_rot, img_rot, bin_rot_comp, staffSpace,debug )

if (nargin < 5)  ||  isempty(debug)
    debug = 0;
end

if debug
    figure('name','img_rot'), imshow(img_rot);
end

% remove staff out of image
se = strel('line',3,90);
%se2 = [1 1 1; 1 1 1; 1 1 1];
removedStaff = bin_rot_comp;
removedStaff = imopen(removedStaff,se);
removedStaff = imopen(removedStaff,se);
removedStaff_only = removedStaff;
if debug
    figure('name','removedStaff_only'), imshow(removedStaff_only);
end
removedStaff_only = bwareaopen(removedStaff_only, 2*staffSpace);
if debug
    figure('name','removedStaff_only after opening with pixelsize'), imshow(removedStaff_only);
end

% remove staff out of image
se = strel('line',3,90);
removedStaff = img_rot;
removedStaff = imopen(removedStaff,se);
removedStaff = makeBinary(removedStaff);
removedStaff = imcomplement(removedStaff);
removedStaff = imopen(removedStaff,se);
se = [0 1 0; 1 1 1; 0 1 0];
removedStaff = imdilate(removedStaff,se);
removedStaff_optimizedForBoxes = removedStaff;
if debug
figure('name','removedStaff_optimizedForBoxes'), imshow(removedStaff_optimizedForBoxes);
end

removedStaffDiskOpened = bin_rot_comp;
% fill small holes
% se = [0 1 0 ; 1 1 1; 0 1 0];
% removedStaffDiskOpened = imdilate(bin_rot_comp,se);
% figure('name','erstmal dilatieren'), imshow(removedStaffDiskOpened)

% open with a disk to mark noteheads
se = strel('disk',ceil(staffSpace/2.0));
removedStaffDiskOpened = imopen(removedStaffDiskOpened,se);
%figure('name','nach disk öffnen'), imshow(removedStaffDiskOpened)


% try to remove "Balkennoten"

% get an image with horiztonal and one with vertical lines

M = [staffSpace*2 ceil(staffSpace/2)];
se = strel('rectangle', M);
balkenV = bin_rot_comp;
balkenV = imopen(balkenV,se);


M = [ceil(staffSpace/2) staffSpace*2];
se = strel('rectangle', M);
balkenH = bin_rot_comp;
balkenH = imopen(balkenH,se);


balken = balkenH | balkenV;
%figure('name','balken'), imshow(balken);

errorDetects= removedStaffDiskOpened & balken;
%figure('name','errorDetects'), imshow(errorDetects);

errorDetects = imcomplement(errorDetects);

removedStaffDiskOpened = removedStaffDiskOpened & errorDetects;
%figure('name','nach disk öffnen - errorDetects'), imshow(removedStaffDiskOpened)

% erode to focus points
se = [1 1 1; 1 1 1; 1 1 1];
noteHeadFocused = imerode(removedStaffDiskOpened, se);

if debug
figure('name','noteHeadFocused'), imshow(noteHeadFocused);
end

end

