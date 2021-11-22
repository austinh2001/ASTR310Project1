%% Calibration Testing
date = "10-27-2021";
data_folder_path = "Observations\" + date + "\";
calibrated_images_folder_path = "Calibrated Images\";
generic_filename = date + "_calibrated_image";

calibrated_science_images = calibrateScienceImages(data_folder_path,calibrated_images_folder_path,generic_filename);
calibrated_Ha_M27_image = calibrated_science_images(:,:,1);
calibrated_OIII_M27_image = calibrated_science_images(:,:,2);
displayAdjustedImage(calibrated_Ha_M27_image,1)
title("Calibrated Hα: "+ date)
sky_noise_region = [[1100,700] ; [1300,900]];
displayRegion(sky_noise_region)
figure

displayAdjustedImage(calibrated_OIII_M27_image,1)
title("Calibrated OIII: "+ date)
displayRegion(sky_noise_region)

% Abnormal pixels appear to be coming from the darks, which are being
% applied to each science image and then shifted to form the seen pattern

% Each dark image has the same hot pixels, indicating that these might be
% due to the ccd rather than cosmic rays. The subtraction of these values
% in the science image result in a hot/cold pixel (depending on resulting
% ADU value)

%% threshE Testing
date = "10-27-2021";
calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + date + "_calibrated_image_OIII"+ ".fit");

displayAdjustedImage(calibrated_Ha_M27_image.data)
figure

sky_noise_region = [[1100,700] ; [1300,900]];
numOfSigma = 5;

Ha_cutoff_ADU = 4000;
threshold_calibrated_Ha_M27_image = threshE(calibrated_Ha_M27_image.data,sky_noise_region,numOfSigma);
[colorized_threshold_calibrated_Ha_M27_image,Ha_colorObject] = colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],Ha_cutoff_ADU);
imshow(colorized_threshold_calibrated_Ha_M27_image)
displayRegion(sky_noise_region)
createColorbar(Ha_colorObject,"ADU Counts")
%createEllipse()
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα: " + date)

OIII_cutoff_ADU = 2000;
threshold_calibrated_OIII_M27_image = threshE(calibrated_OIII_M27_image.data,sky_noise_region,numOfSigma);
[colorized_threshold_calibrated_OIII_M27_image, OIII_colorObject] = colorizeImage(threshold_calibrated_OIII_M27_image,[0,1,0],OIII_cutoff_ADU);
%figure
%imshow(colorized_threshold_calibrated_OIII_M27_image)
%createColorbar(OIII_colorObject,"ADU Counts")
%createEllipse()
title("Colorized-" + string(numOfSigma) + "σ Threshold of OIII: " + date)

coadded_threshold_colorized_calibrated_images = CoAdd(colorized_threshold_calibrated_Ha_M27_image,colorized_threshold_calibrated_OIII_M27_image);
figure
imshow(coadded_threshold_colorized_calibrated_images)
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα & OIII: " + date)
%createVaryingThresholdVideo(calibrated_Ha_M27_image.data,sky_noise_region,5,10)

%% Star Removal
third_date = "10-27-2021";
calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + third_date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + third_date + "_calibrated_image_OIII"+ ".fit");

star_coordinates = [660 271]
star_radius = 7
removed_star_image = replaceE(calibrated_Ha_M27_image.data,star_coordinates(1),star_coordinates(2),star_radius,star_radius,15,15,20,20);
figure
displayAdjustedImage(calibrated_Ha_M27_image.data,5)
figure
displayAdjustedImage(removed_star_image,5)

star_coordinates = [660 271]
star_radius = 7
removed_star_image = replaceE(calibrated_OIII_M27_image.data,star_coordinates(1),star_coordinates(2),star_radius,star_radius,15,15,20,20);
figure
displayAdjustedImage(calibrated_OIII_M27_image.data,5)
figure
displayAdjustedImage(removed_star_image,5)
%% Brightness Comparison
% 2.5 sigma to 4.5 sigma (for both Ha and OIII?)
calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + date + "_calibrated_image_OIII"+ ".fit");
