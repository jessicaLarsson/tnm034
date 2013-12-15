function [ fileName ] = getCompareName( file )
k = cell2mat(strfind(file,'/'));
l = length(char(file));
fileName = char(file);
fileName = fileName(k+1:l);
fileName = strrep(fileName,'.jpg','_compare');

end

