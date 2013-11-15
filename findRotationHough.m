function [ optimalRotation ] = findRotationHough( binaryImage,debug)

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

degree = applyHough(b,-90,89.9,stepSizeGlobalHough,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% refinement step
degree = degree +90;

thetaStart = degree-3*stepSizeGlobalHough;
thetaEnde  = degree+3*stepSizeGlobalHough;

if thetaEnde >=180
    thetaEnde=179.99;
end

if thetaStart < 0
    thetaStart = 0;
end

thetaStart = thetaStart -90;
thetaEnde  = thetaEnde  -90;

if(debug)
    thetaStart
    thetaEnde
end

degree = applyHough(b,thetaStart, thetaEnde,stepSizeLocalHough,1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% adapt got optimal rotation

degree = degree + 90;
optimalRotation = degree;


end

