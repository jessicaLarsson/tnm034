function [ staffMappedNotes] = sortNotes(stats, start , ende, staffSpace)


mid = start + (ende-start)./2;

staffMappedNotes = repmat(struct('data',[]),length(stats),length(mid));

% filter border notes away
k = 1;
while k <= length(stats)
 if stats(k).Centroid(1) < staffSpace
    stats(k) = [];
    k = k -1;
 end
 k = k+1;
end


for i = 1:length(stats)
 [min_difference, array_position] = min(abs(mid - stats(i).Centroid(2)));
 staffMappedNotes(array_position).data = [staffMappedNotes(array_position).data; stats(i).Centroid(1) stats(i).Centroid(2)];
end

end

