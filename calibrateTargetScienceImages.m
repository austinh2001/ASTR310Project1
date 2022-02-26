function [final_calibrated_science_images] = calibrateTargetScienceImages(telescope_folder_path,observation_date,telescope_name,target_name,results_folder_path, generic_output_filename,targets_folder_name,calibration_folder_name, biases_folder_name, darks_folder_name, flats_folder_name, science_images_folder_name, shifts_folder_name, rotate)
    % Set default folder names if not provided
    if (nargin==6), targets_folder_name="Targets"; end
    if (nargin<=7), calibration_folder_name="Calibration"; end
    if (nargin<=8), biases_folder_name="Biases"; end
    if (nargin<=9), darks_folder_name="Darks"; end
    if (nargin<=10), flats_folder_name="Flats"; end
    if (nargin<=11), science_images_folder_name="Science Images"; end
    if (nargin<=12), shifts_folder_name="Shifts"; end
    if (nargin<=13), rotate=true; end
    
    %Erase the current directory if included in telescope_folder_path
    current_directory = pwd + "\";
    telescope_folder_path = telescope_folder_path + telescope_name + "\";
    telescope_folder_path = erase(telescope_folder_path,current_directory);
    %Generate a Master Bias
    bias_folder_filepath = telescope_folder_path + calibration_folder_name + "\" + biases_folder_name + "\";
    bias_folder = getFromPath(bias_folder_filepath);
    master_bias = generateMasterBias(bias_folder);
    %Generate a Master Dark
    dark_folder_filepath = telescope_folder_path + calibration_folder_name + "\" + darks_folder_name + "\";
    dark_folder = getFromPath(dark_folder_filepath);
    master_dark = generateMasterDark(dark_folder,master_bias);

    %Get the exposure time of the darks (this assumes they are all the same)
    dark_exposure = getExposureTime(dark_folder);

    %Get the folders for the flats of each filter
    flats_folder_filepath = telescope_folder_path + calibration_folder_name + "\" + flats_folder_name + "\";
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
    science_image_folder_filepath = telescope_folder_path + "\" + targets_folder_name + "\" + target_name + "\" + science_images_folder_name + "\";
    science_image_folder = getFromPath(science_image_folder_filepath);
    science_image_folders = getDirectoryFolders(science_image_folder);

    %Loop through files in each science image folder, apply the necessary
    %calibrations, and use MultiCoAdd to add up all the calibrated science
    %images
    science_image_folders_size = size(science_image_folders);
    number_of_science_image_filters = science_image_folders_size(2);
    final_calibrated_science_images = generateTemplateFITSData(science_image_folders(:,1));
    if(rotate)
        final_calibrated_science_images = rot90(final_calibrated_science_images,-1);
        final_calibrated_science_images = fliplr(final_calibrated_science_images);
    end
    for i=1:number_of_science_image_filters
        calibrated_science_images = generateTemplateFITSData(science_image_folders(:,i));
        if(rotate)
            calibrated_science_images = rot90(calibrated_science_images,-1);
            calibrated_science_images = fliplr(calibrated_science_images);
        end
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
            if(rotate)
                science_image_data = rot90(science_image_data,-1);
                science_image_data = fliplr(science_image_data);
            end
            calibrated_science_images(:,:,j) = science_image_data;
        end
        
        %Shifting The Calibrated Images by Filter
        shifts_file_path = telescope_folder_path + targets_folder_name + "\" + target_name + "\" + shifts_folder_name + "\"+ filter_name + "\";
        shifts_folder = getFromPath(shifts_file_path);
        shifts_filename = observation_date + "_" + target_name + "_" + filter_name + "_shifts.xlsx";
        if(isempty(shifts_folder))
                shifts_array = [[0,0]];
                xShiftSum = 0;
                yShiftSum = 0;
                for k=2:science_image_folders_size(1)
%                     shifts = calculateShift(calibrated_science_images(:,:,k-1),calibrated_science_images(:,:,k));
%                     xShiftSum = xShiftSum + shifts(1);
%                     yShiftSum = yShiftSum + shifts(2);
%                     shifts_array = [shifts_array ; [xShiftSum,yShiftSum]];
                    shifts = calculateShift(calibrated_science_images(:,:,1),calibrated_science_images(:,:,k));
                    shifts_array = [shifts_array ; shifts];
                end
                writematrix(shifts_array,shifts_file_path + shifts_filename)
        else
            if(length(shifts_folder) > 1)
                error("Multiple shift files found at: " + shifts_file_path)
            end
            shift_file_filter_suffix = split(shifts_folder(1).name,"_");
            shift_file_filter_suffix = split(shift_file_filter_suffix(3),".");
            shift_file_filter_suffix = shift_file_filter_suffix(1);
            if(shift_file_filter_suffix ~= filter_name)
                error("Invalid shift file: " + shifts_file_path + shifts_folder(1).name)
            end
        end
        
        calibrated_science_images = shiftImages(pwd + "\" + telescope_folder_path + targets_folder_name + "\" + target_name + "\" + shifts_folder_name + "\" + filter_name + "\" + shifts_filename,calibrated_science_images);

        %Co-Adding the shifted, calibrated science images
        
        if(size(calibrated_science_images,3) ~= 1)
            final_calibrated_science_images(:,:,i) = MultiCoAdd(calibrated_science_images);
        else
            final_calibrated_science_images(:,:,i) = calibrated_science_images;
        end
        figure
        displayAdjustedImage(final_calibrated_science_images(:,:,i))
        title(observation_date + ":" + telescope_name + "-" + target_name + ": " + filter_name)
        %Get the filter name associated with the shifted, calibrated
        %science images
        folder_path = science_image_folders(:,i).folder;
        folder_path_names = split(folder_path,"\");
        filter_name = string(folder_path_names(end));

        %Create the filter folder for this target path if it doesn't exist
        results_for_target_file_path = results_folder_path + observation_date + "\" + telescope_name + "\" + targets_folder_name + "\" + target_name + "\" + filter_name + "\";
        mkdir(results_for_target_file_path);
        %Write the FITS file to the filter folder in the target folder
        unrotated_final_calibrated_science_image = final_calibrated_science_images(:,:,i);
        if(rotate)
                unrotated_final_calibrated_science_image= fliplr(unrotated_final_calibrated_science_image);
                unrotated_final_calibrated_science_image = rot90(unrotated_final_calibrated_science_image);
        end
        wfits(unrotated_final_calibrated_science_image,results_for_target_file_path + observation_date + "_" + generic_output_filename + "_" + telescope_name + "_" + target_name + "_" + filter_name + ".fit");
    end
end