function [ noteHeads ] = detectNoteHeads( noteHeadFocused, startStaffSystem, endStaffSystem) 

L = bwlabel(noteHeadFocused);
noteHeads = regionprops(L,noteHeadFocused,'Centroid');
noteHeads = sortNotes(noteHeads,startStaffSystem,endStaffSystem);

end

