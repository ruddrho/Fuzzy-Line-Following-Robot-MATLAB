function [progress, nearestIndex] = track_progress(robot, track, previousIndex)

if nargin < 3
    previousIndex = 1;
end

searchBack = 20;
searchForward = 260;

i1 = max(1, previousIndex - searchBack);
i2 = min(length(track.x), previousIndex + searchForward);

localX = track.x(i1:i2);
localY = track.y(i1:i2);

dx = localX - robot.x;
dy = localY - robot.y;
d = sqrt(dx.^2 + dy.^2);

[~, localIdx] = min(d);
nearestIndex = i1 + localIdx - 1;

% progress cannot move backward
nearestIndex = max(nearestIndex, previousIndex);

progress = track.s(nearestIndex) / track.length;

end
