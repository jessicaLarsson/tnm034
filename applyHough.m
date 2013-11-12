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

numOfLines = 5


%???  THRESHOLD kontrollieren -> im Moment haben wir 4 linien ... wollen 5
P = houghpeaks(H,numOfLines+1,'threshold',ceil(0.5*max(H(:))));

if debug
    x = theta(P(:,2));
    y = rho(P(:,1));
    plot(x,y,'s','color','black');
end

lines = houghlines(b,theta,rho,P,'FillGap',100,'MinLength',1);

length(lines)


diffMatrix = zeros(numOfLines,1);

for i = 0:1:numOfLines
    disp('Runde i: ')
        i
    for j = 0:1:numOfLines
        disp('Runde j: ')
        j
        disp('lines i');
        lines(i).theta
        disp('lines j');
        lines(j).theta
        
        diffMatrix(i) = diffMatrix(i) + dist(lines(i).theta,lines(j).theta)
    end
end

diffMatrix

[B,IX] = sort(diffMatrix);
B
IX


disp('Gemessene Verdrehung')
degree = 0;
linesTakeIntoAccount = 3;
for i = 1:linesTakeIntoAccount
    degree = degree+lines(IX(i)).theta;
    lines(IX(i)).theta
end
degree = degree / linesTakeIntoAccount;
degree

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

