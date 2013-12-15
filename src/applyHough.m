function [ degree ] = applyHough(b,start,ende,stepsize,debug)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Set default values if the argument wasn't passed in, or is empty, as in []
if (nargin < 5)  ||  isempty(debug)
    debug = 0;
end

rhoResolution = 1; %not smaller than pixel size!!!!
[H, theta, rho] = hough(b,'RhoResolution',rhoResolution,'Theta',start:stepsize:ende);

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

    lines = houghlines(b,theta,rho,P,'FillGap',100,'MinLength',length(b)/5);

    numLinesFound = length(lines);
end

diffMatrix = zeros(numOfLinesToFind,1);

for i = 1:numOfLinesToFind
    %disp('Runde i: ')
    %i
    for j = 1:numOfLinesToFind
        %         disp('Runde j: ')
        %         js
        %         disp('lines i');
        %         lines(i).theta
        %         disp('lines j');
        %         lines(j).theta

        diffMatrix(i) = diffMatrix(i) + dist(lines(i).theta,lines(j).theta);
    end
end


[B,IX] = sort(diffMatrix);
B;
IX;


%disp('Gemessene Verdrehung')
degree = 0;
numbOfLinesUnequalZero = 0.0;
for i = 1:numOfLinesToUse
    %disp('want to use: ')
    %lines(IX(i)).theta
    if abs(lines(IX(i)).theta) > 0.001
        numbOfLinesUnequalZero = numbOfLinesUnequalZero+1.0;
        %disp('add')
        % a = sign(lines(IX(i)).theta)*90-lines(IX(i)).theta;
        % a
        degree = degree + sign(lines(IX(i)).theta)*90-lines(IX(i)).theta;
        %disp('summed')
        %degree
    end
end
degree = degree / numbOfLinesUnequalZero;
degree = sign(degree)*90 - degree;
%degree

if abs(degree) < 1.0e-6
    degree = -90;
end

if debug
    figure, imshow(imcomplement(b)), hold on
    max_len = 0;
    for k = 1:length(lines)
       xy = [lines(k).point1; lines(k).point2];
       plot(xy(:,1),xy(:,2),'LineWidth',6,'Color','blue');

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
    plot(xy_long(:,1),xy_long(:,2),'LineWidth',3,'Color','red');
end

if debug
    disp('degree in apply Hough')
    degree
    disp('applyHoughReady');
end



end


