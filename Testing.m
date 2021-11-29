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

title_prefix = "OIII"
createVaryingThresholdVideo(calibrated_OIII_M27_image.data,title_prefix,sky_noise_region,5,10)

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

calibrated_OIII_M27_image_1 = rfits("Calibrated Images\OIII\" + "09-24-2021" + "_calibrated_image_OIII"+ ".fit");
calibrated_OIII_M27_image_2 = rfits("Calibrated Images\OIII\" + "09-26-2021" + "_calibrated_image_OIII"+ ".fit");

numOfSigma = 5
figure
displayAdjustedImage(calibrated_OIII_M27_image_1.data,numOfSigma)
figure
displayAdjustedImage(calibrated_OIII_M27_image_2.data,numOfSigma)
calibrated_OIII_M27_star_removed_image = removeStars(calibrated_OIII_M27_image_2.data,"Star_Centers_09-26-2021.xlsx");
figure
displayAdjustedImage(calibrated_OIII_M27_star_removed_image,numOfSigma)

%% Size/Brightness Comparison
% 2.5 sigma to 4.5 sigma (for both Ha and OIII?)
egain = 2.5999999046325684
kccd = 1/egain

calibrated_Ha_M27_image_09_24_2021 = rfits("Calibrated Images\Ha\" + "09-24-2021" + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image_09_24_2021 = rfits("Calibrated Images\OIII\" + "09-24-2021" + "_calibrated_image_OIII"+ ".fit");

calibrated_Ha_M27_image_09_26_2021 = rfits("Calibrated Images\Ha\" + "09-26-2021" + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image_09_26_2021 = rfits("Calibrated Images\OIII\" + "09-26-2021" + "_calibrated_image_OIII"+ ".fit");

calibrated_Ha_M27_image_10_27_2021 = rfits("Calibrated Images\Ha\" + "10-27-2021" + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image_10_27_2021 = rfits("Calibrated Images\OIII\" + "10-27-2021" + "_calibrated_image_OIII"+ ".fit");
numOfSigma = 5
%Ha
observation_Ha_image_data_array = cat(3,calibrated_Ha_M27_image_09_24_2021.data,calibrated_Ha_M27_image_09_26_2021.data);
size(observation_Ha_image_data_array)
observation_Ha_image_data_array = shiftImages("Observation_Shifts.xlsx",observation_Ha_image_data_array);
final_Ha_image = MultiCoAdd(observation_Ha_image_data_array);
final_Ha_center_coordinates = [643,459];
final_Ha_major_radius = 560;
final_Ha_minor_radius = 430;
degrees_angle = -30
sky_noise_region = [[1100,700] ; [1300,900]];
[final_Ha_threshold_image, Ha_angular_area,Ha_flux,Ha_flux_error] = threshE(final_Ha_image,final_Ha_center_coordinates(1),final_Ha_center_coordinates(2),final_Ha_major_radius,final_Ha_minor_radius,degrees_angle,sky_noise_region,numOfSigma,kccd);
figure
displayImage(final_Ha_threshold_image)
createEllipse(final_Ha_center_coordinates(1),final_Ha_center_coordinates(2),final_Ha_major_radius,final_Ha_minor_radius,degrees_angle)

%OIII
observation_OIII_image_data_array = cat(3,calibrated_OIII_M27_image_09_24_2021.data,calibrated_OIII_M27_image_09_26_2021.data);
OIII_size = size(observation_OIII_image_data_array)
observation_Ha_image_data_array = shiftImages("Observation_Shifts.xlsx",observation_OIII_image_data_array);
final_OIII_image = MultiCoAdd(observation_OIII_image_data_array);
final_OIII_center_coordinates = [643,459];
final_OIII_major_radius = 560;
final_OIII_minor_radius = 430;
degrees_angle = -30;
sky_noise_region = [[1100,700] ; [1300,900]];
[final_OIII_threshold_image,OIII_angular_area,OIII_flux,OIII_flux_error] = threshE(final_OIII_image,final_OIII_center_coordinates(1),final_OIII_center_coordinates(2),final_OIII_major_radius,final_OIII_minor_radius,degrees_angle,sky_noise_region,numOfSigma,kccd);
figure
displayImage(final_OIII_threshold_image)
createEllipse(final_OIII_center_coordinates(1),final_OIII_center_coordinates(2),final_OIII_major_radius,final_OIII_minor_radius,degrees_angle)

display("OIII/HA Size Ratio: " + string(OIII_angular_area/Ha_angular_area))
Ha_instrumental_mag = -2.5*log10(Ha_flux/600)
Ha_instrumental_mag_error = (-2.5*Ha_flux_error)/(log(10)*Ha_flux)
OIII_instrumental_mag = -2.5*log10(OIII_flux/600)
OIII_instrumental_mag_error = (-2.5*OIII_flux_error)/(log(10)*OIII_flux)
display("OIII instrumental magnitude: " + string(OIII_instrumental_mag))
display("OIII instrumental magnitude error: " + string(OIII_instrumental_mag_error))
display("Ha instrumental magnitude: " + string(Ha_instrumental_mag))
display("Ha instrumental magnitude error: " + string(Ha_instrumental_mag_error))
display("% Difference of instrumental magnitude: " + string((Ha_instrumental_mag-OIII_instrumental_mag)/(Ha_instrumental_mag)*100))
