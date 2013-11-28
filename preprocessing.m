function [ img ] = preprocessing(img)

figure('name','original'), imshow(img);

blue = img(:,:,3);
%figure('name','original-bl'), imshow(blue);
summeV = sum(blue,2);
summeH = sum(blue,1);

%projection
summeV = sum(blue,2);
summeH = sum(blue,1);

% is there table above und below?
%figure('name','blueVertical'), plot(summeV);
[startEdge endEdge ] = detectTable(summeV);
img = img(startEdge:endEdge,:,:);
%figure('name','neuesOriV'), imshow(img);


% is there table right and left?
%figure('name','blueHorizontal'), plot(summeH);
[ startEdge endEdge ] = detectTable(summeH);
img = img(:,startEdge:endEdge,:);
%figure('name','neuesOriH'), imshow(img);

figure('name','neuesOri'), imshow(img);

end

