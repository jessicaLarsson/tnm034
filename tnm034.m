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

imgSize = size(im)
temp = hist(im,imgSize(1))





end
