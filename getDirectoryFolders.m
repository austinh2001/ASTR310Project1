function [folders] = getDirectoryFolders(folder)
    % Description: Get a cell array containing the folder structs of only the folders in the provided folder (excludes files)

    %----------------------------------------------------------------------

    % Input: A folder struct provided by the getFromRelative path or
    % getFromFullPath functions
    
    %----------------------------------------------------------------------

    % Output: A cell array of folder structs representing the folders

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

    folders = {};
    for i = 1:length(folder)
        if(folder(i).isdir)
            current_directory_path = folder.folder;
            current_folder = folder(i);
            current_folder_name = current_folder.name;
            current_folder = getFromRelativePath(fullfile(current_directory_path + "\",current_folder_name));
            folders{end+1} = current_folder;
        end
    end
end

