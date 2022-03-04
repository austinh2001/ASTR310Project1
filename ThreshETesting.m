im1 = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Calibrated Images\2022-02-19\07in\Targets\A21\ha\2022-02-19_calibrated_image_07in_A21_ha.fit");
im2 = rfits("C:\Users\Austin\Documents\GitHub\ASTR310Project1\Calibrated Images\2022-02-19\14in\Targets\NGC2346\ha\2022-02-19_calibrated_image_14in_NGC2346_ha.fit");
s = size(im.data);
col = s(2)/2;
row = s(1)/2;
rad1 = 400;
rad2 = 400;
degrees_angle = 0;
noise_region = [[1000,1400] ; [1200,1200]];
z = 3;
kccd = 1/(1.2999999523162842);
focal_length = 3912;
pixel_size = 9;
[threshold_image, pixel_angular_area,flx,flx_err,threshold_ADU] = threshE(im1.data,col,row,rad1,rad2,degrees_angle,noise_region,z,kccd,focal_length,pixel_size);
displayImage(threshold_image)
displayRegion(noise_region)
exposure_time = 300
instrumental_mag1 = -2.5*log10(flx/exposure_time)
instrumental_mag_error1 = (-2.5*flx_err)/(log(10)*flx_err)

[threshold_image, pixel_angular_area,flx,flx_err,threshold_ADU] = threshE(im2.data,col,row,rad1,rad2,degrees_angle,noise_region,z,kccd,focal_length,pixel_size);
displayImage(threshold_image)
displayRegion(noise_region)
exposure_time = 300
instrumental_mag2 = -2.5*log10(flx/exposure_time)
instrumental_mag_error2 = (-2.5*flx_err)/(log(10)*flx_err)