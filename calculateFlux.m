function [flux, flux_error] = calculateFlux(ADU_values,sky_noise_region_values,egain)
    % Description: Calculates the flux associated with an array of ADU
    % values
    
    %----------------------------------------------------------------------

    % Input: 

    % ADU_values: An 1 x n array of ADU values

    % sky_noise_region: A region associated with the sky noise

    % egain: A scalar, in units of electrons per ADU, associated with CCD which generated the ADU data

    %----------------------------------------------------------------------

    % Output:

    % flux: A scalar which represents the flux associated with the set of
    % ADU values

    % flux_error: A scalar which represents the error associated with the
    % flux

    %----------------------------------------------------------------------

    % Errors:

    
    %----------------------------------------------------------------------

    % sky value
    sky=mean(sky_noise_region_values);

    % source without sky
    pix=ADU_values-sky;

    % photon noise per pixel
    sig=sqrt(ADU_values*egain);

    % sky noise in average
    ssig= std(sky_noise_region_values)/sqrt(length(sky_noise_region_values))*egain;

    % flux
    flux = sum(pix)*egain;

    % total error
    flux_error = sqrt(sum(sig).^2+ssig^2);
end

