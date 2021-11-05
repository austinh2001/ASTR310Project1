function [exposure_time] = getExposureTime(image_folder)
    image_folder_filenames = getDirectoryFilenames(image_folder);
    current_exposure_time = -1;
    for i = 1:length(image_folder_filenames)
         folder_filepath = image_folder.folder;
         fits_image_filepath = fullfile(folder_filepath + "\", image_folder_filenames(i));
         fits_image = rfits(fits_image_filepath);
         if(i ~= 1 && current_exposure_time ~= fits_image.exposure)
            error("FITS files located at: " + image_folder.folder + " contain image(s) of different exposure times.")
         end
         current_exposure_time = fits_image.exposure;
    end
    exposure_time = current_exposure_time;
    if(exposure_time < 0)
        error("Invalid Exposure Time: " + exposure_time)
    end
end

