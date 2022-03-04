function [directory_folder] = getFromRelativePath(relative_path)
    % Description: Takes the file path from the current directory (pwd) and gets the files and folders at the file path in the form of a struct

    %----------------------------------------------------------------------

    % Input: The relative file path from the current directory (pwd)
    % For the sake of error-proofing, you are also allowed to input full
    % filepaths without consequence but that is designed specifically 
    % for getFromFullPath.m
    
    %----------------------------------------------------------------------

    % Output: A struct representing the folder at the relative path 
    
    % This struct contains the following information:
    % name
    % folder (folder path)
    % date
    % bytes
    % isdir (boolean for whether or not this is a directory)
    % datenum

    % This folder struct is the input to various custom-made functions for
    % extracting folder/file information
    % Custom-made files which accept the folder struct as input:
    % getDirectoryFolders.m
    % getDirectoryFiles.m
    % getDirectoryFolderNames.m
    % getDirectoryFilenames.m

    %----------------------------------------------------------------------

    % Errors: 

    % The input path provided is not a string: The provided file path is
    % not a string.

    % The input path is a relative file path, not a full file path: The
    % provided file path is relative (to the current directory), and is not a full file path.

    % The input path does not exist or is empty: The input file path does
    % not exist or it is currently empty, so there is nothing to put into
    % the folder struct. Check whether the folder you are attempting to
    % access is empty beforehand.

    %----------------------------------------------------------------------

    % Checking whether the input value of relative_path is a string and
    % raising an error if it is not
    if(~isstring(relative_path))
        try
            display(relative_path)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input path provided is not a string.")
    end

    % Get the current directory (that you are relative to)
    current_directory = pwd + "\";

    % If the relative path has the current directory in it (i.e. it is
    % actually a full path), then remove it.
    relative_path = erase(relative_path,current_directory);

    % Add the current directory to the relative path to get a full path for
    % the target path
    directory_file_path = current_directory + relative_path;

    % Get the folder struct of the target path
    directory_folder = dir(fullfile(directory_file_path));

    % Remove the first two unimportant elements of the folder struct (they
    % have names of ".." and ".")
    directory_folder = directory_folder(3:end);
    
    % Checking whether the resulting directory folder is empty and raising
    % an error if it is. 
    if(isempty(directory_folder))
        warning("Try using the isPathEmpty.m function to determine if your path is empty beforehand.")
        error("The input path does not exist or is empty: " + directory_file_path)
    end
    
end

