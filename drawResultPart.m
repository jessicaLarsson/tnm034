function [h] = drawResultPart( img_rot,noteHeads,noteValues , staffStart, staffEnd, noteStart, noteEnd)

h = figure('name','originalImageWithDetectedNotesAndValues');
imshow(img_rot);
hold on;

noteEndBasic = noteEnd;

for staff = staffStart:staffEnd
    
    if noteEndBasic == 0
        noteEnd = length(noteHeads(staff).data);
    end
    
    for note = noteStart:noteEnd
        
        noteX = noteHeads(staff).data(note,1);
        noteY = noteHeads(staff).data(note,2);
        
        drawNote(noteX,noteY,noteValues(staff).data(note));
    end
end

end

