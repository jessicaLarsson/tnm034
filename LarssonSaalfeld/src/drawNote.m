function [] = drawNote( noteX, noteY, value, staffSpace )

switch value
    
    case 4 %1/4
        color = 'y';
    case 8 %1/8
        color = 'g';
    case 1 % not relevant
        color = 'b';
    case -1 %1/8
        color = 'm';
    otherwise
        color = 'r';
end
plot(noteX,noteY,'--rs','MarkerFaceColor',color,'MarkerSize',staffSpace-1,'MarkerEdgeColor','b');

end

