% Provide the dates of observation which will be used in this analysis
dates = ["2022-02-19","2021-09-24","2021-09-26"];
% Create the folder path string for each observation night and the calibrated
% images
observation_folder_path = "Observations\";
results_folder_path = "Calibrated Images\";

% Establish generic filenames for resulting calibrated images
generic_filename = "calibrated_image";
data_folder_path = pwd + "\" + "Data\";

target_data_folder_name = "20220219_14in_planetarynebula";
generateDataFolder(data_folder_path + target_data_folder_name + "\" ,observation_folder_path)
target_data_folder_name = "20220219_07in_PN";
generateDataFolder(data_folder_path + target_data_folder_name + "\" ,observation_folder_path)

calibrateObservationNight(observation_folder_path,dates(1),results_folder_path,generic_filename);

% target_data_folder_name = "20210924_14in_A310_M27";
% generateDataFolder(data_folder_path + target_data_folder_name + "\" ,observation_folder_path)
% calibrateObservationNight(observation_folder_path,dates(2),results_folder_path,generic_filename);
% 
% target_data_folder_name = "20210926_14in_A310_M27";
% generateDataFolder(data_folder_path + target_data_folder_name + "\" ,observation_folder_path)
% calibrateObservationNight(observation_folder_path,dates(3),results_folder_path,generic_filename);
% 
