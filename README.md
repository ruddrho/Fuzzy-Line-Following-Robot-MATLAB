# Fuzzy Logic Line-Following Robot With Red Star Finish

## Project Update

This MATLAB project now includes:

- A clear red-star endpoint
- Green start point
- Open full track from start to red star
- Robot follows the full track
- Simulation stops only when robot reaches the red star
- Five-sensor fuzzy line following
- Bigger robot body and wheels
- Track progress and red-star distance plots

## How to Run

Open MATLAB, set this folder as the current folder, then run:

```matlab
main
```

## Files

- main.m
- robot_config.m
- create_track.m
- read_line_sensors.m
- fuzzy_controller.m
- differential_drive_model.m
- track_progress.m
- animate_robot.m
- plot_results.m


## Track Changed

This version uses a new cleaner full route with long straights, smoother turns, start point, and red-star endpoint.


Update: The red-star endpoint is now on the opposite side of the map (top-right), while the robot starts at the bottom-left.


## Endpoint Fixed

This version adds a final red-star approach controller. The robot follows the black line normally, then near the final section it switches to endpoint approach mode and drives directly to the red star before stopping.


## Final Full Track Fix

This version prevents shortcut behavior. Track progress is monotonic and the robot cannot switch to red-star endpoint mode until the final part of the track. It must cover the complete route first, then stop at the red star.


## Video Recording

Add the following lines in **main.m**:

```matlab
video = init_video('robot_simulation.mp4',30);

...
drawnow;
writeVideo(video,getframe(gcf));

...
close(video);
```

After the simulation finishes, MATLAB automatically saves:

`robot_simulation.mp4`
