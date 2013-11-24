function [ staffMappedNotes] = sortNotes(stats, start , ende)


mid = start + (ende-start)./2;

staffMappedNotes = repmat(struct('data',[]),length(stats),length(mid));
for i = 1:length(stats)
 [min_difference, array_position] = min(abs(mid - stats(i).Centroid(2)));
 staffMappedNotes(array_position).data = [staffMappedNotes(array_position).data; stats(i).Centroid(1) stats(i).Centroid(2)];
end

end

