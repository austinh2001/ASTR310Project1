function [folders] = getDirectoryFolders(directory)
    current_directory = pwd + "\";
    folders = dir(fullfile(current_directory + directory))
    folders = folders(3:end)
end

