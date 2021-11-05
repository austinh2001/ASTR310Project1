function [template_image, template_image_size] = generateTemplateFITSData(folder)
    folder_filenames = getDirectoryFilenames(folder);
    current_image_size = -1;
    for i=1:length(folder_filenames);
        folder_directory = folder.folder;
        folder_directory + folder_filenames(i);
        image_fits_file = rfits(fullfile(folder_directory + "\", folder_filenames(i)));
        if(i ~= 1 & current_image_size ~= size(image_fits_file.data))
            error("FITS files located at: " + folder_directory + " contain image(s) of different sizes.")
        end
        current_image_size = size(image_fits_file.data);
    end
    template_image = zeros(current_image_size);
    template_image_size = current_image_size;
end

