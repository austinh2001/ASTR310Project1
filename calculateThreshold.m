function [thresholdADU] = calculateThreshold(sky_noise_region,z)

    mean_sky_noise = mean(sky_noise_region(:));
    std_sky_noise= std(sky_noise_region(:),1);

    % The corresponding threshold ADU value for the noise found in the provided
    % region
    thresholdADU = mean_sky_noise+z*std_sky_noise;
end

