alberio = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Data\20210926_14in_A310_M27\ancillary\alberio.fit");
alberio_center_coordinates = [798,495];
radius = 12;
alberio_semi_major_radius = radius;
alberio_semi_minor_radius = radius;
degrees_angle = 0;
noise_region = generateEllipticalRegion(alberio.data,[350,730],100,100);
z = 3.5;
egain = alberio.egain;
focal_length = 3912;
pixel_size = alberio.xpixsz;
exposure_time = alberio.exptime;
[threshold_image,threshold_image_values,threshold_ADU, noise_region] = threshE(alberio.data,alberio_center_coordinates,alberio_semi_major_radius,alberio_semi_minor_radius,degrees_angle,z,noise_region);
figure
displayImage(threshold_image)
displayRegion(noise_region,.3,[0,0,0])

total_angular_area = calculateAngularArea(focal_length,pixel_size,length(threshold_image_values))
[flux, flux_error] = calculateFlux(threshold_image_values,getRegionValues(alberio.data,noise_region),egain);

[instrumental_magnitude, instrumental_magnitude_error] = calculateInstrumentalMagnitude(flux,flux_error,exposure_time)

alberio_magnitude = 3.21

m_zp = alberio_magnitude - instrumental_magnitude
