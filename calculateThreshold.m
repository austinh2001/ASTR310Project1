function [thresholdADU] = calculateThreshold(sky_noise_values,z,method)
    if (nargin==2), method="mean"; end
    if(method == "mean" || method == "average")
        sky_noise = mean(sky_noise_values);
    elseif(method == "median")
        sky_noise = median(sky_noise_values);
    end
    std_sky_noise= std(sky_noise_values);

    % The corresponding threshold ADU value for the sky noise
    thresholdADU = sky_noise+z*std_sky_noise;
end

