function [combined_calibrated_science_images] = calibrateScienceImages(data_folder_path)
    %Generate a Master Bias
    bias_directory = data_folder_path + "Calibration\Biases\";
    master_bias = generateMasterBias(bias_directory);
    %Generate a Master Dark
    dark_directory = data_folder_path + "Calibration\Darks\";
    master_dark = generateMasterDark(dark_directory,master_bias);

    %Get the exposure time of the darks (this assumes they are all the same)
    dark_exposure = getExposureTime(dark_directory);

    %Get the exposure time of the flats for each filter (this assumes they are all the same per filter)
    %Loop through flat filter folders
    filter_folders = getDirectoryFolders(data_folder_path + "Calibration\Flats\");

    %Calculate Exposure Time Correction Factor
    %Generalize this to an arbitrary number of filters
    Ha_exposure_time_correction_factor = Ha_flat_exposure/dark_exposure;
    O_exposure_time_correction_factor = O_flat_exposure/dark_exposure;
    master_Ha_flat = generateMasterFlat(Ha_flat_directory,master_bias,master_dark, Ha_exposure_time_correction_factor);
    master_O_flat = generateMasterFlat(O_flat_directory,master_bias,master_dark, O_exposure_time_correction_factor);
    normalized_master_Ha_flat = normalizeMasterFlat(master_Ha_flat);
    normalized_master_O_flat = normalizeMasterFlat(master_O_flat);
    
    %Get all folders containing science images
    science_image_directory = data_folder_path + "Science Images\"
    science_image_folders = dir(fullfile(science_image_directory));

    %Loop through files in each science image folder
    combined_calibrated_science_images = [];
    for i=1:length(science_image_folders)
        science_image_files = dir(fullfile(current_directory + data_folder_path + "Science Images\" + science_image_folders(i),'*.fit'));
        template_science_image_fits = rfits(science_image_files(1));
        calibrated_science_images = zeroes(size(template_science_image_fits.data));
        for j=1:length(science_image_files)
            science_image_fits = rfits(science_image_files(j));
            science_image_data = science_image_fits.data;
            science_image_data = science_image_data - master_bias;
            exposure_time_correction_factor = science_image_fits.exposure/dark_exposure;
            science_image_data = science_image_data - (exposure_time_correction_factor * master_dark);
            science_image_data = science_image_data / normalized_master_flat;
            calibrated_science_images(:,:,j) = science_image_data;
        end
        combined_calibrated_science_image = MultiCoAdd(calibrated_science_images);
        combined_calibrated_science_images = [combined_calibrated_science_images [science_image_folders(i) combined_calibrated_science_image]];
    end
end