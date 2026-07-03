clc;
clear;
close all;

cfg = robot_config();

robot.x = cfg.robot.startX;
robot.y = cfg.robot.startY;
robot.theta = cfg.robot.startTheta;

track = create_track(cfg);

time = 0:cfg.sim.dt:cfg.sim.tFinal;
N = length(time);

robotLog = zeros(N,3);
sensorLog = zeros(N,5);
wheelLog = zeros(N,2);
errorLog = zeros(N,1);
progressLog = zeros(N,1);
distanceToGoalLog = zeros(N,1);

controllerMemory.previousError = 0;
controllerMemory.lostDirection = 1;

progressIndex = 1;
progress = 0;

figure('Name','Full Track Line Following Robot With Red Star Endpoint',...
       'NumberTitle','off',...
       'Position',[100 100 840 630]);

video = VideoWriter('navigation_recording.mp4','MPEG-4');
video.FrameRate = 30;
open(video);

for k = 1:N

    sensors = read_line_sensors(robot, track, cfg);

    [progress, progressIndex] = track_progress(robot, track, progressIndex);

    dxGoal = track.goal(1) - robot.x;
    dyGoal = track.goal(2) - robot.y;
    distanceToGoal = sqrt(dxGoal^2 + dyGoal^2);

    if cfg.goal.enableGoalMode && progress >= cfg.goal.startProgress
        [vLeft, vRight, lineError] = endpoint_controller(robot, track.goal, distanceToGoal, cfg);
    else
        [vLeft, vRight, lineError, controllerMemory] = fuzzy_controller(sensors, cfg, controllerMemory);
    end

    robot = differential_drive_model(robot, vLeft, vRight, cfg);

    [progress, progressIndex] = track_progress(robot, track, progressIndex);

    dxGoal = track.goal(1) - robot.x;
    dyGoal = track.goal(2) - robot.y;
    distanceToGoal = sqrt(dxGoal^2 + dyGoal^2);

    robotLog(k,:) = [robot.x robot.y robot.theta];
    sensorLog(k,:) = sensors;
    wheelLog(k,:) = [vLeft vRight];
    errorLog(k) = lineError;
    progressLog(k) = progress;
    distanceToGoalLog(k) = distanceToGoal;

    if mod(k,cfg.sim.animationStep) == 0 || k == 1
        animate_robot(robot, track, sensors, robotLog(1:k,:), progress, distanceToGoal, cfg);
        drawnow;

        frame = getframe(gcf);
        img = frame2im(frame);
        img = imresize(img,[630 840]);
        writeVideo(video,img);
    end

    if progress >= cfg.sim.finishProgress && distanceToGoal <= cfg.sim.goalTolerance
        disp('MISSION COMPLETE: Robot covered the FULL TRACK and reached the RED STAR endpoint.');

        robotLog = robotLog(1:k,:);
        sensorLog = sensorLog(1:k,:);
        wheelLog = wheelLog(1:k,:);
        errorLog = errorLog(1:k,:);
        progressLog = progressLog(1:k,:);
        distanceToGoalLog = distanceToGoalLog(1:k,:);
        time = time(1:k);

        animate_robot(robot, track, sensors, robotLog, progress, distanceToGoal, cfg);
        drawnow;

        frame = getframe(gcf);
        img = frame2im(frame);
        img = imresize(img,[630 840]);
        writeVideo(video,img);

        break;
    end
end

close(video);

plot_results(time, robotLog, sensorLog, wheelLog, errorLog, progressLog, distanceToGoalLog);

disp('Simulation finished.');
disp('Navigation video saved as navigation_recording.mp4');