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
colors = {[0,0,0],[1,0,0],[0,1,0],[0,0,1]};
colorization_table = createColorizationTable(filters,ADU_ranges,colors)
colorized_combined_image = colorizeCalibratedImages(calibration_folder_path,dates(1),"07in","A21",colorization_table);
saveImage(colorized_combined_image,"Analysis Images/" + "A21_" + "n_o_s" + ".png")

% filters = ["ha","o"];
% ADU_ranges = {[500,3000],[800,5000]};
% colors = {[1,0,0],[0,1,0]};
% colorization_table = createColorizationTable(filters,ADU_ranges,colors)
% colorized_combined_image = colorizeCalibratedImages(calibration_folder_path,dates(1),"14in","NGC2346",colorization_table);
% saveImage(colorized_combined_image,"Analysis Images/" + "NGC2346_" + "ha_o" + ".png")