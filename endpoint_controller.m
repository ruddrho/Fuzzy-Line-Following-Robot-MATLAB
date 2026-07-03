function [vLeft, vRight, headingError] = endpoint_controller(robot, goal, distanceToGoal, cfg)

dx = goal(1) - robot.x;
dy = goal(2) - robot.y;

desiredTheta = atan2(dy, dx);
headingError = wrap_to_pi(desiredTheta - robot.theta);

speedScale = min(1, distanceToGoal / cfg.goal.slowRadius);
forwardSpeed = cfg.goal.speed * speedScale;
forwardSpeed = max(forwardSpeed, cfg.robot.minSpeed);

turnCommand = cfg.goal.turnGain * headingError;

vLeft = forwardSpeed - turnCommand;
vRight = forwardSpeed + turnCommand;

vLeft = saturate(vLeft, -cfg.robot.maxSpeed, cfg.robot.maxSpeed);
vRight = saturate(vRight, -cfg.robot.maxSpeed, cfg.robot.maxSpeed);

end


function y = saturate(x, low, high)
y = min(max(x, low), high);
end


function a = wrap_to_pi(a)
a = mod(a + pi, 2*pi) - pi;
end
