function animate_robot(robot, track, sensors, robotLog, progress, distanceToGoal, cfg)

clf;
hold on;
grid on;
axis equal;

plot(track.x, track.y, 'k', 'LineWidth', 7);
plot(robotLog(:,1), robotLog(:,2), 'r--', 'LineWidth', 1.7);

plot(track.start(1), track.start(2), 'go', ...
    'MarkerSize', 12, 'MarkerFaceColor', 'g', 'LineWidth', 2);

plot(track.goal(1), track.goal(2), 'rp', ...
    'MarkerSize', 22, 'MarkerFaceColor', 'r', 'LineWidth', 2);

text(track.goal(1)+0.25, track.goal(2)+0.25, 'RED STAR FINISH', ...
    'Color', 'r', 'FontWeight', 'bold');

draw_robot_body(robot, cfg);
draw_sensors(robot, sensors, cfg);

xlabel('X');
ylabel('Y');
title(sprintf('Robot Covers Full Track and Stops at Red Star | Progress %.1f%% | Goal Distance %.2f m', ...
    progress*100, distanceToGoal));

xlim([cfg.world.xMin cfg.world.xMax]);
ylim([cfg.world.yMin cfg.world.yMax]);

legend('Black Line Track','Robot Path','Start Point','Red Star Finish','Location','best');

end


function draw_robot_body(robot, cfg)

L = cfg.robot.bodyLength;
W = cfg.robot.bodyWidth;

corners = [
     L/2  W/2;
     L/2 -W/2;
    -L/2 -W/2;
    -L/2  W/2
]';

R = [
    cos(robot.theta) -sin(robot.theta);
    sin(robot.theta)  cos(robot.theta)
];

worldCorners = R*corners + [robot.x; robot.y];

patch(worldCorners(1,:), worldCorners(2,:), [0.2 0.6 1.0], ...
    'FaceAlpha',0.85,'EdgeColor','k','LineWidth',2.0);

front = [robot.x; robot.y] + R*[L/2;0];
plot([robot.x front(1)], [robot.y front(2)], 'm', 'LineWidth', 3);

wheelOffsets = [
     L/3  W/2;
     L/3 -W/2;
    -L/3  W/2;
    -L/3 -W/2
];

for i = 1:4
    wp = [robot.x; robot.y] + R*wheelOffsets(i,:)';

    wheelL = 0.28;
    wheelW = 0.14;

    rectangle('Position',[wp(1)-wheelW/2 wp(2)-wheelL/2 wheelW wheelL], ...
        'Curvature',0.25,'FaceColor',[0.02 0.02 0.02], ...
        'EdgeColor','k','LineWidth',1.2);
end

end


function draw_sensors(robot, sensors, cfg)

sensorOffsets = cfg.sensor.positions;

R = [
    cos(robot.theta) -sin(robot.theta);
    sin(robot.theta)  cos(robot.theta)
];

for i = 1:length(sensorOffsets)

    sensorBody = [cfg.sensor.frontDistance; sensorOffsets(i)];
    p = [robot.x; robot.y] + R*sensorBody;

    if sensors(i) > 0.55
        color = 'g';
    elseif sensors(i) > 0.25
        color = 'y';
    else
        color = 'r';
    end

    plot(p(1), p(2), 'o', 'MarkerSize', 9, ...
        'MarkerFaceColor', color, 'MarkerEdgeColor','k', 'LineWidth',1.2);
end

end
