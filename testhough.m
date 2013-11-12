b = reArrangeImage('Images_Training/im3s.jpg');
b = makeBinary(b);
b = imcomplement(b);
b = imrotate(b, -0.5);

[H,theta,rho] = hough(b);
%figure, imshow(imadjust(mat2gray(H)),[],'XData',theta,'YData',rho,'InitialMagnification','fit');
%xlabel('\theta (degrees)'), ylabel('\rho');
%axis on, axis normal, hold on;
%colormap(hot)

P = houghpeaks(H,50,'threshold',ceil(0.25*max(H(:))));

x = theta(P(:,2));
y = rho(P(:,1));
plot(x,y,'s','color','black');

lines = houghlines(b,theta,rho,P,'FillGap',100,'MinLength',10);

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