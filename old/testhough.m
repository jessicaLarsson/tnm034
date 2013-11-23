close all
b = reArrangeImage('logo.jpg');
%b = reArrangeImage('Images_Training/im8s.jpg');
b = makeBinary(b);

b = sobelOperator(b,1,1);
%b = imcomplement(b);

b = imrotate(b, 15.3);

%first go over all degrees

%[H,theta,rho] = hough(b);
[H, theta, rho] = hough(b,'RhoResolution',0.5,'Theta',-90:0.5:89.5);
figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on, axis normal, hold on;
%colormap(hot)

P = houghpeaks(H,1,'threshold',ceil(0.5*max(H(:))));

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');

lines = houghlines(b,theta,rho,P,'FillGap',100,'MinLength',10);
%??? instead of using one line use 3 or more lines to get rotation angle
% then look the variance of them
%small: ok
% high: take more lines to get a more confidence value
t = lines.theta

%[H,theta,rho] = hough(b);
thetaStart = t-2;
thetaEnde =t+2;
if thetaEnde >=90
    thetaEnde=89.9;
end

if thetaStart < -90
    thetaStart = -90;
end

[H, theta, rho] = hough(b,'RhoResolution',0.1,'Theta',thetaStart:0.1:thetaEnde);
figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
xlabel('\theta (degrees)'), ylabel('\rho');
axis on, axis normal, hold on;
%colormap(hot)

P = houghpeaks(H,25,'threshold',ceil(0.5*max(H(:))));

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');

lines = houghlines(b,theta,rho,P,'FillGap',100,'MinLength',10);
lines.theta

degree = lines.theta 
degree = degree - 90.0
rotIm = imrotate(b,degree);
staffDetection(rotIm,1,1);

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