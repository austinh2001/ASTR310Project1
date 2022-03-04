function [flux, flux_error] = calculateFlux(ADU_values,sky_noise_region,kccd)
    
    % sky value
    sky=mean(sky_noise_region(:));

    % source without sky
    pix=ADU_values-sky;

    % photon noise per pixel
    sig=sqrt(ADU_values/kccd);

    % sky noise in average
    ssig= std(sky_noise_region(:))/sqrt(length(sky_noise_region(:)))/kccd;

    % flux
    flux = sum(pix)/kccd;

    % total error
    flux_error = sqrt(sum(sig).^2+ssig^2);
end

