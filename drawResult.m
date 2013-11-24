function [] = drawResult( img_rot,noteHeads,noteValues )

staffStart = 1;
staffEnd = length(noteHeads);

noteStart = 1;
noteEnd = 0;

drawResultPart(img_rot, noteHeads, noteValues , staffStart, staffEnd, noteStart, noteEnd);

end


