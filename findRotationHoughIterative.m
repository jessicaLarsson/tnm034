function [  tmpRotation ] = findRotationHoughIterative(greyImage,binaryImage,debug )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set default values if the argument wasn't passed in, or is empty, as in []
if (nargin < 3)  ||  isempty(debug)
    debug = 0;
end

 

%edge detection
b = sobelOperator(binaryImage,1,1);

%test
%b = imrotate(b, -15.3);

%first go over all degrees

stepSizeGlobalHough = 0.5;

stepwidth = 1;
s = size(binaryImage);
choosenPrctile = 95;
choosenFilter = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global step

degree = applyHough(b,-90,89.9,stepSizeGlobalHough,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adapt got optimal rotation

degree = degree + 90;
bestRot = degree;
disp('global');
bestRot

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% hough finished, start iterative
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% refine rotatoin with small stepsize
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
     disp ('values')
     a
     b
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate final best rotation
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
pks;
locs;

end

