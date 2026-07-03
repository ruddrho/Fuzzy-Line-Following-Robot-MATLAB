function cfg = robot_config()

cfg.sim.dt = 0.02;
cfg.sim.tFinal = 190;
cfg.sim.animationStep = 3;

% Robot must cover almost the entire path before endpoint stop is allowed
cfg.sim.finishProgress = 0.995;
cfg.sim.goalTolerance = 0.55;

cfg.robot.wheelRadius = 0.07;
cfg.robot.wheelBase = 0.70;
cfg.robot.bodyLength = 1.00;
cfg.robot.bodyWidth = 0.70;

cfg.robot.startX = 2.0;
cfg.robot.startY = 2.0;
cfg.robot.startTheta = 0;

cfg.robot.baseSpeed = 0.34;
cfg.robot.maxSpeed = 0.68;
cfg.robot.minSpeed = 0.055;

cfg.sensor.frontDistance = 0.52;
cfg.sensor.spacing = 0.13;
cfg.sensor.detectRadius = 0.27;
cfg.sensor.positions = [-2 -1 0 1 2] * cfg.sensor.spacing;

cfg.track.width = 0.20;
cfg.track.resolution = 0.015;

cfg.world.xMin = 0;
cfg.world.xMax = 22;
cfg.world.yMin = 0;
cfg.world.yMax = 13;

cfg.fuzzy.turnGain = 0.50;
cfg.fuzzy.errorGain = 0.95;
cfg.fuzzy.derivativeGain = 0.16;
cfg.fuzzy.lostTurn = 0.40;

% Endpoint controller starts only at the very last part of the path
cfg.goal.enableGoalMode = true;
cfg.goal.startProgress = 0.972;
cfg.goal.speed = 0.20;
cfg.goal.turnGain = 1.15;
cfg.goal.slowRadius = 1.4;

end
