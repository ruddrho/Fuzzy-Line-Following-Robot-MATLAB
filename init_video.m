function recorder = init_video(filename,fps)

if nargin<1
    filename='robot_simulation.mp4';
end
if nargin<2
    fps=30;
end

recorder = VideoWriter(filename,'MPEG-4');
recorder.FrameRate = fps;
open(recorder);

end
