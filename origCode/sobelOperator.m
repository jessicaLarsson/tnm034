function filteredImage = sobelOperator(image, horizontal, vertical)
%Take the image and apply sobel-operator
% horizontal/vertical can be 0/1 for apply false/true
% Be careful, the output is not gray!!!
%image
sobel_x = [-1 -2 -1;  0  0  0;  1  2  1];
sobel_y = [-1  0  1; -2  0  2; -1  0  1];

%compute the operator
if horizontal
    gx = filter2(sobel_x,image);
    %figure('name','x');
    %imshow(gx);
end
    
if vertical
    gy = filter2(sobel_y,image);
    %figure('name','y');
    %imshow(gy);
end

% set the outputImage
if(horizontal && vertical)
    filteredImage = sqrt(gx.^2 + gy.^2);
elseif horizontal 
    filteredImage = gx;
elseif vertical 
    filteredImage = gy;
else
    error('Cannot apply operator without horizontal and vertical');
end

end

