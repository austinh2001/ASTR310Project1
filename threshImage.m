function [threshold_image, threshold] = threshImage(image_data,noise_region,numOfSigma)

%{
AperE Original code by Professor Andrew Harris. Edited by Alyssa Pagan
%} 

%{
ThreshE adaptations from AperE by Team CANS
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

end

