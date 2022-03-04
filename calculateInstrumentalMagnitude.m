function [instrumental_magnitude, instrumental_magnitude_error] = calculateInstrumentalMagnitude(flux, flux_error, exposure_time)
    instrumental_magnitude = -2.5*log10(flux/exposure_time);
    instrumental_magnitude_error = (-2.5*flux_error)/(log(10)*flux);
end

