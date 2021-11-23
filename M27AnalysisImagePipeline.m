% Provide the dates of observation which will be used in this analysis
dates = ["09-24-2021","09-26-2021"];

% Create the folder path string for each observation nigh and the calibrated
% images
data_folder_paths = "Observations\" + dates + "\";
calibrated_images_folder_path = "Calibrated Images\";

% Establish generic filenames for resulting calibrated images
generic_filenames = dates + "_calibrated_image";

% Region where sky noise will be collected from
sky_noise_region = [[1100,700] ; [1300,900]];

% First Observation Night: 09-24-2021
calibrated_science_images_first_observation = calibrateScienceImages(data_folder_paths(1),calibrated_images_folder_path,generic_filenames(1));
calibrated_Ha_M27_image_first_observation = calibrated_science_images_first_observation(:,:,1);
calibrated_OIII_M27_image_first_observation = calibrated_science_images_first_observation(:,:,2);

% Second Observation Night: 09-26-2021
calibrated_science_images_second_observation = calibrateScienceImages(data_folder_paths(2),calibrated_images_folder_path,generic_filenames(2));
calibrated_Ha_M27_image_second_observation = calibrated_science_images_second_observation(:,:,1);
calibrated_OIII_M27_image_second_observation = calibrated_science_images_second_observation(:,:,2);

% Remove Stars

calibrated_Ha_M27_image_first_observation = removeStars(calibrated_Ha_M27_image_first_observation,"Star_Centers_09-24-2021.xlsx");
calibrated_OIII_M27_image_first_observation = removeStars(calibrated_OIII_M27_image_first_observation,"Star_Centers_09-24-2021.xlsx");

calibrated_Ha_M27_image_second_observation = removeStars(calibrated_Ha_M27_image_second_observation,"Star_Centers_09-26-2021.xlsx");
calibrated_OIII_M27_image_second_observation = removeStars(calibrated_OIII_M27_image_second_observation,"Star_Centers_09-26-2021.xlsx");

% Egain and Kccd of CCD
egain = 2.5999999046325684;
kccd = 1/egain;

% Find the mean sigma for our min and max sigmas for the upcoming use of
% ThreshE
min_sigma = 2.5;
max_sigma = 4.5;
mean_sigma = mean([min_sigma,max_sigma]);

% Combine both observation nights by filter into image data arrays
calibrated_Ha_M27_image_data_array = cat(3,calibrated_Ha_M27_image_first_observation,calibrated_Ha_M27_image_second_observation);
calibrated_OIII_M27_image_data_array = cat(3,calibrated_OIII_M27_image_first_observation,calibrated_OIII_M27_image_second_observation);

% Shift the images in the image data arrays
calibrated_Ha_M27_image_data_array = shiftImages("Observation_Shifts.xlsx",calibrated_Ha_M27_image_data_array);
calibrated_OIII_M27_image_data_array = shiftImages("Observation_Shifts.xlsx",calibrated_OIII_M27_image_data_array);

% Coadd the images by filter
calibrated_Ha_image = MultiCoAdd(calibrated_Ha_M27_image_data_array);
calibrated_OIII_image = MultiCoAdd(calibrated_OIII_M27_image_data_array);

% Set up the parameters for ThreshE

% Ha
Ha_center_coordinates = [643,459];
Ha_major_radius = 560;
Ha_minor_radius = 430;
degrees_angle = -30;

[Ha_threshold_image_min, Ha_angular_area_min,Ha_flux_min,Ha_flux_error_min] = threshE(calibrated_Ha_image,Ha_center_coordinates(1),Ha_center_coordinates(2),Ha_major_radius,Ha_minor_radius,degrees_angle,sky_noise_region,min_sigma,kccd);
[Ha_threshold_image_mean, Ha_angular_area_mean,Ha_flux_mean,Ha_flux_error_mean] = threshE(calibrated_Ha_image,Ha_center_coordinates(1),Ha_center_coordinates(2),Ha_major_radius,Ha_minor_radius,degrees_angle,sky_noise_region,mean_sigma,kccd);
[Ha_threshold_image_max, Ha_angular_area_max,Ha_flux_max,Ha_flux_error_max] = threshE(calibrated_Ha_image,Ha_center_coordinates(1),Ha_center_coordinates(2),Ha_major_radius,Ha_minor_radius,degrees_angle,sky_noise_region,max_sigma,kccd);
Ha_angular_area_error_lower = Ha_angular_area_mean - Ha_angular_area_min;
Ha_angular_area_error_upper = Ha_angular_area_max - Ha_angular_area_mean;

% OIII
OIII_center_coordinates = [643,459];
OIII_major_radius = 560;
OIII_minor_radius = 430;
degrees_angle = -30;

[OIII_threshold_image_min, OIII_angular_area_min,OIII_flux_min,OIII_flux_error_min] = threshE(calibrated_OIII_image,OIII_center_coordinates(1),OIII_center_coordinates(2),OIII_major_radius,OIII_minor_radius,degrees_angle,sky_noise_region,min_sigma,kccd);
[OIII_threshold_image_mean, OIII_angular_area_mean,OIII_flux_mean,OIII_flux_error_mean] = threshE(calibrated_OIII_image,OIII_center_coordinates(1),OIII_center_coordinates(2),OIII_major_radius,OIII_minor_radius,degrees_angle,sky_noise_region,mean_sigma,kccd);
[OIII_threshold_image_max, OIII_angular_area_max,OIII_flux_max,OIII_flux_error_max] = threshE(calibrated_OIII_image,OIII_center_coordinates(1),OIII_center_coordinates(2),OIII_major_radius,OIII_minor_radius,degrees_angle,sky_noise_region,max_sigma,kccd);
OIII_angular_area_error_lower = OIII_angular_area_mean - OIII_angular_area_min;
OIII_angular_area_error_upper = OIII_angular_area_max - OIII_angular_area_mean;

display("OIII/HA Size Ratio: " + string(OIII_angular_area_mean/Ha_angular_area_mean))
display("Ha Size: " + string(Ha_angular_area_mean) + "+" + string(Ha_angular_area_error_upper) + "/-" + string(Ha_angular_area_error_lower))
display("OIII Size: " + string(OIII_angular_area_mean) + "+" + string(OIII_angular_area_error_upper) + "/-" + string(OIII_angular_area_error_lower))
if(OIII_angular_area_mean/Ha_angular_area_mean > 1)
    display("OIII is larger than Ha")
end
Ha_instrumental_mag = -2.5*log10(Ha_flux_mean/600);
Ha_instrumental_mag_error = (-2.5*Ha_flux_error_mean)/(log(10)*Ha_flux_mean);
OIII_instrumental_mag = -2.5*log10(OIII_flux_mean/600);
OIII_instrumental_mag_error = (-2.5*OIII_flux_error_mean)/(log(10)*OIII_flux_mean);
display("OIII instrumental magnitude: " + string(OIII_instrumental_mag))
display("OIII instrumental magnitude error: " + string(OIII_instrumental_mag_error))
display("Ha instrumental magnitude: " + string(Ha_instrumental_mag))
display("Ha instrumental magnitude error: " + string(Ha_instrumental_mag_error))
display("% Difference of instrumental magnitude: " + string((Ha_instrumental_mag-OIII_instrumental_mag)/(Ha_instrumental_mag)*100))
figure
displayAdjustedImage(Ha_threshold_image_mean,3)
figure
displayAdjustedImage(OIII_threshold_image_mean,3)