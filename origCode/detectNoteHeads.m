function [ noteHeads ] = detectNoteHeads( noteHeadFocused, startStaffSystem, endStaffSystem, staffSpace) 

L = bwlabel(noteHeadFocused);
noteHeads = regionprops(L,noteHeadFocused,'Centroid');
noteHeads = sortNotes(noteHeads,startStaffSystem,endStaffSystem, staffSpace);

end

