function [image_data_array] = createImageDataArray(folder)
    folder_filepath = folder.folder;
    folder_filenames = getDirectoryFilenames(folder);

    current_image_size = -1;
    for i=1:length(folder_filenames)
        fits_image_filepath = fullfile(folder_filepath + "\", folder_filenames(i));
        image_fits_file = rfits(fits_image_filepath);
        if(i ~= 1 & current_image_size ~= size(image_fits_file.data))
            error("FITS files located at: " + folder_filepath + " contain image(s) of different sizes.")
        end
        current_image_size = size(image_fits_file.data);
    end

    image_data_array = zeros(current_image_size);

    for k=1:length(folder_filenames)
        fits_image_filepath = fullfile(folder_filepath + "\", folder_filenames(k));
        image_fits_file = rfits(fits_image_filepath);
        image_data_array(:,:,k) = image_fits_file.data;
    end

end