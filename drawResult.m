function [] = drawResult( img_rot,noteHeads,noteValues )

figure('name','originalImageWithDetectedNotesAndValues'), imshow(img_rot);
hold on;


for staff = 1:length(noteHeads)
    for note = 1:length(noteHeads(staff).data)
        
        noteX = noteHeads(staff).data(note,1);
        noteY = noteHeads(staff).data(note,2);
        
        drawNote(noteX,noteY,noteValues(staff).data(note));
    end
end
end

