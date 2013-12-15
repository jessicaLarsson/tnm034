function [ boxes] = detectConnectedObjects( removedStaff, staffSpace )

% get bounding boxes
boundaries = bwboundaries(removedStaff);
numberOfBoundaries = size(boundaries);

% extract elements, which are big enough
boxes = repmat( struct('x',[],'y',[],'minX',1,'minY',1,'maxX',1,'maxY',1),1,numberOfBoundaries);

i = 1;
for k = 1 : numberOfBoundaries
    
    thisBoundary = boundaries{k};
    y = thisBoundary(:,1);
    x = thisBoundary(:,2);
    height  = max(y) - min(y);
    width   = max(x) - min(x);
    
    if width >= staffSpace && height >= 3.0*staffSpace
        boxes(i).x = x;%
        boxes(i).y = y;%
        boxes(i).minX = min(x);
        boxes(i).minY = min(y);
        boxes(i).maxX = max(x);
        boxes(i).maxY = max(y);
        
        i = i+1;
    end
end

% remove empty elements
boxes = boxes(1:i-1);

end

