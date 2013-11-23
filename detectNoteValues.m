function [ noteValues ] = detectNoteValues( removedStaff,img_rot,startStaffSystem, staffSpace, boxes, noteHeads )




debug = 0
%1 eingefärbte noten
%2 histogramme


cutWidth  = 1.15*staffSpace;
cutHeight = 1.50*staffSpace;

numberOfStaffSystems = length(startStaffSystem);
noteValues = repmat( struct('data',[]),1,numberOfStaffSystems);

noteStart = 1;
staffStart = 1;
staffEnd = numberOfStaffSystems;

if debug == 1
    figure('name','originalImageWithSomething'), imshow(img_rot);
    hold on;
end

if debug == 2
    noteStart = 9;
    numNotes = 4;
    staffStart = 3;
    staffEnd = 3;
    numOfVertis = 0;
end


sizeBoxes = size(boxes);
s = size(removedStaff);

for staff = staffStart:staffEnd
    % for all red note heads
    
    noteEnd=length(noteHeads(staff).data);
    
    if debug == 2
        noteEnd= noteStart+numNotes;
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
            if (boxes(k).minX <= noteX) &&(boxes(k).maxX >= noteX) && (boxes(k).minY <= noteY) && (boxes(k).maxY >= noteY)
                
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
                
                upperHalf =  removedStaff(boxes(k).minY:pixelCut-1    ,left:right);
                upperHalf = flipdim(upperHalf,1);
                lowerHalf =  removedStaff(pixelCut     :boxes(k).maxY ,left:right);
                
                
                sUpperHalf = size(upperHalf);
                sLowerHalf = size(lowerHalf);
                
                %increase image to correct size
                if sUpperHalf(1) > sLowerHalf(1)
                    lowerHalf = [lowerHalf; zeros(sUpperHalf(1)-sLowerHalf(1),sLowerHalf(2))];
                    
                elseif sLowerHalf(1) > sUpperHalf(1)
                    upperHalf =[upperHalf; zeros(sLowerHalf(1)-sUpperHalf(1),sUpperHalf(2))];
                end
                
                
                % cut upper part to get only "faehnchen"
                res = upperHalf + lowerHalf;
                if debug == 2
                    figure('name','res'),imshow(res);
                end
                sizeRes = size(res,1);
                resultWidth = sizeRes-cutHeight;
                startCut    = sizeRes-resultWidth;
                res = res(startCut:sizeRes,:);
                
                if debug == 2
                    figure('name','res'),imshow(res);
                end
                
                
                summeV = sum(res,2);
                
                %lowpassfilter
                fil = [ 1 2 3 2 1];
                summeVertiFiltered = filter(fil,1,summeV);
                summeVertiFiltered = [1;summeVertiFiltered];
                summeVertiFiltered = [summeVertiFiltered;1];
                
                if debug == 2
                    figure('name','plot of vert projection'),bar(summeVertiFiltered);
                end
                
                
                
                [vertPiks] = findpeaks(summeVertiFiltered);
                numOfPeaks = sum(vertPiks > max(vertPiks)/2);
                
                
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

end

