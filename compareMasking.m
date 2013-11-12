b = reArrangeImage('Images_Training/im8s.jpg');
b = makeBinary(b);

close all;
%Sobel-filter
sobel_y = [-1 -2 -1; 0 0 0; 1 2 1];
sobel_x = [-1 0 1; -2 0 2; -1 0 1];


Gy = filter2(sobel_y, b);
Gx = filter2(sobel_x, b);

G = sqrt(Gy.^2 + Gx.^2);

figure;
subplot(2, 2, 1);

imshow(G);
title('Sobelfilter');




%Laplace-filter
laplace = [0 1 0; 1 -4 1; 0 1 0];

Z = filter2(laplace, b);
Z = abs(Z);
subplot(2, 2, 2);
imshow(Z);
title('Laplace');


%Fouriertransform
XF = fft2(b);
XF=fftshift(XF);
%XF =0.7* log(1+XF);

%Gaussian-filter
sigma = 10;
[s, p] = size(b);
[X,Y] = meshgrid(-p/2:1:p/2-1, -s/2:1:s/2-1);
Gg=exp(-(X.^2+Y.^2)./(2*sigma^2));
s_Gg = size(Gg);
    
Y = XF.*Gg;

Y = ifftshift(Y);
Y = ifft2(Y);




%Unsharp masking

A =1;
Is = b + A*(b - Y);
subplot(2, 2, 3);
imshow(Is);
