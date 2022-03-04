ha1 = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Calibrated Images\2021-09-24\14in\Targets\M27\ha\2021-09-24_calibrated_image_14in_M27_ha.fit");
ha2 = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Calibrated Images\2021-09-26\14in\Targets\M27\ha\2021-09-26_calibrated_image_14in_M27_ha.fit");
shifts = calculateShift(ha1.data,ha2.data);
ha2.data = imshift(ha2.data,shifts(2),shifts(1));
im = coAdd(ha1.data,ha2.data);
Ha_center_coordinates = [643,459];
Ha_major_radius = 560;
Ha_minor_radius = 430;
degrees_angle = -30;
noise_bounding_array = [[1000,900] ; [1300,800]];
z = 2.5;
kccd = 1/(1.2999999523162842);
focal_length = 3912;
pixel_size = 9;

[threshold_image,threshold_image_values,threshold_ADU] = threshE(im,Ha_center_coordinates(2),Ha_center_coordinates(1),Ha_major_radius,Ha_minor_radius,degrees_angle,noise_bounding_array,z);
displayAdjustedImage(threshold_image)
displaySkyNoiseRegion(noise_bounding_array)

total_angular_area = calculateAngularArea(focal_length,pixel_size,length(threshold_image_values))

[flux, flux_error] = calculateFlux(threshold_image_values,im(noise_bounding_array),kccd);

exposure_time = 600;
[instrumental_magnitude, instrumental_magnitude_error] = calculateInstrumentalMagnitude(flux,flux_error,exposure_time)