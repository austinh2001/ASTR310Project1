function [] = calibrateObservationNight(observation_folder_path,observation_date,results_folder_path, generic_output_filename,targets_folder_name,calibration_folder_name, biases_folder_name, darks_folder_name, flats_folder_name, science_images_folder_name, shifts_folder_name, rotate)
    if (nargin==4), targets_folder_name="Targets"; end
    if (nargin<=5), calibration_folder_name="Calibration"; end
    if (nargin<=6), biases_folder_name="Biases"; end
    if (nargin<=7), darks_folder_name="Darks"; end
    if (nargin<=8), flats_folder_name="Flats"; end
    if (nargin<=9), science_images_folder_name="Science Images"; end
    if (nargin<=10), shifts_folder_name="Shifts"; end
    if (nargin<=11), rotate=true; end
    targets_folder_path = observation_folder_path + observation_date + "\" + targets_folder_name + "\";
    target_names = getTargetNames(targets_folder_path);
    bias_folder_filepath = observation_folder_path + observation_date + "\" + calibration_folder_name + "\" + biases_folder_name + "\";
    final_calibrated_target_science_images = generateTemplateFITSData(getFromPath(bias_folder_filepath));
    if(rotate)
        final_calibrated_target_science_images = rot90(final_calibrated_target_science_images,-1);
        final_calibrated_target_science_images = fliplr(final_calibrated_target_science_images);
    end
    for i=1:length(target_names)
        display("Processing: " + target_names(i))
        display(int2str(i) + " of " + int2str(length(target_names)))
        calibrateTargetScienceImages(observation_folder_path,observation_date,target_names(i),results_folder_path,generic_output_filename,targets_folder_name,calibration_folder_name,biases_folder_name,darks_folder_name,flats_folder_name,science_images_folder_name,shifts_folder_name,rotate);
    end
end