function [] = generateDataFolder(data_folder_file_path,resulting_data_folder_file_path,targets_folder_name,calibration_folder_name, biases_folder_name, darks_folder_name, flats_folder_name, science_images_folder_name, shifts_folder_name)
    if (nargin==3), resulting_data_folder_file_path= pwd; end
    if (nargin<=4), targets_folder_name= "Targets"; end
    if (nargin<=5), calibration_folder_name="Calibration"; end
    if (nargin<=6), biases_folder_name="Biases"; end
    if (nargin<=7), darks_folder_name="Darks"; end
    if (nargin<=8), flats_folder_name="Flats"; end
    if (nargin<=9), science_images_folder_name="Science Images"; end
    if (nargin<=10), shifts_folder_name="Shifts"; end
    split_data_folder_name = split(data_folder_file_path,"_");

    observation_date = split(split_data_folder_name(1),"\");
    observation_date = observation_date(end);
    observation_date_char = char(observation_date);
    observation_date = convertCharsToStrings(observation_date_char(1:4) + "-" + observation_date_char(5:6) + "-" + observation_date_char(7:8));
    
    telescope_name = split_data_folder_name(2);

    target_names = [];
    science_name = "science";
    science_folder_file_path = data_folder_file_path + science_name + "\";
    science_folder = getFromFullPath(science_folder_file_path);
    science_files = getDirectoryFilenames(science_folder);
    for i=1:length(science_files)
        split_target_file = split(science_files(i),"-");
        target_name = split_target_file(1);
        target_names = [target_names target_name];
    end
    target_names = unique(target_names);

    mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name);
    mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + biases_folder_name);
    mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + darks_folder_name);
    mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + flats_folder_name);
    mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + shifts_folder_name);
    
    for j=1:length(target_names)
        mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + targets_folder_name + "\" + target_names(j));
        mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + targets_folder_name + "\" + target_names(j) + "\" + science_images_folder_name);
    end
    
    mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + "Other");
    target_filters_double_cell = {};
    for k=1:length(target_names)
        target_files = [];
        for s=1:length(science_files)
            split_science_file_name = split(erase(science_files(s),".fit"),"-");
            if(split_science_file_name(1) == target_names(k))
                target_files = [target_files erase(science_files(s),".fit")];
            end
        end
        target_filters = [];
        for f=1:length(target_files)
            split_target_file = split(target_files(f),"-");
            filter = split_target_file(3);
            target_filters = [target_filters filter];
        end
        target_filters = unique(target_filters);
        target_filters_double_cell{end+1} = {target_names(k),target_filters};
    end
    for i=1:length(target_filters_double_cell)
        target_filter_double_cell = target_filters_double_cell{i};
        target_name = target_filter_double_cell{1};
        filter_names = target_filter_double_cell{2};
        for f=1:length(filter_names)
            science_image_filter_folder_file_path = resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + targets_folder_name + "\" + target_name + "\" + science_images_folder_name + "\" + filter_names(f);
            mkdir(science_image_filter_folder_file_path);
            shift_filter_folder_file_path = resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + targets_folder_name + "\" + target_name + "\" + shifts_folder_name + "\" + filter_names(f);
            mkdir(shift_filter_folder_file_path);
            for s=1:length(science_files)
                split_science_file_name = split(erase(science_files(s),".fit"),"-");
                if(split_science_file_name(1) == target_name & split_science_file_name(3) == filter_names(f))
                    copyfile(science_folder_file_path+science_files(s),science_image_filter_folder_file_path)
                end
            end
        end
    end

    calibration_name = "calibration";
    calibration_folder_file_path = data_folder_file_path + calibration_name + "\";
    calibration_folder = getFromFullPath(calibration_folder_file_path);
    calibration_files = getDirectoryFilenames(calibration_folder);
    dark_name = "d";
    bias_name = "bi";
    flat_names = ["flats","flat"];
    dark_file_names = [];
    bias_file_names = [];
    flat_file_double_cells = {};
    flat_filters = [];
    for c=1:length(calibration_files)
        split_calibration_file_name = split(erase(calibration_files(c),".fit"),"-");
        if(split_calibration_file_name(1) == flat_names(1) || split_calibration_file_name(1) == flat_names(2))
            flat_filters = [flat_filters split_calibration_file_name(3)];
            flat_file_double_cells{end+1} = {calibration_files(c),split_calibration_file_name(3)};
        elseif(split_calibration_file_name(3) == bias_name)
            copyfile(calibration_folder_file_path + calibration_files(c),resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + biases_folder_name + "\");
        elseif(split_calibration_file_name(3) == dark_name)
            copyfile(calibration_folder_file_path + calibration_files(c),resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + darks_folder_name + "\");
        end
    end
    flat_filters = unique(flat_filters);

    for i=1:length(flat_filters)
        mkdir(resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + flats_folder_name + "\" + flat_filters(i));
    end
    
    for f=1:length(flat_file_double_cells)
        flat_file_double_cell =  flat_file_double_cells{f};
        flat_filename = flat_file_double_cell{1};
        flat_filter = flat_file_double_cell{2};
        copyfile(calibration_folder_file_path + flat_filename,resulting_data_folder_file_path + observation_date + "\" + telescope_name + "\" + calibration_folder_name + "\" + flats_folder_name + "\" + flat_filter + "\");
    end  
end

