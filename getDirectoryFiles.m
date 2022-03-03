function [folder_files] = getDirectoryFiles(folder)
    % Description: Get an array containing the filenames of only the files in the provided folder (excludes folders)

    %----------------------------------------------------------------------

    % Input: A folder struct provided by the getFromRelative path or
    % getFromFullPath functions
    
    %----------------------------------------------------------------------

    % Output: A cell array of folder structs representing the files

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

    folder_files = {};
    for i = 1:length(folder)
        if(~folder(i).isdir)
            folder_files{end+1} = folder(i);
        end
    end
end

