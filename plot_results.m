function plot_results(time, robotLog, sensorLog, wheelLog, errorLog, progressLog, distanceToGoalLog)

figure('Name','Robot Pose','NumberTitle','off');

subplot(3,1,1);
plot(time, robotLog(:,1), 'LineWidth', 1.5);
grid on;
ylabel('X position');

subplot(3,1,2);
plot(time, robotLog(:,2), 'LineWidth', 1.5);
grid on;
ylabel('Y position');

subplot(3,1,3);
plot(time, robotLog(:,3), 'LineWidth', 1.5);
grid on;
ylabel('Theta rad');
xlabel('Time s');

figure('Name','Five Sensor Readings','NumberTitle','off');

plot(time, sensorLog, 'LineWidth', 1.5);
grid on;
xlabel('Time s');
ylabel('Sensor value');
legend('S1 left outer','S2 left','S3 center','S4 right','S5 right outer');

figure('Name','Wheel Speeds','NumberTitle','off');

plot(time, wheelLog(:,1), time, wheelLog(:,2), 'LineWidth', 1.5);
grid on;
xlabel('Time s');
ylabel('Wheel speed m/s');
legend('Left wheel','Right wheel');

figure('Name','Track Progress and Red Star Distance','NumberTitle','off');

subplot(3,1,1);
plot(time, errorLog, 'LineWidth', 1.5);
grid on;
ylabel('Line error');

subplot(3,1,2);
plot(time, progressLog*100, 'LineWidth', 1.5);
grid on;
ylabel('Progress %');

subplot(3,1,3);
plot(time, distanceToGoalLog, 'LineWidth', 1.5);
grid on;
xlabel('Time s');
ylabel('Distance to red star');

end
