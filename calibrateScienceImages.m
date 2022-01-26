function [combined_calibrated_science_images] = calibrateScienceImages(data_folder_path, target_folder_path, generic_output_filename, calibration_folder_name, biases_folder_name, darks_folder_name, flats_folder_name, science_images_folder_name, shifts_folder_name)
    % Set default folder names if not provided
    if (nargin==3), calibration_folder_name="Calibration"; end
    if (nargin<=4), biases_folder_name="Biases"; end
    if (nargin<=5), darks_folder_name="Darks"; end
    if (nargin<=6), flats_folder_name="Flats"; end
    if (nargin<=7), science_images_folder_name="Science Images"; end
    if (nargin<=8), shifts_folder_name="Shifts"; end
    
    %Erase the current directory if included in data_folder_path
    current_directory = pwd + "\";
    data_folder_path = erase(data_folder_path,current_directory);

    %Erase the current directory if included in target_folder_path
    current_directory = pwd + "\";
    target_folder_path = erase(target_folder_path,current_directory);

    %Generate a Master Bias
    bias_folder_filepath = data_folder_path + calibration_folder_name + "\" + biases_folder_name + "\";
    bias_folder = getFromPath(bias_folder_filepath);
    master_bias = generateMasterBias(bias_folder);
    %Generate a Master Dark
    dark_folder_filepath = data_folder_path + calibration_folder_name + "\" + darks_folder_name + "\";
    dark_folder = getFromPath(dark_folder_filepath);
    master_dark = generateMasterDark(dark_folder,master_bias);

    %Get the exposure time of the darks (this assumes they are all the same)
    dark_exposure = getExposureTime(dark_folder);

    %Get the folders for the flats of each filter
    flats_folder_filepath = data_folder_path + calibration_folder_name + "\" + flats_folder_name + "\";
    flats_folder = getFromPath(flats_folder_filepath);
    flat_filter_folders = getDirectoryFolders(flats_folder);

    %Calculate Exposure Time Correction Factor for each flat filter
    flat_filter_folders_size = size(flat_filter_folders);
    number_of_flat_filter_folders = flat_filter_folders_size(2);
    filter_exposure_time_correction_factors = zeros(number_of_flat_filter_folders,1);
    for i=1:number_of_flat_filter_folders
        filter_exposure_time_correction_factors(i) = getExposureTime(flat_filter_folders(:,i))/dark_exposure;
    end
    
    %Generate the Master Flats for each filter and their associated
    %normalized master flats for each filter
    flat_template_image = generateTemplateFITSData(flat_filter_folders(:,1));
    master_filter_flats = flat_template_image;
    normalized_master_filter_flats = flat_template_image;

    for j=1:length(number_of_flat_filter_folders)
        master_filter_flats(:,:,j) = generateMasterFlat(flat_filter_folders(:,j),master_bias,master_dark,filter_exposure_time_correction_factors(j));
        normalized_master_filter_flats(:,:,j) = normalizeMasterFlat(master_filter_flats(:,:,j));
    end
    
    %Get all folders containing science images
    science_image_folder_filepath = data_folder_path + science_images_folder_name + "\";
    science_image_folder = getFromPath(science_image_folder_filepath);
    science_image_folders = getDirectoryFolders(science_image_folder);

    %Loop through files in each science image folder, apply the necessary
    %calibrations, and use MultiCoAdd to add up all the calibrated science
    %images
    science_image_folders_size = size(science_image_folders);
    number_of_science_image_filters = science_image_folders_size(2);
    combined_calibrated_science_images = generateTemplateFITSData(science_image_folders(:,1));
    combined_calibrated_science_images = rot90(combined_calibrated_science_images,-1);
    combined_calibrated_science_images = fliplr(combined_calibrated_science_images);
    for i=1:number_of_science_image_filters
        calibrated_science_images = generateTemplateFITSData(science_image_folders(:,i));
        calibrated_science_images = rot90(calibrated_science_images,-1);
        calibrated_science_images = fliplr(calibrated_science_images);
        % Get filter name
        folder_path = science_image_folders(:,i).folder;
        folder_path_names = split(folder_path,"\");
        filter_name = string(folder_path_names(end));

        for j=1:science_image_folders_size(1)
            %Get Directory,Name,FITS File, and Image Data from current
            %science image
            science_image_directory = science_image_folders(j,i).folder;
            science_image_filename = science_image_folders(j,i).name;
            science_image_fits = rfits(fullfile(science_image_directory +"\",science_image_filename));
            science_image_data = science_image_fits.data;

            %Calculate the exposure time correction factor between the
            %science image and the dark image
            exposure_time_correction_factor = science_image_fits.exposure/dark_exposure;

            %Subtracting the master bias
            science_image_data = science_image_data - master_bias;

            %Subtract the bias-subtracted master dark image
            science_image_data = science_image_data - (exposure_time_correction_factor * master_dark);

            %Divide the normalized master flat for the current filter
            science_image_data = science_image_data / normalized_master_filter_flats(i);

            %Store the calibrated image
            science_image_data = rot90(science_image_data,-1);
            science_image_data = fliplr(science_image_data);
            calibrated_science_images(:,:,j) = science_image_data;

            if(j == 1)
                cutoff_ADU = 0;
                if(filter_name == "Ha")
                    cutoff_ADU = 4000;
                elseif(filter_name == "OIII")
                    cutoff_ADU = 4000;
                end

                figure
                [calibrated_M27_image_grayscale, grayscale_color_object] = colorizeImage(science_image_data,[128,128,128],cutoff_ADU);
                displayImage(calibrated_M27_image_grayscale)
                title("M27 " + filter_name + " Calibrated-Pre-Co-Adding Observation Date: 9/24/2021")
                colormap("gray")
            end
        end
        
        %Shifting The Calibrated Images by Filter
        shifts_file_path = getFromPath(data_folder_path + calibration_folder_name + "\" + shifts_folder_name + "\");
        shift_file_found = false;
        if(number_of_science_image_filters > length(shifts_file_path))
            error("The number of filters exceeds the number of availiable shift files.")
        end
        for n=1:number_of_science_image_filters
            shift_file_filter_suffix = split(shifts_file_path(n).name,"_");
            shift_file_filter_suffix = split(shift_file_filter_suffix(2),".");
            shift_file_filter_suffix = shift_file_filter_suffix(1);
            if(filter_name == shift_file_filter_suffix)
                shift_file_found = true;
                shifts_filename = shifts_file_path(n).name;
            end
        end
        if(~shift_file_found)
            error("Shift file not found for filter: " + filter_name)
        end

        shifted_calibrated_science_images = shiftImages(data_folder_path + calibration_folder_name + "\" + shifts_folder_name + "\" + shifts_filename,calibrated_science_images);    

        %Co-Adding the shifted, calibrated science image
        combined_calibrated_science_images(:,:,i) = MultiCoAdd(shifted_calibrated_science_images);
        %Get the filter name associated with the shifted, calibrated
        %science image
        folder_path = science_image_folders(:,i).folder;
        folder_path_names = split(folder_path,"\");
        filter_name = string(folder_path_names(end));

        %Create the filter folder for this target path if it doesn't exist
        mkdir(target_folder_path + filter_name);

        %Write the FITS file to the filter folder in the target folder
        wfits(combined_calibrated_science_images(:,:,i),target_folder_path + filter_name + "\" + generic_output_filename + "_" + filter_name + ".fit");

    end
end