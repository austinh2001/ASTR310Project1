function [image_data_array] = createImageDataArray(folder_filepath)
    if(folder_filepath == "")
        folder_filepath = uigetdir;
    end
    folder_files = dir(fullfile(folder_filepath,'*.fit'));
    folder_filenames = zeros(size(folder_files))
    for k = 1:length(folder_files)
        baseFileName = folder_files(k).name;
        folder_filenames(k) = baseFileName;
        %fullFileName = fullfile(folder_filepath, baseFileName);
    end
    folder_filenames
end