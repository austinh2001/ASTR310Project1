% Provide the dates of observation which will be used in this analysis
dates = ["2021-10-27"];
% Create the folder path string for each observation night and the calibrated
% images
observation_folder_path = "Test Observations\";
results_folder_path = "Calibrated Images\";

% Establish generic filenames for resulting calibrated images
generic_filename = "calibrated_image";
data_folder_path = "C:\Users\Austin\Downloads\20211027_14in_M27_NGC246_NGC672_M1\"
generateDataFolder(data_folder_path,observation_folder_path)
calibrateObservationNight(observation_folder_path,dates(1),results_folder_path,generic_filename);

