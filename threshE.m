function [threshold_image] = threshE(image_data,numOfSigma)
%{
ThreshE adaptations by Team CANS
%}

%Find useful threshold value
noise_region = [1100,1300 ; 700,900];
threshold = calculateThreshold(image_data,noise_region,numOfSigma);
threshold_image = zeros(size(image_data));
image_size = size(threshold_image);
for i=1:image_size(1)
    for j=1:image_size(2)
        if(image_data(i,j) >= threshold)
            threshold_image(i,j) = image_data(i,j);
        end
    end
end

%Displaying Threshold Image
displayAdjustedImage(rot90(threshold_image),3)
title(string(numOfSigma) + " Sigma " + "Threshold Image");
axis fill
set(gca,'dataAspectRatio',[1 1 1])
end

