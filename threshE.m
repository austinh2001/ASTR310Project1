function [threshold_image, threshold] = threshE(image_data,noise_region,numOfSigma,display)

%{
ThreshE adaptations by Team CANS
%}

%Find the threshold value, as determined by the noise region
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

% Displaying Threshold Image
if (nargin==3), display=false; end

if(display)
    figure
    displayAdjustedImage(threshold_image,0)
    title(string(numOfSigma) + " Sigma " + "Threshold Image");
    axis fill
    set(gca,'dataAspectRatio',[1 1 1])
end

end

