
%jfgafhasf
function img = reArrangeImage(fileName)

originalImage = im2double(imread(fileName));
originalImage;
%img = originalImage./256.0;


img = rgb2gray(originalImage);

end

