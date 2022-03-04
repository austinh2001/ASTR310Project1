function [thresholdADU,skyNoiseMu,skyNoiseRegion] = calculateThreshold(image_data,region,z)
% Region is defined as two opposite points of a rectangular area

% Sorting the column vectors (corresponds to the vector of x values and a
% vector of y values) in order to go through the image data from lowest x
% and y to highest x and y.
region = sort(region);
image_data = flipud(imrotate(image_data,90));

% Getting the image data in the provided region, which is designated as
% noise. Correponding Mu and Sigma of the noise is calculated.
skyNoiseRegion = image_data(region(1,2):region(2,2),region(1,1):region(2,1));
%skyNoiseMu = median(skyNoiseRegion,'all')
skyNoiseMu = mean(skyNoiseRegion,'all');
skyNoiseSigma = std(skyNoiseRegion,1,'all');

% The corresponding threshold ADU value for the noise found in the provided
% region
thresholdADU = skyNoiseMu+z*skyNoiseSigma;
end

