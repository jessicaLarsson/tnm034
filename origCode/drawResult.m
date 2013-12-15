function [h] = drawResult( img_rot,noteHeads,noteValues, staffSpace  )

staffStart = 1;
staffEnd = length(noteHeads);

noteStart = 1;
noteEnd = 0;

h = drawResultPart(img_rot, noteHeads, noteValues , staffStart, staffEnd, noteStart, noteEnd, staffSpace );

end


