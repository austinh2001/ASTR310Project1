% Provide the dates of observation which will be used in this analysis
dates = ["2022-02-19","2021-09-24","2021-09-26"];

% Create the folder path string for each observation night and the calibrated
% images
observation_folder_path = "Observations\";
calibration_folder_path = "Calibrated Images\";

% Establish generic filenames for resulting calibrated images
generic_filenames = dates + "_calibrated_image";

colorized_combined_images_24 = colorizeCalibratedObservations(calibration_folder_path,dates(2));
colorized_combined_images_26 = colorizeCalibratedObservations(calibration_folder_path,dates(3));