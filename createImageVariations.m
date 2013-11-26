function [ removedStaff, noteHeadFocused] = createImageVariations( bin_rot, img_rot, bin_rot_comp, staffSpace )

%se = strel('disk', 3);

% remove staff out of image
se = strel('line',3,90);
%se2 = [1 1 1; 1 1 1; 1 1 1];
removedStaff = imopen(img_rot,se);
figure('name','opened originalImage'), imshow(removedStaff);
removedStaff = makeBinary(removedStaff);
removedStaff = imcomplement(removedStaff);
figure('name','opened originalImage binary'), imshow(removedStaff);

removedStaff = imopen(removedStaff,se);
removedStaff = imopen(removedStaff,se);
%figure('name','originalImage'), imshow(img_rot);
% figure('name','originalImage binary'), imshow(bin_rot_comp);
% figure('name','erodedImage - without staff'), imshow(removedStaff);
% se = [0 1 1; 1 1 0 ; 1 1 0];
% removedStaff = imdilate(removedStaff,se);
figure('name','erodedImage - without staff'), imshow(removedStaff);


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
se = strel('disk',ceil(staffSpace/2.5+0.5));
removedStaffDiskOpened = imopen(removedStaffDiskOpened,se);
%figure('name','nach disk öffnen'), imshow(removedStaffDiskOpened)

% erode to focus points
se = [1 1 1; 1 1 1; 1 1 1];
noteHeadFocused = imerode(removedStaffDiskOpened, se);
figure('name','nach Fokusierung'), imshow(noteHeadFocused);


% % /1.5 works best for own picture 14
% se = strel('disk',ceil(staffSpace/2.0+0.5));
% noteHeadFocused = imopen(noteHeadFocused,se);
% figure('name','nach Fokusierung Und Öffnen'), imshow(noteHeadFocused);
% hold on;




end

