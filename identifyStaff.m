function sum = identifyStaff(img)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

% first calculate expected value per line
imgSize = size(img);



sum = [imgSize(1)]

for r = 1:imgSize(1)
    sum(r) = 0;
    for c = 1:imgSize(2)
        disp(fprintf(' %d %d %f',r,c, img(r,c)));
        sum(r) = sum(r) + img(r,c);
    end
    sum(r) = sum(r) / imgSize(2)

end

end

