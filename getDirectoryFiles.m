function [folder_files] = getDirectoryFiles(folder_directory)
    current_directory = pwd + "\";
    folder_files = dir(fullfile(current_directory + folder_directory));
    folder_files = folder_files(3:end)
end

