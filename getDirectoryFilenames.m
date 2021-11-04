function [folder_filenames] = getDirectoryFilenames(folder_directory)
    current_directory = pwd + "\";
    folder_files = dir(fullfile(current_directory + folder_directory));
    %This removes two strange default "files" provided by the dir function
    folder_files = folder_files(3:end)
    if(isempty(folder_files))
        error("There are no files in the directory: " + folder_directory)
    end
    folder_filenames = strings(size(folder_files));
    for i = 1:length(folder_files)
        folder_filenames(i) = folder_files(i).name;
    end
end

