% Provide the dates of observation which will be used in this analysis
dates = ["02-05-2022"];


% Create the folder path string for each observation night and the calibrated
% images
observation_folder_path = "Observations\";
results_folder_path = "Calibrated Images\";
observation_folder_path + dates(1) + "\" + "Targets" + "\"
target_names = getTargetNames(observation_folder_path + dates(1) + "\" + "Targets" + "\");
calibrated_images_folder_path = "Calibrated Images\";

% Establish generic filenames for resulting calibrated images
generic_filenames = dates + "_calibrated_image";

calibrated_target_science_images = calibrateTargetScienceImages(observation_folder_path,dates(1),target_names(1),results_folder_path,generic_filenames(1));
displayAdjustedImage(calibrated_science_images(:,:,1))