function [folder_folder_names] = getDirectoryFolderNames(folder)
    % Description: Get an array containing the folder names of only the folders in the provided folder (excludes files)

    %----------------------------------------------------------------------

    % Input: A folder struct provided by the getFromRelative path or
    % getFromFullPath functions
    
    %----------------------------------------------------------------------

    % Output: An array of strings representing the folder names

    %----------------------------------------------------------------------

    % Errors:
    % The input provided is not a folder struct: The provided input was not
    % a folder struct.
    
    %----------------------------------------------------------------------

    if(~isstruct(folder))
        try
            display(folder)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided is not a folder struct.")
    end

    folder_folder_names = [];

    for i = 1:length(folder)
        if(folder(i).isdir)
            folder_folder_names = [folder_folder_names string(folder(i).name)];
        end
    end
end

