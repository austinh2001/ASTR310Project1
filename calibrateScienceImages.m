function [combined_calibrated_science_images] = calibrateScienceImages(data_folder_path)
    %Get directory
    current_directory = pwd + "\";
    %Generate a Master Bias
    master_bias = generateMasterBias(current_directory + data_folder_path + "Calibration\Biases\");
    %Generate a Master Dark
    master_dark = generateMasterDark(current_directory + data_folder_path + "Calibration\Darks\",master_bias);

    %Get the exposure time of the darks (this assumes they are all the same)]
    dir(fullfile(current_directory + data_folder_path + "Calibration\Darks\",'*.fit'))
    dark_folder_files = dir(fullfile(current_directory + data_folder_path + "Calibration\Darks\",'*.fit'));
    dark_folder_filenames = strings(size(dark_folder_files));
    for i = 1:length(folder_files)
        baseFileName = folder_files(i).name;
        folder_filenames(i) = baseFileName;
    end
    current_directory + data_folder_path + "Calibration\Darks\" + dark_folder_filenames(1)
    template_dark = rfits(current_directory + data_folder_path + "Calibration\Darks\" + dark_folder_filenames(1));
    dark_exposure = template_dark.exposure;

    %Get the exposure time of the flats (this assumes they are all the same)
    flat_folder_files = dir(fullfile(current_directory + data_folder_path + "Calibration\Flats\",'*.fit'));
    flat_folder_filenames = strings(size(flat_folder_files));
    template_flat = rfits(current_directory + data_folder_path + "Calibration\Flats\" + flat_folder_filenames(1));
    flat_exposure = template_flat.exposure;

    %Calculate Exposure Time Correction Factor
    exposure_time_correction_factor = flat_exposure/dark_exposure;
    master_flat = generateMasterFlat(current_directory + data_folder_path + "Calibration\Flats\",master_bias,master_dark, exposure_time_correction_factor);
    normalized_master_flat = normalizeMasterFlat(master_flat);
    
    %Get all folders containing science images
    science_image_folders = dir(fullfile(current_directory + data_folder_path + "Science Images\"));

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