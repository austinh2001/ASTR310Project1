function [directory_elements] = getFromPath(relative_path)
    %Input: the relative path from the MATLAB project folder
    %Output: a struct representing the folder at the relative path (the
    %struct contains the contents of this folder)

    current_directory = pwd + "\";
    relative_path = erase(relative_path,current_directory);
    directory = current_directory + relative_path;
    directory_elements = dir(fullfile(directory));
    directory_elements = directory_elements(3:end);
    if(isempty(directory_elements))
        error("Relative path provided is empty, no directory elements can be obtained.")
    end
end

