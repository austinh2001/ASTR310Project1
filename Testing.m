%% Calibration Testing
testing_date = "09-24-2021";
data_folder_path = "Observations\" + testing_date + "\";
calibrated_images_folder_path = "Calibrated Images\";
generic_filename = testing_date + "_calibrated_image";

calibrated_science_images = calibrateScienceImages(data_folder_path,calibrated_images_folder_path,generic_filename);
calibrated_Ha_M27_image = calibrated_science_images(:,:,1);
calibrated_OIII_M27_image = calibrated_science_images(:,:,2);
displayAdjustedImage(calibrated_Ha_M27_image,1)
title("Calibrated Hα: "+ testing_date)
sky_noise_region = [[1100,700] ; [1300,900]];
displayRegion(sky_noise_region)
figure

displayAdjustedImage(calibrated_OIII_M27_image,1)
title("Calibrated OIII: "+ testing_date)
displayRegion(sky_noise_region)

% Abnormal pixels appear to be coming from the darks, which are being
% applied to each science image and then shifted to form the seen pattern

% Each dark image has the same hot pixels, indicating that these might be
% due to the ccd rather than cosmic rays. The subtraction of these values
% in the science image result in a hot/cold pixel (depending on resulting
% ADU value)

%% threshImage Testing
calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + testing_date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + testing_date + "_calibrated_image_OIII"+ ".fit");

sky_noise_region = [[1100,700] ; [1300,900]];
numOfSigma = 0;

Ha_cutoff_ADU = 4000;
threshold_calibrated_Ha_M27_image = threshImage(calibrated_Ha_M27_image.data,sky_noise_region,numOfSigma);
[colorized_threshold_calibrated_Ha_M27_image,Ha_colorObject] = colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],Ha_cutoff_ADU);
figure
displayImage(colorized_threshold_calibrated_Ha_M27_image)
displayRegion(sky_noise_region)
createColorbar(Ha_colorObject,"ADU Counts")
%createUserEllipse()
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα: " + testing_date)

% the cutoff_ADU for both filters should be the same in order to
% appropriately compare the two in terms of actual brightness
OIII_cutoff_ADU = 4000;
threshold_calibrated_OIII_M27_image = threshImage(calibrated_OIII_M27_image.data,sky_noise_region,numOfSigma);
[colorized_threshold_calibrated_OIII_M27_image, OIII_colorObject] = colorizeImage(threshold_calibrated_OIII_M27_image,[0,1,135/255],OIII_cutoff_ADU);
figure
displayImage(colorized_threshold_calibrated_OIII_M27_image)
createColorbar(OIII_colorObject,"ADU Counts")
%createUserEllipse()
title("Colorized-" + string(numOfSigma) + "σ Threshold of OIII: " + testing_date)

coadded_threshold_colorized_calibrated_images = CoAdd(colorized_threshold_calibrated_Ha_M27_image,colorized_threshold_calibrated_OIII_M27_image);
figure
displayImage(coadded_threshold_colorized_calibrated_images)
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα & OIII: " + testing_date)

%title_prefix = "Ha"
%createVaryingThresholdVideo(calibrated_Ha_M27_image.data,title_prefix,sky_noise_region,5,10)

% We can see the central white dwarf in OIII and not in Ha
% This helps us understand that the OIII is more within the interior while
% Ha is along the shell of the planetary nebula

%% threshE Testing

calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + testing_date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + testing_date + "_calibrated_image_OIII"+ ".fit");
sky_noise_region = [[1100,700] ; [1300,900]];
degrees_angle = -45;
nebula_center_coordinates = [705,462];
%nebula_major_radius = 1300;
%nebula_minor_radius = 1300;

nebula_major_radius = 600;
nebula_minor_radius = 600;
figure
displayAdjustedImage(calibrated_Ha_M27_image.data,5)
thresholdImage = threshE(calibrated_Ha_M27_image.data,nebula_center_coordinates(1),nebula_center_coordinates(2),nebula_major_radius,nebula_minor_radius,degrees_angle,sky_noise_region,5);
figure
displayImage(thresholdImage)
%createEllipse(nebula_center_coordinates(1),nebula_center_coordinates(2),nebula_major_radius,nebula_minor_radius,0)
createEllipse(nebula_center_coordinates(1),nebula_center_coordinates(2),nebula_major_radius,nebula_minor_radius,degrees_angle)
%% Star Removal

calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + testing_date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + testing_date + "_calibrated_image_OIII"+ ".fit");

numOfSigma = 3
figure
displayAdjustedImage(calibrated_Ha_M27_image.data,numOfSigma)
calibrated_Ha_M27_star_removed_image = removeStars(calibrated_Ha_M27_image.data,"Ha_Star_Centers.xlsx");
figure
displayAdjustedImage(calibrated_Ha_M27_star_removed_image,numOfSigma)
2.
%% Brightness Comparison
% 2.5 sigma to 4.5 sigma (for both Ha and OIII?)
calibrated_Ha_M27_image_09_24_2021 = rfits("Calibrated Images\Ha\" + "09-24-2021" + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image_09_24_2021 = rfits("Calibrated Images\OIII\" + "09-24-2021" + "_calibrated_image_OIII"+ ".fit");

calibrated_Ha_M27_image_09_26_2021 = rfits("Calibrated Images\Ha\" + "09-26-2021" + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image_09_26_2021 = rfits("Calibrated Images\OIII\" + "09-26-2021" + "_calibrated_image_OIII"+ ".fit");

calibrated_Ha_M27_image_10_27_2021 = rfits("Calibrated Images\Ha\" + "10-27-2021" + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image_10_27_2021 = rfits("Calibrated Images\OIII\" + "10-27-2021" + "_calibrated_image_OIII"+ ".fit");
figure
displayAdjustedImage(calibrated_Ha_M27_image_09_24_2021.data)
observation_Ha_image_data_array = cat(3,calibrated_Ha_M27_image_09_24_2021.data,calibrated_Ha_M27_image_09_26_2021.data);
size(observation_Ha_image_data_array)
observation_Ha_image_data_array = shiftImages("Observation_Shifts.xlsx",observation_Ha_image_data_array);
figure
displayAdjustedImage(calibrated_Ha_M27_image_09_24_2021.data)
figure
displayAdjustedImage(calibrated_Ha_M27_image_09_26_2021.data)
figure
displayAdjustedImage(calibrated_Ha_M27_image_10_27_2021.data)
final_Ha = MultiCoAdd(observation_Ha_image_data_array);
figure
displayAdjustedImage(final_Ha)