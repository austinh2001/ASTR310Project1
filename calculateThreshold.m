function [thresholdADU] = calculateThreshold(image_data,region,numOfSigma)
skyNoiseRegion = image_data(region(1,1):region(1,2),region(2,1):region(2,2));
skyNoiseMu = median(skyNoiseRegion,'all');
skyNoiseSigma = std(skyNoiseRegion,1,'all');
thresholdADU = skyNoiseMu+numOfSigma*skyNoiseSigma;
end

