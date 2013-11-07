
%jfgafhasf
function img = reArrangeImage(fileName)

originalImage = double(imread(fileName));
originalImage
img = originalImage./256.0;


img = rgb2gray(img);

end

