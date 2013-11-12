function [ optimalRotation ] = findRotationIterative( greyImage )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

s = size(greyImage);
choosenPrctile = 95;
choosenFilter = 1;

%get rating of original Image
data = staffDetection(greyImage,choosenFilter);
bestValue = prctile(data,choosenPrctile)/s(1);
bestRot = 0;
%last = originValue;

stepwidth = 1;

% bestValue


for i = -5:1:5 
    new = prctile(staffDetection(imrotate(greyImage, i),choosenFilter),choosenPrctile)/s(1);
    if new > bestValue
        bestValue = new;
        bestRot = i;
%         close all;
%         bestValue
%         bestRot
    end
end



tmpRotation = bestRot;

a = prctile(staffDetection(imrotate(greyImage, bestRot - stepwidth),choosenFilter),choosenPrctile)/s(1);
b = prctile(staffDetection(imrotate(greyImage, bestRot + stepwidth),choosenFilter),choosenPrctile)/s(1);

while (abs(abs(a-b)/a) > 0.005)
    stepwidth = stepwidth/2.0;
    tmpRotation = tmpRotation + stepwidth;
    new = prctile(staffDetection(imrotate(greyImage, tmpRotation),choosenFilter),choosenPrctile)/s(1);

    if a < b
        a = new;
    else % b < a
        b = new;
        % save rotation for a and make a smaller step next time
        tmpRotation = tmpRotation - stepwidth;
    end
%     disp ('values')
%     a
%     b
end

disp('best')
if a < b
      b
     tmpRotation = tmpRotation + stepwidth;
else % b < a
      a

end
close all;

disp('with rotation')
tmpRotation
data = staffDetection(imrotate(greyImage,tmpRotation),1,1);
[pks, locs] = findpeaks(data);
pks
locs


% half degree, until maximum is reached



end

