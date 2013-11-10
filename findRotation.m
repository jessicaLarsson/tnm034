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
    direction = -direction;
else % down > up
    % go other direction 
    
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

% identify two highest values (a and b)
% now we have to find the highest position between those two

if beforeLast > current
    a = beforeLast;
    b = last;
    %restore best rotation until now
    currentRotation = currentRotation - direction;

else % current > beforeLast
    a = last;
    b = current;
    %restore best rotation until now
    currentRotation = currentRotation - 2*direction;
end

timesToHalf = 4;

for i = 1:timesToHalf
    direction = direction/2.0;
    currentRotation = currentRotation + direction;
    new = prctile(staffDetection(imrotate(greyImage, currentRotation),choosenFilter),choosenPrctile)/s(1);

    if a < b
        a = new;
    else % b < a
        b = new;
        %reset rotation back to last position
        currentRotation = currentRotation - direction;
    end
    
end
current
currentRotation
close all;
% half degree, until maximum is reached



end

