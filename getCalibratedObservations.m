function [calibratedImageDataArrays, informationTables] = getCalibratedObservations(calibrated_folder_path,date)
        calibrated_observation_folder_path = calibrated_folder_path + date + "\";
        telescope_names = getTelescopeNames(calibrated_observation_folder_path);
        calibratedImageDataArrays = {};
        telescopes = [];
        targets = [];
        filters = [];
        informationTables = {};
        for i=1:length(telescope_names)
            calibrated_observation_telescope_folder_path = calibrated_observation_folder_path + telescope_names(i) + "\";
            target_label = "Targets";
            calibrated_observation_telescope_target_folder_path = calibrated_observation_telescope_folder_path + target_label + "\";
            target_names = getTargetNames(calibrated_observation_telescope_target_folder_path);
            for j=1:length(target_names)
                calibrated_observation_telescope_target_folder_path = calibrated_observation_telescope_target_folder_path + target_names(j) + "\";
                filter_names = getFilterNames(calibrated_observation_telescope_target_folder_path);
                for k=1:length(filter_names)
                    calibrated_observation_telescope_target_filter_folder_path = calibrated_observation_telescope_target_folder_path + filter_names(k) + "\";
                    image = getDirectoryFilenames(getFromRelativePath(calibrated_observation_telescope_target_filter_folder_path));
                    fits_image = rfits(calibrated_observation_telescope_target_filter_folder_path + image);
                    images(:,:,k) = fits_image.data;
                    telescopes = [telescopes;telescope_names(i)];
                    targets = [targets;target_names(j)];
                    filters = [filters;filter_names(k)];
                end
            end
            calibrated_observations_table = table(telescopes,targets,filters);
            informationTables{end+1} = calibrated_observations_table;
            calibratedImageDataArrays{end+1} = images;
            images = [];
            telescopes = [];
            targets = [];
            filters = [];
        end
end