function [empty] = isPathEmpty(path)
    % Description: Takes either a full path or a relative path (from the current directory) and returns a boolean with true indicating the folder at the path is empty and false indicating it is not empty

    %----------------------------------------------------------------------

    % Input: A full path or a relative path

    %----------------------------------------------------------------------

    % Output: A boolean, with true meaning it is empty and false meaning it has at least one folder/file

    %----------------------------------------------------------------------

    % Errors: 

    % The input path provided is not a string: The provided file path is
    % not a string.

    %----------------------------------------------------------------------
    
    % Checking whether the input value of path is a string and
    % raising an error if it is not
    if(~isstring(path))
        try
            display(path)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input path provided is not a string.")
    end

    % For consistency, rename the path variable
    directory_file_path = path;

    % Get the folder struct of the target path
    directory_folder = dir(directory_file_path);

    % Remove the first two unimportant elements of the folder struct (they
    % have names of ".." and ".")
    directory_folder = directory_folder(3:end);

    % If the target folder is empty, return true, otherwise return false
    empty = isempty(directory_folder);
end

