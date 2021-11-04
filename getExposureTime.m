function [exposure_time] = getExposureTime(image_folder_path)
    current_directory = pwd + "\";
    image_folder_files = dir(fullfile(current_directory + image_folder_path,'*.fit'));
    image_folder_filenames = strings(size(image_folder_files));
    current_exposure_time = -1;
    for i = 1:length(image_folder_files)
         image_folder_filenames(i) = image_folder_files(i).name;
         fits_image = rfits(current_directory + image_folder_path + image_folder_filenames(i));
         if(i ~= 1 && current_exposure_time ~= fits_image.exposure)
            error("FITS files located at: " + image_folder_path + " contain image(s) of different exposure times.")
         end
         current_exposure_time = fits_image.exposure;
    end
    exposure_time = current_exposure_time;
    if(exposure_time < 0)
        error("Invalid Exposure Time: " + exposure_time)
    end
end

