function [ optimalRotation ] = findRotation( greyImage )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

s = size(greyImage);
choosenPrctile = 90;
choosenFilter = 1;

%get rating of original Image
data = staffDetection(greyImage,choosenFilter);
originValue = prctile(data,choosenPrctile)/s(1);
last = originValue;

direction = 1; %Stepwidth to go
% try one degree in each direction
up   = prctile(staffDetection(imrotate(greyImage, direction),choosenFilter),choosenPrctile)/s(1);
down = prctile(staffDetection(imrotate(greyImage,-direction),choosenFilter),choosenPrctile)/s(1);

%first step: identify direction to go

%a) find initial direction

if up > down
    % direction is already correct
    current = up;
else % down > up
    % go other direction 
    direction = direction*(-1);
    current = down;
end
    
current 
currentRotation = direction;
%b) increase one degree every step  
beforeLast = 0;
while(current > last)
    beforeLast = last;
    last = current;
    currentRotation = currentRotation + direction;
    current = prctile(staffDetection(imrotate(greyImage, currentRotation),choosenFilter),choosenPrctile)/s(1);
    current
end

% identify two highest values
% now we have to find the highest position between those two

for i = 1:3
    firstValue = last;
    secondValue = 0;

    %restore best rotation until now
    currentRotation = currentRotation - direction;

    if beforeLast > current
        secondValue = beforeLast
        direction = -direction;
    else % current > beforeLast
        secondValue = current;
    end


     while(current > last)
         direction = direction/2.0; 
        beforeLast = last;

        last = current;
        currentRotation = currentRotation + direction;
        current = prctile(staffDetection(imrotate(greyImage, currentRotation),choosenFilter),choosenPrctile)/s(1);
        current
     end
     
     end
end
    
close all;
% half degree, until maximum is reached



end

