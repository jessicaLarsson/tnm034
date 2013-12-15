function [startEdge endEdge ] = detectTable( projection)

startEdge = 1;
endEdge = length(projection);

% lowpassfilter the incomming data
list = 1:1:length(projection);

% get the distribution and lowpassfilter
distribution = histc(projection,list);
%figure('name','distribution'), plot(distribution);
fil = [1 2 3 4 3 2 1];
distribution = filter(fil,1,distribution);

%figure('name','distribution'), plot(distribution);


% find peaks in distribution
[pks loc] = findpeaks(distribution);
maxPik = max(pks);

% are there peaks in our distribution?
% which means edge table-paper
% and are the peaks big enough?
peakCounter = 0;
for i = 1:length(pks)
    if ( pks(i) > maxPik /2)
        peakCounter = peakCounter +1;
    end
end



if(peakCounter > 0)
    
    % get a cut level for distribution
    level = graythresh(distribution);
    
    % normalize projection
    projection = projection/length(projection);
    %figure('name','normalizedProjection'), plot(projection);
    
    % find the values above the level
    half = length(projection)/2;
    edgeProjection = find(projection(:)>level);
    
    % remove values, which are to close together
    
    % '-2' to ensure, that we save start and end value,
    % check those both at the end
    %disp('check length of edge projection')
    minEdgeDiff = length(projection)/3;
    list = length(edgeProjection)-1:-1:2;
    for i = list
        if abs(edgeProjection(i)-edgeProjection(i+1)) < minEdgeDiff
            edgeProjection(i) = [];
        end
    end
    
    if(length(edgeProjection) > 1 && abs(edgeProjection(1)-edgeProjection(end)) < minEdgeDiff)
        edgeProjection(end) = [];
    end
    
    numEdges = length(edgeProjection);
    
    % are there enough edges?
    if(numEdges > 1)
        startEdge = edgeProjection(1);
        endEdge = edgeProjection(end);
        
        %found only one edge
    elseif numEdges == 1
        if(edgeProjection(1) < half)
            startEdge = edgeProjection(1);
        else
            endEdge = edgeProjection(1);
        end
        %     else
        %         disp('found no peaks');
    end
    % else
    %     disp('no peaks in distribution');
end


end

