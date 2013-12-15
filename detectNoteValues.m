function [ noteValues ] = detectNoteValues( removedStaff,img_rot,startStaffSystem, staffSpace, boxes, noteHeads )

debug = 0;
%1 boxen
%2 histogramme

% width right and left of note center point
cutWidthNote  = ceil(1.2*staffSpace);
% width right and left of note center point
cutWidthFlag  = ceil(1.5*staffSpace);
% height to cut from small image, to remove note head
cutHeight = ceil(2*staffSpace);


numberOfStaffSystems = length(startStaffSystem);
noteValues = repmat( struct('data',[]),1,numberOfStaffSystems);
noteBeamThickness = ceil(staffSpace/2.0 -0.5);

noteStart = 1;
staffStart = 1;
staffEnd = numberOfStaffSystems;

if debug == 1
    figure('name','originalImageWithSomething'), imshow(img_rot);
    hold on;
end
%16 
if debug > 0
    noteStart = 17;
    numNotes = 1;
    staffStart = 1;
    staffEnd = staffStart;
end

counter = -1;
sizeBoxes = size(boxes);
s = size(removedStaff);

counter = counter +1;
for staff = staffStart:staffEnd
    % for all red note heads
    
    noteEnd=length(noteHeads(staff).data);
    
    if debug > 0
        noteEnd= noteStart+numNotes-1;
    end
    
    for note = noteStart:noteEnd
        counter = counter+1;
        %if debug > 0
        %disp('###################################################');
        %staff
        %note
        %end
        
        noteX = noteHeads(staff).data(note,1);
        noteY = noteHeads(staff).data(note,2);
        
        % calculate boundaries
        unfinished = 1;
        k = sizeBoxes(2);
        % go through all boxes
        while k > 0 && unfinished
            
            % if red dot is in aabb
            %boxes(k).dim1
            minY = min(boxes(k).y(abs(boxes(k).x-noteX) < cutWidthNote));
            maxY = max(boxes(k).y(abs(boxes(k).x-noteX) < cutWidthNote));
            
            if (boxes(k).minX <= noteX) &&(boxes(k).maxX >= noteX) && (minY <= noteY) && (maxY >= noteY)
                
                % make projection
                left =  noteX - cutWidthNote;
                right = noteX + cutWidthNote;
                
                % detect cut coordinates for current note
                left = floor(left);
                right = ceil(right);
                
                if(debug == 1)
                    
                    aabb = [];
                    aabb = [aabb; left-1 boxes(k).maxY+1];
                    aabb = [aabb; left-1 boxes(k).minY-1];
                    aabb = [aabb; right+1 boxes(k).minY-1];
                    aabb = [aabb; right+1 boxes(k).maxY+1];
                    aabb = [aabb; left-1 boxes(k).maxY+1];
                    
                    
                    plot(aabb(:,1),aabb(:,2), 'r', 'LineWidth', 3);
                end
                
                if left < 1
                    left = 1;
                end
                
                if right > s(2)
                    right = s(2);
                end
                
                noteY = round(noteY);
                
                
                
                
                
                upperHalf =  removedStaff(minY:noteY-1    ,left:right);
                upperHalf = flipdim(upperHalf,1);
                lowerHalf =  removedStaff(noteY     :maxY ,left:right);
                
                
                sUpperHalf = size(upperHalf);
                sLowerHalf = size(lowerHalf);
                
                % get final cut information
                finalCutLeft = left;
                finalCutRight = right;
                finalCutUp = 0;
                finalCutDown = 0;
                noteHeadInBottom = true;
                
                %increase image to correct size
                if sUpperHalf(1) > sLowerHalf(1)
                    noteHeadInBottom = true;
                    lowerHalf = [lowerHalf; zeros(sUpperHalf(1)-sLowerHalf(1),sLowerHalf(2))];
                    finalCutUp = minY;
                    finalCutDown = noteY-cutHeight;
                    
                    
                else %if sLowerHalf(1) >= sUpperHalf(1)
                    noteHeadInBottom = false;
                    upperHalf =[upperHalf; zeros(sLowerHalf(1)-sUpperHalf(1),sUpperHalf(2))];
                    finalCutUp = noteY+cutHeight;
                    finalCutDown = maxY;
                end
                
                if debug == 1
                    %figure('name','cutbox'), imshow(img_rot);
                    %hold on;
                    
                    aabb = [];
                    aabb = [aabb; finalCutLeft finalCutUp];
                    aabb = [aabb; finalCutLeft finalCutDown];
                    aabb = [aabb; finalCutRight  finalCutDown];
                    aabb = [aabb; finalCutRight finalCutUp];
                    aabb = [aabb; finalCutLeft finalCutUp];
                    
                    
                    plot(aabb(:,1),aabb(:,2), 'b', 'LineWidth', 3);
                    
                end
                
                %join images
                res = im2bw(upperHalf + lowerHalf);
                
                if debug == 2
                    %set(0,'DefaultFigureColor',[1 1 1])
                    %set(0,'DefaultFigureColor','remove')
                    figure('name','res'),imshow(res);
                    %set(gca,'LooseInset',get(gca,'TightInset'))
                    imwrite(res, 'a.jpg', 'jpg')
                end
                
                % cut upper part to get only "faehnchen"
                sizeRes = size(res,1);
                resultWidth = sizeRes-cutHeight;
                startCut    = sizeRes-resultWidth;
                res = res(startCut:sizeRes,:);
                
                if debug == 2
                    figure('name','res'),imshow(res);
                    imwrite(res, 'b.jpg', 'jpg')
                end
                
                
                
                
                %horizontal projection
                summeH = sum(res,1);
                summeHorizFiltered = summeH;
                
                % get max to identify "notebeam"
                [beamValue, beamIndex] = max(summeHorizFiltered(:));
                
                % count maxes and take the one closest to the noteHead,
                % when there are more than one
                if sum(summeHorizFiltered(:) > 0.8*beamValue) > 1
                    ids = find((summeHorizFiltered(:) > 0.8*beamValue));
                    divFactor = length(summeHorizFiltered)/2;
                    tmp = abs(ids(:)-divFactor);
                    [v id] = min(tmp(:));
                    beamIndex = ids(id);
                    
                end
                
                continueCalc = true;
                
                if min(summeHorizFiltered(:)) == beamValue
                    note
                    staff
                    continueCalc = false;
                    unfinished = false;
                    % detected beamLine only
                    if beamValue  > 0
                        noteValues(staff).data(note) = -1;
                    else
                        noteValues(staff).data(note) = 4;
                    end
                end
                
                if(continueCalc)
                    
                    beamPosition = finalCutLeft + beamIndex;
                    
                    leftHorizHalf = summeHorizFiltered(1:beamIndex-1);
                    rightHorizHalf = summeHorizFiltered(beamIndex+1:end);
                    
                    leftHorizHalf = mean(leftHorizHalf(leftHorizHalf(:) < 0.7*beamValue));
                    rightHorizHalf = mean(rightHorizHalf(rightHorizHalf(:) < 0.7*beamValue));
                    
                    if debug == 2
                        figure('name','plot of hori projection'),bar(summeHorizFiltered);
                        axis tight
                            ylabel('value [pixel]')
                            xlabel('vertical projection of columns [pixel]')
                    end
                    
                    
                    % take side with more information
                    if leftHorizHalf > rightHorizHalf
                        finalCutRight = beamPosition - 1;
                        finalCutLeft = beamPosition - cutWidthFlag;
                        
                    else %leftHorizHalf < rightHorizHalf
                        finalCutLeft = beamPosition + 1;
                        finalCutRight = beamPosition + cutWidthFlag;
                    end
                    
                    if finalCutLeft < 1
                        finalCutLeft = 1;
                    end
                    
                    if finalCutRight> s(2)
                        finalCutRight = s(2);
                    end
                    
                    
                    if debug == 2
                        figure('name','resTotallyCut'),imshow(res);
                    end
                    
                    
                    % replace res with increased cut of original image
                    res = removedStaff(finalCutUp:finalCutDown,finalCutLeft:finalCutRight);
                    
                    
                    if debug == 2
                        finalCutUp
                        finalCutDown
                        finalCutLeft
                        finalCutRight
                        figure('name','resTotallyCutNeu'),imshow(res);
                        imwrite(res, 'd.jpg', 'jpg')
                    end
                    
                    if debug == 1
                        %figure('name','cutbox'), imshow(img_rot);
                        %hold on;
                        
                        aabb = [];
                        aabb = [aabb; finalCutLeft finalCutUp];
                        aabb = [aabb; finalCutLeft finalCutDown];
                        aabb = [aabb; finalCutRight  finalCutDown];
                        aabb = [aabb; finalCutRight finalCutUp];
                        aabb = [aabb; finalCutLeft finalCutUp];
                        
                        orange = [0.0 0.8 0.0];
                        plot(aabb(:,1),aabb(:,2), 'color',orange, 'LineWidth', 3);
                        
                    end
                    
                    %vertical projection
                    summeV = sum(res,2);
                    summeVertiFiltered = summeV;
                    %fil = [1 1 1 1 1]
                    %fil = fil./sum(fil(:));
                    %summeVertiFiltered = filter(fil,1,summeV);
                    
                    
                    summeVertiFiltered = [1;summeVertiFiltered];
                    summeVertiFiltered = [summeVertiFiltered;1];
                    
                    if debug == 2
                        figure('name','plot of vert projection'),plot(summeVertiFiltered);
                             view(90,90)
                            axis tight
                            ylabel('value [pixel]')
                            xlabel('horizontal projection of bounding box')
                    end
                    
                    if max(summeVertiFiltered) < 4
                        numOfPeaks = 0;
                    else
                        % filter a little bit
                        fil = [1 1 1 1 1];
                        fil  = fil./sum(fil(:));
                        summeVertiFiltered = filter(fil,1,summeVertiFiltered);
                        if debug == 2
                            h = figure('name','plot2 of vert projection'),plot(summeVertiFiltered);
                            view(90,90)
                            axis tight
                            ylabel('value [pixel]')
                            xlabel('low pass filtered horizontal projection of bounding box')

                            
                        end
                        
                        [vertPiks] = findpeaks(summeVertiFiltered);
                        numOfPeaks = sum(vertPiks > max(floor(max(vertPiks)/3),noteBeamThickness));
                    end
                    
                    
                    switch numOfPeaks
                        case 0 %1/4
                            noteValues(staff).data(note) = 4;
                        case 1 %1/8
                            noteValues(staff).data(note) = 8;
                        otherwise
                            noteValues(staff).data(note) = 1;                            
                    end
                    unfinished = 0;
                end
                
            end
            k = k-1;
        end
        
        if unfinished
            noteValues(staff).data(note) = 0;
        end
        
        
        %if debug == 1
            %drawNote(noteX,noteY,noteValues(staff).data(note), staffSpace);
        %end
    end
    
end

if debug  > 1
    drawResultPart(img_rot,noteHeads,noteValues , staffStart, staffEnd, noteStart, noteEnd, staffSpace);
end

end

