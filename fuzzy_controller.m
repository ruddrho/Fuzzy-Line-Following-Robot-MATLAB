function [vLeft, vRight, lineError, memory] = fuzzy_controller(sensors, cfg, memory)

sensorWeights = [-2 -1 0 1 2];
lineStrength = sum(sensors);

if lineStrength < 0.10

    lineError = memory.previousError;

    if abs(lineError) < 0.1
        lineError = memory.lostDirection;
    end

    turnCommand = cfg.fuzzy.lostTurn * sign(lineError);
    forwardSpeed = cfg.robot.minSpeed;

else

    lineError = sum(sensorWeights .* sensors) / lineStrength;
    lineError = cfg.fuzzy.errorGain * lineError;

    derivativeError = lineError - memory.previousError;

    fuzzyTurn = fuzzy_rule_base(lineError);

    turnCommand = fuzzyTurn + cfg.fuzzy.derivativeGain * derivativeError;

    turnSeverity = min(1, abs(lineError)/2.0);

    forwardSpeed = cfg.robot.baseSpeed * (1 - 0.60*turnSeverity);
    forwardSpeed = max(forwardSpeed, cfg.robot.minSpeed);

    memory.lostDirection = sign(lineError + 0.001);
end

memory.previousError = 0.82*memory.previousError + 0.18*lineError;

turnCommand = cfg.fuzzy.turnGain * turnCommand;

vLeft = forwardSpeed - turnCommand;
vRight = forwardSpeed + turnCommand;

vLeft = saturate(vLeft, -cfg.robot.maxSpeed, cfg.robot.maxSpeed);
vRight = saturate(vRight, -cfg.robot.maxSpeed, cfg.robot.maxSpeed);

end


function turn = fuzzy_rule_base(error)

NL = mf_tri(error, -2.7, -2.0, -1.0);
NS = mf_tri(error, -1.5, -0.7,  0.0);
ZE = mf_tri(error, -0.35, 0.0,  0.35);
PS = mf_tri(error,  0.0,  0.7,  1.5);
PL = mf_tri(error,  1.0,  2.0,  2.7);

rules = [NL NS ZE PS PL];
outputs = [-1.05 -0.55 0.00 0.55 1.05];

if sum(rules) < 1e-6
    turn = 0;
else
    turn = sum(rules .* outputs) / sum(rules);
end

end


function y = mf_tri(x, a, b, c)

if x <= a || x >= c
    y = 0;
elseif x == b
    y = 1;
elseif x > a && x < b
    y = (x-a)/(b-a);
else
    y = (c-x)/(c-b);
end

end


function y = saturate(x, low, high)
y = min(max(x, low), high);
end
