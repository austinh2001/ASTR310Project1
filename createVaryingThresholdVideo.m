function [] = createVaryingThresholdVideo(image_data,noise_region,maxNumSigma,video_length)
totalFrames = 100;
sigmas = linspace(0,maxNumSigma,totalFrames);
writerObj = VideoWriter('Thresholds_' + string(maxNumSigma) + '.avi');
writerObj.FrameRate = length(sigmas)/video_length;
open(writerObj);
for i=1:length(sigmas)
    threshold_image = threshE(image_data,noise_region,sigmas(i));
    displayImage(threshold_image)
    title(string(sigmas(i)) + " σ " + "Threshold Image");
    writeVideo(writerObj, getframe(gcf))
    display(string((i/totalFrames)*100) + " %")
end
close(writerObj);
end

