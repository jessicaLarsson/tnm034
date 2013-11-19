function [ clusters,startStaffSystem, endStaffSystem,staffHeight,staffSpace ] = detectStaff( binaryComplementedImage, debug)

% Set default values if the argument wasn't passed in, or is empty, as in []
if (nargin < 2)  ||  isempty(debug)
    debug = 0;
end

s = size(binaryComplementedImage);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% erode once and get difference to increase importancy 
% of staff lines
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
se = [1 1 1; 1 1 1; 1 1 1];
erodedBW = imerode(binaryComplementedImage,se);
    if(debug)
        figure('name','binaryComplementedImage'), imshow(binaryComplementedImage);
        figure('name','erodedBW'), imshow(erodedBW);
    end
diff = binaryComplementedImage - erodedBW;
diff = im2bw(diff);
    if(debug)
        figure('name','diffOfErodedAndOriginal'), imshow(diff);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sum values of each row of diff, to get horizontal
%  projection and find peaks inside
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
summe = sum(diff,2);
[pks,locs] = findpeaks(summe);
% normalize between 0 and 1
pksOfHorizProjection = mat2gray(pks);
    if (debug)
        vector = pksOfHorizProjection(:);
        figure('name','PeakHistogram'), hist(vector,20);
    end
% get level between staff and notes etc.
%level = graythresh(pksOfHorizProjection);
% alternative level calculation
level = 0.4;
% binarize peaks with level
peaks = im2bw(pksOfHorizProjection, level);
locationOfPeaks = locs.*peaks;
locationOfPeaks(locationOfPeaks==0) = [];

    if(debug)
        % draw peaks
        figure('name','peaksOnImage'), imshow(diff);
        hold on;
        for i = 1:length(locationOfPeaks)
            height = locationOfPeaks(i);
            plot([1,s(2)],[height,height],'Color','r','LineWidth',2);
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the clusters with kmeans
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

seedStart = mean(locationOfPeaks(1:5));
seedEnd   = mean(locationOfPeaks(end-4:end));
numPeaks = length(locationOfPeaks);

numOfClusters = floor(numPeaks/5);

seedPointsDistance = floor((seedEnd-seedStart)/(numOfClusters-1));
seedPoints = seedStart:seedPointsDistance:seedEnd;
    if(debug)
        % draw seeds
        figure('name','seedsOnImage'), imshow(diff);
        hold on;
        grey = [0.5, 0.5, 0.5];
        for i = 1:length(seedPoints)
            height = seedPoints(i);
            plot([1,s(2)],[height,height],'Color',grey,'LineWidth',2);
        end
    end

[IDX,C,sumd,D] = kmeans(locationOfPeaks,[],'start',seedPoints');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw clusters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if (debug) 
        figure('name','clusterOnEdgePicture'), imshow(diff);
        hold on;
        
        
        %draw clusters
        for i= 1:length(locationOfPeaks)
            switch IDX(i)
                case 1
                    color = 'r';
                case 2 
                    color = 'y';
                case 3
                    color = 'g';
                case 4
                    color = 'b';
                case 5 
                    color = 'm';
                case 6 
                    color = 'c';
                case 7 %orange
                    color = [1.0, 0.5, 0.0];
                otherwise
                    color = [0.5, 0.5, 0.5];
            end

           height = locationOfPeaks(i);
           plot([1,s(2)],[height,height],'Color',color,'LineWidth',2);

        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% check, that every cluster has five elements
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clusters = [];
if mod(length(IDX),5) ~= 0
    
    values = unique(IDX);
	instances = histc(IDX,values);
    
    for i = 1:values(end)
        startPoint = (i-1)*5+1;
        if instances(i) < 5
            instances(i)
            mat = [IDX,locationOfPeaks];
            mat
            error('There are less than 5 values in the cluster, please check!');
        else
            while instances(i) > 5
                if (debug)
                	disp('remove a value out of cluster:');
                end
                partLocationOfPeaks = locationOfPeaks(startPoint:startPoint+(instances(i)-1));
                out = getOutlierIndex(partLocationOfPeaks);
                indexToDelete = startPoint-1+out;
                locationOfPeaks(indexToDelete) = [];
                IDX(indexToDelete) = [];
                %recalculate values
                values = unique(IDX);
                instances = histc(IDX,values);
            end
        end
        cluster = locationOfPeaks(startPoint:startPoint+4);
        %clusters = [clusters;cluster'];
        
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% draw clusters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    if (debug) 
        figure('name','clusterOnEdgePicture'), imshow(diff);
        hold on;
        
        for i= 1:length(locationOfPeaks)
            switch IDX(i)
                case 1
                    color = 'r';
                case 2 
                    color = 'y';
                case 3
                    color = 'g';
                case 4
                    color = 'b';
                case 5 
                    color = 'm';
                case 6 
                    color = 'c';
                case 7 %orange
                    color = [1.0, 0.5, 0.0];
                otherwise
                    color = [0.5, 0.5, 0.5];
            end

           height = locationOfPeaks(i);
           plot([1,s(2)],[height,height],'Color',color,'LineWidth',2);

        end
    end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect size of staff paramters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startStaffSystem = zeros(numOfClusters,1);
  endStaffSystem = zeros(numOfClusters,1);
  
for i = 1:numOfClusters
    startStaffSystem(i) = locationOfPeaks((i-1)*5+1);
      endStaffSystem(i) = locationOfPeaks((i-1)*5+5);
end

    if (debug)
        startStaffSystem
        endStaffSystem
    end

summedStaffDistance = sum(endStaffSystem-startStaffSystem);
staffSpace = summedStaffDistance/(4*numOfClusters);
staffSpace = (floor(staffSpace-1.5));
staffHeight = (summedStaffDistance-staffSpace*4*numOfClusters)/(5*numOfClusters);
   
    if (debug)
        staffSpace
        staffHeight
    end

end

