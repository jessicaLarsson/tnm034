%%%%%%%%%%%%%%%%%%%%%%%%%%
function strout = tnm034(im)
%
% Im: Input image of captured sheet music. Im should be in
% double format, normalized to the interval [0,1]
% strout: The resulting character string of the detected
% notes. The string must follow a pre-defined format.
%
% Your program code.
%%%%%%%%%%%%%%%%%%%%%%%%%%

b = makeBinary(im);



%rotationDegree = findRotationHough(b,1);
%rotationDegree = findRotationHoughIterative(im,b,1);
rotationDegree = findRotationIterative(im);
b_rot = imrotate(b, rotationDegree);
close all;
figure
imshow(b)
figure
imshow(b_rot);






end
