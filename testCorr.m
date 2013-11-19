% template = .2*ones(11); % Make light gray plus on dark gray background
% template(6,3:9) = .6;   
% template(3:9,6) = .6;
% BW = template > 0.5;      % Make white plus on black background
% figure, imshow(BW), figure, imshow(template)
% % Make new image that offsets the template
% offsetTemplate = .2*ones(21); 
% offset = [3 5];  % Shift by 3 rows, 5 columns
% offsetTemplate( (1:size(template,1))+offset(1),...
%                 (1:size(template,2))+offset(2) ) = template;
% figure, imshow(offsetTemplate)
%     
% % Cross-correlate BW and offsetTemplate to recover offset  
% cc = normxcorr2(BW,offsetTemplate); 
% [max_cc, imax] = max(abs(cc(:)));
% [ypeak, xpeak] = ind2sub(size(cc),imax(1));
% corr_offset = [ (ypeak-size(template,1)) (xpeak-size(template,2)) ];
% isequal(corr_offset,offset) % 1 means offset was recovered

htm=vision.TemplateMatcher;
 hmi = vision.MarkerInserter('Size', 10, ...
    'Fill', true, 'FillColor', 'White', 'Opacity', 0.75); I = imread('Images_Training/im1s.jpg');

% Input image
  I = I(1:200,1:200,:); 

% Use grayscale data for the search
  Igray = rgb2gray(I);     

% Use a second similar chip as the template
  T = Igray(20:75,90:135) 

% Find the [x y] coordinates of the chip's center
  Loc=step(htm,Igray,T);  

% Mark the location on the image using white disc
  J = step(hmi, I, Loc);

imshow(T); title('Template');
figure; imshow(J); title('Marked target');