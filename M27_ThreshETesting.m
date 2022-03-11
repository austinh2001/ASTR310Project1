ha1 = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Calibrated Images\2021-09-24\14in\Targets\M27\ha\2021-09-24_calibrated_image_14in_M27_ha.fit");
ha2 = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Calibrated Images\2021-09-26\14in\Targets\M27\ha\2021-09-26_calibrated_image_14in_M27_ha.fit");
shifts = calculateShift(ha1.data,ha2.data);
ha2.data = imshift(ha2.data,shifts(2),shifts(1));
im = coAdd(ha1.data,ha2.data);
writeCompositeFITS(im,{ha1,ha2},"C:\Users\Austin\Documents\GitHub\ASTR310Project1\TestFolder\combined_m27_ha.fits")
compositeFITS = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\TestFolder\combined_m27_ha.fits");
Ha_center_coordinates = [643,459];
Ha_semi_major_radius = 560;
Ha_semi_minor_radius = 430;
degrees_angle = -30;
noise_region = generateEllipticalRegion(im,[1350,800],150,150);
z = 3.5;
egain = compositeFITS.egain;
focal_length = compositeFITS.focallen;
pixel_size = compositeFITS.xpixsz;
exposure_time = compositeFITS.exptime;
[threshold_image,threshold_image_values,threshold_ADU, noise_region] = threshE(im,Ha_center_coordinates,Ha_semi_major_radius,Ha_semi_minor_radius,degrees_angle,z,noise_region);
figure
displayAdjustedImage(threshold_image)
displayRegion(noise_region,.3,[0,0,0])

total_angular_area = calculateAngularArea(focal_length,pixel_size,length(threshold_image_values))
[flux, flux_error] = calculateFlux(threshold_image_values,getRegionValues(im,noise_region),egain);

[instrumental_magnitude, instrumental_magnitude_error] = calculateInstrumentalMagnitude(flux,flux_error,exposure_time)
m27_magnitude = 7.5
m_zp = m27_magnitude - instrumental_magnitude