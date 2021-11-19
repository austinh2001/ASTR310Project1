function [] = generateDataFolder(data_folder_name,target_directory,calibration_folder_name, biases_folder_name, darks_folder_name, flats_folder_name, science_images_folder_name, shifts_folder_name)
    if (nargin==1), target_directory= pwd + "\"; end
    if (nargin<=2), calibration_folder_name="Calibration"; end
    if (nargin<=3), biases_folder_name="Biases"; end
    if (nargin<=4), darks_folder_name="Darks"; end
    if (nargin<=5), flats_folder_name="Flats"; end
    if (nargin<=6), science_images_folder_name="Science Images"; end
    if (nargin<=7), shifts_folder_name="Shifts"; end
    target_directory + data_folder_name
    mkdir(target_directory + data_folder_name + "\" + calibration_folder_name);
    mkdir(target_directory + data_folder_name + "\" + calibration_folder_name + "\" + biases_folder_name);
    mkdir(target_directory + data_folder_name + "\" + calibration_folder_name + "\" + darks_folder_name);
    mkdir(target_directory + data_folder_name + "\" + calibration_folder_name + "\" + flats_folder_name);
    mkdir(target_directory + data_folder_name + "\" + calibration_folder_name + "\" + shifts_folder_name);
    mkdir(target_directory + data_folder_name + "\" + science_images_folder_name);
    mkdir(target_directory + data_folder_name + "\" + "Other");
end

