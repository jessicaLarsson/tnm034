function [ optimalRotation ] = detectRotationHough( binaryImage,debug)

% Set default values if the argument wasn't passed in, or is empty, as in []
if (nargin < 2)  ||  isempty(debug)
    debug = 0;
end
    

%edge detection
b = sobelOperator(binaryImage,1,1);

%test
%b = imrotate(b, -15.3);

%first go over all degrees

stepSizeGlobalHough = 0.5;
stepSizeLocalHough = 0.05;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global step

degree = applyHough(b,-90,89.9,stepSizeGlobalHough);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% refinement step

thetaStart = degree-2*stepSizeGlobalHough;
thetaEnde  = degree+2*stepSizeGlobalHough;

if thetaEnde >=90
    thetaEnde=89.999;
end

if thetaStart < -90
    thetaStart = -90;
end

if(debug)
    thetaStart
    thetaEnde
end

degree = applyHough(b,thetaStart, thetaEnde,stepSizeLocalHough);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adapt got optimal rotation

%degree = -(90-abs(degree)); + pipi - 3

% offset of matlab rot and hough
degree = degree -90.0;

if(degree < -90.0)
    degree = degree +180.0;
end

if(degree > 90.0)
    degree = degree -180.0;
end
optimalRotation = degree;

end

