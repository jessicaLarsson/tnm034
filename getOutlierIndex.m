function [ index ] = getOutlierIndex( data )

summedValues = zeros(length(data),1);

for i = 1:length(data)
    for j = 1:length(data)
        summedValues(i) = summedValues(i) + dist(data(i),data(j));
    end
end

[v,i] = max(summedValues);
index = i;

end

