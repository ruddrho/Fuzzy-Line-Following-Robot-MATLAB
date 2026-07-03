function sensors = read_line_sensors(robot, track, cfg)

sensorOffsets = cfg.sensor.positions;
numSensors = length(sensorOffsets);

sensors = zeros(1,numSensors);

R = [
    cos(robot.theta) -sin(robot.theta);
    sin(robot.theta)  cos(robot.theta)
];

for i = 1:numSensors

    sensorBody = [cfg.sensor.frontDistance; sensorOffsets(i)];
    sensorWorld = [robot.x; robot.y] + R * sensorBody;

    dx = track.x - sensorWorld(1);
    dy = track.y - sensorWorld(2);

    d = sqrt(dx.^2 + dy.^2);
    minDistance = min(d);

    sensors(i) = exp(-(minDistance^2)/(2*cfg.sensor.detectRadius^2));
end

sensors = max(0,min(1,sensors));

end
