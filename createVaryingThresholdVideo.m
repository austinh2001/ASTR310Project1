function [] = createVaryingThresholdVideo(image_data,maxNumSigma,video_length)
totalFrames = 1000;
sigmas = linspace(0,maxNumSigma,totalFrames);
writerObj = VideoWriter('Thresholds_' + string(maxNumSigma) + '.avi');
writerObj.FrameRate = length(sigmas)/video_length;
open(writerObj);
for i=1:length(sigmas)
    threshold_image = threshE(image_data,sigmas(i));
    writeVideo(writerObj, getframe(gcf))
    display(string((i/totalFrames)*100) + " %")
end
close(writerObj);
end

