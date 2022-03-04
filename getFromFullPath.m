function [directory_folder] = getFromFullPath(full_path)
    % Description: Takes the full file path and gets the files and folders at the file path in the form of a struct
    
    %----------------------------------------------------------------------
    
    % Input: The full file path
    % Unlike getFromRelativePath.m, this function does not allow you to
    % input both relative and full paths. Only full paths will be
    % successful, otherwise it will raise an error.

    %----------------------------------------------------------------------

    % Output: A struct representing the folder at the relative path

    %----------------------------------------------------------------------

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
    
    % Checking whether the input value of full_path is a string and
    % raising an error if it is not
    if(~isstring(full_path))
        try
            display(full_path)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input path provided is not a string.")
    end
    
    % Check whether the input value of full_path is actually a relative
    % path and raise an error if it is
     if(~contains(full_path,pwd))
        error("The input path is a relative file path, not a full file path.")
     end
    
    % For consistency, rename the path variable
    directory_file_path = full_path;
    
    % Get the folder struct of the target path
    directory_folder = dir(directory_file_path);

    % Remove the first two unimportant elements of the folder struct (they
    % have names of ".." and ".")
    directory_folder = directory_folder(3:end);
    
    % Checking whether the resulting directory folder is empty and raising
    % an error if it is. 
    if(isempty(directory_folder))
        error("The input path does not exist or is empty: " + directory_file_path)
    end

end

