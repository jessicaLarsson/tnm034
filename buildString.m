function [S] = buildString( startStaffSystem, endStaffSystem,noteHeads, noteValues, staffSpace, staffHeight)

S = [];
% crotchets 1/4
crotchets = {'E4' 'D4' 'C4' 'B3' 'A3' 'G3' 'F3' 'E3' 'D3' 'C3' 'B2' 'A2' 'G2' 'F2' 'E2' 'D2' 'C2' 'B1' 'A1' 'G1'};

% quavers 1/8
quavers   = {'e4' 'd4' 'c4' 'b3' 'a3' 'g3' 'f3' 'e3' 'd3' 'c3' 'b2' 'a2' 'g2' 'f2' 'e2' 'd2' 'c2' 'b1' 'a1' 'g1'};


numDiffNotes = length(quavers);

undef   = {'-e4' '-d4' '-c4' '-b3' '-a3' '-g3' '-f3' '-e3' '-d3' '-c3' '-b2' '-a2' '-g2' '-f2' '-e2' '-d2' '-c2' '-b1' '-a1' '-g1'};

% use half staffspace above e4 as normalize-line
% then use a linear mapping function to calculate the index
% finally use the correct array depending on value

% for all staff systems
numberOfStaffSystems = length(startStaffSystem);
for staff = 1:numberOfStaffSystems
    
    % calculate boundaries and the distance between 2 notes (=noteStep)
    numberOfNotes=length(noteHeads(staff).data);
    upperLine = startStaffSystem(staff)-3.5*staffSpace-3*staffHeight;
    lowerLine = endStaffSystem(staff)  +3.0*staffSpace+2*staffHeight;
    distance = lowerLine-upperLine;
    noteStep = distance / numDiffNotes;
    
    % take every note and add her value
    for note = 1:numberOfNotes
        
        %calculate index
        noteY = noteHeads(staff).data(note,2)-upperLine;
        idx = round(noteY/noteStep+0.5);
        
        %??? uncommented!
        %S = [S char(undef(idx))];
        
        
        val = noteValues(staff).data(note);
        
        if  val == 4
            S = [S char(crotchets(idx))];
        elseif val ==8
            S = [S char(quavers(idx))];
        end
        
    end
    %finished line
    S = [S 'n'];
end


end

