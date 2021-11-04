function [image_data_array] = createImageDataArray(folder_filepath)
    if(folder_filepath == "")
        folder_filepath = uigetdir;
    end
    folder_filepath
    folder_files = dir(fullfile(folder_filepath,'*.fit'))
    folder_filenames = strings(size(folder_files));
    for i = 1:length(folder_files)
        baseFileName = folder_files(i).name;
        folder_filenames(i) = baseFileName;
    end
    template_fits_file = rfits(folder_filepath + folder_filenames(1));
    image_data_array = zeros(size(template_fits_file.data));
    for j = 1:length(folder_filenames)
        fits_file = rfits(folder_filepath + folder_filenames(j));
        image_data_array(:,:,j) = fits_file.data;
    end
end