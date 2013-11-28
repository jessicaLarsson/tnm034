function [up  down left right] = detectCutBorders(bin_rot_comp,startStaffSystem, endStaffSystem ,staffSpace, staffHeight )

s = size(bin_rot_comp);

% cut up and down
verticalOffset = (5*staffSpace+4*staffHeight);
up   = startStaffSystem(1) - verticalOffset;
down = endStaffSystem(end) + verticalOffset;

if up < 1
    up = 1;
end

if down > s(1)
    down = s(1);
end

% cut left and right

%figure('name','plot of vertical projection'),plot(summeVerti);
%figure('name','plot of summeVertiFiltered'),plot(summeVertiFiltered);

%lowpassfilter
summeVerti = sum(bin_rot_comp,1);
fil = [1 2 3 2 1];
summeVertiFiltered = filter(fil,1,summeVerti);

%identify "Notenschlüssel"-Pik and get first minima after that
[vertPiks, vertLocs] = findpeaks(summeVertiFiltered);
[maxWert, index] = max(vertPiks);

id = index;
while  id < length(vertPiks) && vertPiks(id) >= vertPiks(id+1)
    id = id +1;
end

if ((id +1) == length(vertPiks))
    id = 1;
end

left = vertLocs(id);
right = s(2);

if left < 1
    left = 1;
end

if right > s(2)
    right = s(2);
end

left = round(left);
right = round(right);
up = round(up);
down = round(down);

end

