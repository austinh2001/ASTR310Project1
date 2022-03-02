function [] = calibrateObservationNight(observation_folder_path,observation_date,results_folder_path, generic_output_filename,targets_folder_name,calibration_folder_name, biases_folder_name, darks_folder_name, flats_folder_name, science_images_folder_name, shifts_folder_name, rotate)
    % Set default parameters for naming convention of the folders and
    % rotation
    if (nargin==4), targets_folder_name="Targets"; end
    if (nargin<=5), calibration_folder_name="Calibration"; end
    if (nargin<=6), biases_folder_name="Biases"; end
    if (nargin<=7), darks_folder_name="Darks"; end
    if (nargin<=8), flats_folder_name="Flats"; end
    if (nargin<=9), science_images_folder_name="Science Images"; end
    if (nargin<=10), shifts_folder_name="Shifts"; end
    if (nargin<=11), rotate=true; end

    % File path associated with the telescopes which can be associated to
    % the observation night
    telescopes_folder_path = observation_folder_path + observation_date + "\";

    % Obtain the names of the telescopes for the observation night
    telescope_names = getTelescopeNames(telescopes_folder_path);

    % Goes through each telescope and performs the image calibration for
    % the associated images
    for j=1:length(telescope_names)

        % File path associated with the targets for a given telescope
        targets_folder_path = telescopes_folder_path + telescope_names(j) + "\" + targets_folder_name + "\";

        % Obtain the names of the targets for a given telescope
        target_names = getTargetNames(targets_folder_path);

        %
        for i=1:length(target_names)
            clc
            display("Telescope: " + telescope_names(j))
            display("Processing: " + target_names(i))
            display(int2str(i) + " of " + int2str(length(target_names)))
            calibrateTargetScienceImages(telescopes_folder_path,observation_date,telescope_names(j),target_names(i),results_folder_path,generic_output_filename,targets_folder_name,calibration_folder_name,biases_folder_name,darks_folder_name,flats_folder_name,science_images_folder_name,shifts_folder_name,rotate);
        end
    end
end