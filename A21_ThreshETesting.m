A21 = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Calibrated Images\2022-02-19\07in\Targets\A21\ha\2022-02-19_calibrated_image_07in_A21_ha.fit");
Ha_center_coordinates = [1075,776];
Ha_semi_major_radius = 400;
Ha_semi_minor_radius = 400;
degrees_angle = 0;
noise_region = generateEllipticalRegion(A21.data,[1754,1050],100,100);
z = 3.5;
egain = A21.egain;
focal_length = A21.focallen;
pixel_size = A21.xpixsz;
exposure_time = A21.exptime;
[threshold_image,threshold_image_values,threshold_ADU, noise_region] = threshE(A21.data,Ha_center_coordinates,Ha_semi_major_radius,Ha_semi_minor_radius,degrees_angle,z,noise_region);
figure
displayAdjustedImage(threshold_image)
displayRegion(noise_region,.3,[0,0,0])

total_angular_area = calculateAngularArea(focal_length,pixel_size,length(threshold_image_values))
[flux, flux_error] = calculateFlux(threshold_image_values,getRegionValues(A21.data,noise_region),egain);

[instrumental_magnitude, instrumental_magnitude_error] = calculateInstrumentalMagnitude(flux,flux_error,exposure_time)
