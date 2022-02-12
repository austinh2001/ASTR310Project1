function [directory_elements] = getFromFullPath(full_path)
    %Input: the full path
    %Output: a struct representing the folder at the full path (the
    %struct contains the contents of this folder)

    directory = full_path;
    directory_elements = dir(fullfile(directory));
    directory_elements = directory_elements(3:end);
end

