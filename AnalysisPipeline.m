% Provide the dates of observation which will be used in this analysis
dates = ["2022-02-19","2021-09-24","2021-09-26"];

% Create the folder path string for each observation night and the calibrated
% images
observation_folder_path = "Observations\";
calibration_folder_path = "Calibrated Images\";

% Establish generic filenames for resulting calibrated images
generic_filenames = dates + "_calibrated_image";
filters = ["ha","n","o","s"];
ADU_ranges = {[800,1600],[400,900],[850,900],[500,700]};
colors = {[1,0,0],[0,0,0],[0,1,0],[0,0,1]};
colorization_table = createColorizationTable(filters,ADU_ranges,colors)
%colorized_combined_images = colorizeCalibratedObservations(calibration_folder_path,dates(1),ADU_range);
colorized_combined_image = colorizeCalibratedImages(calibration_folder_path,dates(1),"07in","A21",colorization_table);
saveImage(colorized_combined_image,"Analysis Images/Abell21.png")