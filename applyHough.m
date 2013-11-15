function [ degree ] = applyHough(b,start,ende,stepsize,debug)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set default values if the argument wasn't passed in, or is empty, as in []
if (nargin < 5)  ||  isempty(debug)
    debug = 0;
end

[H, theta, rho] = hough(b,'RhoResolution',stepsize,'Theta',start:stepsize:ende);

if debug
    figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
    xlabel('\theta (degrees)'), ylabel('\rho');
    axis on, axis normal, hold on;
end

numOfLinesToFind = 10;
numOfLinesToUse = 5;

numLinesFound = 0;
factor = 0.5;
lines = 0;

while (numLinesFound < numOfLinesToFind)
    P = houghpeaks(H,numOfLinesToFind,'threshold',ceil(factor*max(H(:))));
    factor = factor*0.8;

    if debug
        x = theta(P(:,2));
        y = rho(P(:,1));
        plot(x,y,'s','color','black');
    end

    lines = houghlines(b,theta,rho,P,'FillGap',100,'MinLength',1);

    numLinesFound = length(lines);
end

numOfLinesToFind

diffMatrix = zeros(numOfLinesToFind,1);

for i = 1:numOfLinesToFind
    disp('Runde i: ')
        i
    for j = 1:numOfLinesToFind
        disp('Runde j: ')
        j
        disp('lines i');
        lines(i).theta
        disp('lines j');
        lines(j).theta
        
        diffMatrix(i) = diffMatrix(i) + dist(lines(i).theta,lines(j).theta)
    end
end


[B,IX] = sort(diffMatrix);
B
IX


disp('Gemessene Verdrehung')
degree = 0;
for i = 1:numOfLinesToUse
    degree = degree+lines(IX(i)).theta;
    disp('want to use: ')
    lines(IX(i)).theta
    lines(IX(i)).theta;
end
degree = degree / numOfLinesToUse;
degree

while degree > 90
    degree = degree-180;
end

while degree < -90
    degree = degree + 180;
end

if debug
    figure, imshow(b), hold on
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',2,'Color','green');

       % Plot beginnings and ends of lines
       plot(xy(1,1),xy(1,2),'x','LineWidth',2,'Color','yellow');
       plot(xy(2,1),xy(2,2),'x','LineWidth',2,'Color','red');

       % Determine the endpoints of the longest line segment
       len = norm(lines(k).point1 - lines(k).point2);
       if ( len > max_len)
          max_len = len;
          xy_long = xy;
       end
    end

    % highlight the longest line segment
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','blue');
end

end

