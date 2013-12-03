function [ img] = generateSaveImage( img_rot,noteHeads,noteValues, staffSpace )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
s = size(img_rot);
img_rot = repmat(double(img_rot)./1,[1 1 3]);

staffStart = 1;
staffEnd = length(noteHeads);

noteStart = 1;
noteEnd = 0;


img = img_rot;

noteEndBasic = noteEnd;

for staff = staffStart:staffEnd
    
    if noteEndBasic == 0
        noteEnd = length(noteHeads(staff).data);
    end
    
    for note = noteStart:noteEnd
        
        noteX = noteHeads(staff).data(note,1);
        noteY = noteHeads(staff).data(note,2);
        
        img = drawNoteImage(img,noteX,noteY,noteValues(staff).data(note), staffSpace );
    end
end




end

