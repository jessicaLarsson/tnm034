function [ func ] = gauss( binaryImage )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

vec = binaryImage(:);

s  = size(vec);

sum = 0;
for i = 1:s(1)
	sum = sum + vec(i);
end

arithMittel = sum/s(1);

sum = 0;
for i = 1:s(1)
sum = sum + (vec(i)-arithMittel)*(vec(i)-arithMittel);
end

sigma =  sqrt(sum * 1.0/(s(1)-1));


 func = @(x) 1.0/(sqrt(2*3.141)*sigma)*exp(-0.5*((x-arithMittel)/sigma)^2);

end

