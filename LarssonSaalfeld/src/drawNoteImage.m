function [ img ] = drawNoteImage(img,noteX,noteY,value, staffSpace )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

switch value
    
    case 4 %1/4
        %color = 'y';
        color = [1.0 1.0 0.0];
    case 8 %1/8
        %color = 'g';
        color = [0.0 1.0 0.0];
    case 1 % not relevant
        %color = 'b';
        color = [0.0 0.0 1.0];
    case -1 %1/8
        %color = 'm';
        color = [1.0 0.0 1.0];
    otherwise
        %color = 'r';
        color = [1.0 0.0 0.0];
end

sHalf = staffSpace/2.0;
%changem(img,color,[noteY-sHalf:noteY+sHalf,noteX-sHalf:noteX+sHalf])
%img(noteY-sHalf:noteY+sHalf,noteX-sHalf:noteX+sHalf,:)
img(round(noteY-sHalf):round(noteY+sHalf),round(noteX-sHalf):round(noteX+sHalf),1) = color(1);
img(round(noteY-sHalf):round(noteY+sHalf),round(noteX-sHalf):round(noteX+sHalf),2) = color(2);
img(round(noteY-sHalf):round(noteY+sHalf),round(noteX-sHalf):round(noteX+sHalf),3) = color(3);

end

