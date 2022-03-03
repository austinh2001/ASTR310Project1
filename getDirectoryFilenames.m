function [folder_filenames] = getDirectoryFilenames(folder)
    % Description: Get an array containing the filenames of only the files in the provided folder (excludes folders)

    %----------------------------------------------------------------------

    % Input: A folder struct provided by the getFromRelative path or
    % getFromFullPath functions
    
    %----------------------------------------------------------------------

    % Output: An array of strings representing the file filenames

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

    folder_filenames = [];

    for i = 1:length(folder)
        if(~folder(i).isdir)
            folder_filenames = [folder_filenames string(folder(i).name)];
        end
    end

end

