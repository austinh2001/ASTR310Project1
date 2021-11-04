function [image_data_array] = createImageDataArray(folder_directory)
    current_directory = pwd + "\";
    if(folder_directory == "")
        folder_directory = uigetdir;
        folder_directory = erase(folder_directory,current_directory);
    end
    folder_filenames = getDirectoryFilenames(folder_directory);

    current_image_size = -1;
    for i=1:length(folder_filenames)
        image_fits_file = rfits(current_directory + folder_directory + folder_filenames(i));
        if(i ~= 1 & current_image_size ~= size(image_fits_file.data))
            error("FITS files located at: " + folder_directory + " contain image(s) of different sizes.")
        end
        current_image_size = size(image_fits_file.data);
    end

    image_data_array = zeros(current_image_size);

    for k=1:length(folder_filenames)
        image_fits_file = rfits(current_directory + folder_directory + folder_filenames(k));
        image_data_array(:,:,k) = image_fits_file.data;
    end

end