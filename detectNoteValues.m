function [ noteValues ] = detectNoteValues( removedStaff,img_rot,startStaffSystem, staffSpace, boxes, noteHeads )

debug = 0;
%1 eingefärbte noten
%2 histogramme

% width right and left of note center point
cutWidth  = ceil(staffSpace);
% height to cut from small image, to remove note head
cutHeight = ceil(2*staffSpace);
% numbre of pixels to add to small image for better note detection
add = ceil(staffSpace/2.0);

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

if debug > 0 
    noteStart = 4;
    numNotes = 1;
    staffStart = 1;
    staffEnd = staffStart;
end


sizeBoxes = size(boxes);
s = size(removedStaff);

for staff = staffStart:staffEnd
    % for all red note heads
    
    noteEnd=length(noteHeads(staff).data);
    
    if debug > 0
        noteEnd= noteStart+numNotes-1;
    end
    
    for note = noteStart:noteEnd
        
        noteX = noteHeads(staff).data(note,1);
        noteY = noteHeads(staff).data(note,2);
        
        % calculate boundaries
        unfinished = 1;
        k = sizeBoxes(2);
        % go through all boxes
        while k > 0 && unfinished
            
            % if red dot is in aabb
            %boxes(k).dim1
                minY = min(boxes(k).y(abs(boxes(k).x-noteX) < cutWidth));
                maxY = max(boxes(k).y(abs(boxes(k).x-noteX) < cutWidth));
                
            if (boxes(k).minX <= noteX) &&(boxes(k).maxX >= noteX) && (minY <= noteY) && (maxY >= noteY)
                
                % make projection
                left =  noteX - cutWidth;
                right = noteX + cutWidth;
                
                % detect cut coordinates for current note
                left = floor(left);
                right = ceil(right);
                
                if(debug == 1)
                    
                    aabb = [];
                    aabb = [aabb; left boxes(k).maxY];
                    aabb = [aabb; left boxes(k).minY];
                    aabb = [aabb; right boxes(k).minY];
                    aabb = [aabb; right boxes(k).maxY];
                    aabb = [aabb; left boxes(k).maxY];
                    
                    
                    plot(aabb(:,1),aabb(:,2), 'm', 'LineWidth', 2);
                end
                
                if left < 1
                    left = 1;
                end
                
                if right > s(2)
                    right = s(2);
                end
                
                pixelCut = round(noteY);
                
                
                %minY = min(boxes(k).x (mit abs(x-noteX) < width))

                
                upperHalf =  removedStaff(minY:pixelCut-1    ,left:right);
                upperHalf = flipdim(upperHalf,1);
                lowerHalf =  removedStaff(pixelCut     :maxY ,left:right);
                
                
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
                    finalCutDown = pixelCut-cutHeight;
                    
                    
                else %if sLowerHalf(1) >= sUpperHalf(1)
                    noteHeadInBottom = false;
                    upperHalf =[upperHalf; zeros(sLowerHalf(1)-sUpperHalf(1),sUpperHalf(2))];
                    finalCutUp = pixelCut+cutHeight;
                    finalCutDown = maxY;
                end
                
                
%                     figure('name','cutbox'), imshow(img_rot);
%                     hold on;
%                     
%                     aabb = [];
%                     aabb = [aabb; finalCutLeft finalCutUp];
%                     aabb = [aabb; finalCutLeft finalCutDown];
%                     aabb = [aabb; finalCutRight  finalCutDown];
%                     aabb = [aabb; finalCutRight finalCutUp];
%                     aabb = [aabb; finalCutLeft finalCutUp];
%                     
%                     
%                     plot(aabb(:,1),aabb(:,2), 'c', 'LineWidth', 2);
%                 
                
                %join images
                res = im2bw(upperHalf + lowerHalf);
                
                if debug == 2
                    %figure('name','res'),imshow(res);
                end
                
                % cut upper part to get only "faehnchen"
                sizeRes = size(res,1);
                resultWidth = sizeRes-cutHeight;
                startCut    = sizeRes-resultWidth;
                res = res(startCut:sizeRes,:);
                
                if debug == 2
                    %figure('name','res'),imshow(res);
                end
                
                
                
                
                %horizontal projection
                summeH = sum(res,1);
                summeHorizFiltered = summeH;
                
                l2 = length(summeHorizFiltered)/2;
                l  = length(summeHorizFiltered);
                leftHorizHalf = max(summeHorizFiltered(1:l2));
                rightHorizHalf = max(summeHorizFiltered(l2:l));
                
                if debug == 2
                    %figure('name','plot of hori projection'),bar(summeHorizFiltered);
                end
                
                
                imgWidth = ceil((finalCutRight - finalCutLeft)/2);
                
                if leftHorizHalf > rightHorizHalf
                    res = res(:,1:l2);
                    finalCutRight = finalCutRight - imgWidth;
                    finalCutLeft = finalCutLeft - add;
                    
                else %leftHorizHalf > rightHorizHalf
                    res = res(:,l2:l);
                    finalCutLeft = finalCutLeft + imgWidth;
                    finalCutRight = finalCutRight + add;
                end
                
                if finalCutLeft < 1
                    finalCutLeft = 1;
                end
                
                if finalCutRight> s(2)
                    finalCutRight = s(2);
                end
                
                
                if debug == 2
                    %figure('name','resTotallyCut'),imshow(res);
                end
                
                    
                % replace res with increased cut of original image
                res = removedStaff(finalCutUp:finalCutDown,finalCutLeft:finalCutRight);

                
                if debug == 2
                    finalCutUp
                    finalCutDown
                    finalCutLeft
                    finalCutRight
                    %figure('name','resTotallyCutNeu'),imshow(res);
                end       
                    %figure('name','cutbox'), imshow(img_rot);
                    %hold on;
                    
%                     aabb = [];
%                     aabb = [aabb; finalCutLeft finalCutUp];
%                     aabb = [aabb; finalCutLeft finalCutDown];
%                     aabb = [aabb; finalCutRight  finalCutDown];
%                     aabb = [aabb; finalCutRight finalCutUp];
%                     aabb = [aabb; finalCutLeft finalCutUp];
%                     
%                     
%                     plot(aabb(:,1),aabb(:,2), 'm', 'LineWidth', 2);
%                 
                
                
                %vertical projection
                summeV = sum(res,2);
                summeVertiFiltered = summeV;
                %fil = [5 6 5]
                %fil = fil./sum(fil(:));
                %summeVertiFiltered = filter(fil,1,summeV);
                summeVertiFiltered = [1;summeVertiFiltered];
                summeVertiFiltered = [summeVertiFiltered;1];
                
                
                if debug == 2
                    figure('name','plot of vert projection'),plot(summeVertiFiltered);
                end
                
                if max(summeVertiFiltered) < 4
                    numOfPeaks = 0;
                else
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
            
            if unfinished
                noteValues(staff).data(note) = 0;
            end
            k = k-1;
            
            if debug == 1
                drawNote(noteX,noteY,noteValues(staff).data(note));
            end
        end
    end
end

if debug == 1 || debug == 2
    drawResultPart(img_rot,noteHeads,noteValues , staffStart, staffEnd, noteStart, noteEnd);
elseif debug == 0
    drawResult(img_rot,noteHeads,noteValues);
end

end

