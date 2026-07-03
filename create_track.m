function track = create_track(cfg)

% One-way complete track.
% Start = bottom-left green point.
% End = top-right red star.
% No shortcut endpoint approach is allowed until final progress is reached.
waypoints = [
    2.0  2.0
    6.5  2.0
    6.5  4.7
    3.0  4.7
    3.0  8.7
    8.5  8.7
    8.5  11.0
    13.5 11.0
    13.5  8.4
    10.2  8.4
    10.2  5.8
    15.0  5.8
    15.0  3.0
    19.0  3.0
    19.5  5.0
    18.6  7.2
    16.5  8.5
    17.5 10.0
    20.0 11.0
];

track.x = [];
track.y = [];

for i = 1:size(waypoints,1)-1
    p1 = waypoints(i,:);
    p2 = waypoints(i+1,:);

    distance = norm(p2-p1);
    n = max(2, ceil(distance/cfg.track.resolution));

    xs = linspace(p1(1), p2(1), n);
    ys = linspace(p1(2), p2(2), n);

    if isempty(track.x)
        track.x = xs;
        track.y = ys;
    else
        track.x = [track.x xs(2:end)];
        track.y = [track.y ys(2:end)];
    end
end

% light smoothing only, keeps endpoint accurate
track.x = smoothdata(track.x, 'movmean', 5);
track.y = smoothdata(track.y, 'movmean', 5);

track.x(1) = waypoints(1,1);
track.y(1) = waypoints(1,2);
track.x(end) = waypoints(end,1);
track.y(end) = waypoints(end,2);

track.length = 0;
track.s = zeros(size(track.x));

for i = 2:length(track.x)
    ds = hypot(track.x(i)-track.x(i-1), track.y(i)-track.y(i-1));
    track.length = track.length + ds;
    track.s(i) = track.length;
end

track.points = waypoints;
track.start = waypoints(1,:);
track.goal = waypoints(end,:);

end
