function robot = differential_drive_model(robot, vLeft, vRight, cfg)

L = cfg.robot.wheelBase;
dt = cfg.sim.dt;

v = (vRight + vLeft)/2;
omega = (vRight - vLeft)/L;

robot.x = robot.x + v*cos(robot.theta)*dt;
robot.y = robot.y + v*sin(robot.theta)*dt;
robot.theta = robot.theta + omega*dt;

robot.theta = mod(robot.theta + pi, 2*pi) - pi;

end
