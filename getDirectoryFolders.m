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
    
    % Checking whether the input value of folder is a struct and
    % raising an error if it is not
    if(~isstruct(folder))
        try
            display(folder)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided is not a folder struct.")
    end
    
    % Looping through all the elements in the folder struct and selectively 
    % adding elements which are folders (i.e. not a file) to an output cell array (folders).
    folders = {};
    for i = 1:length(folder)
        % If an element has a isdir property which is true, it is a folder and is
        % added to the folders cell array.
        if(folder(i).isdir)

            % The current directory which is associated with folder
            current_directory_path = folder.folder;

            % The current folder element
            current_folder = folder(i);

            % The name associated with the current folder element
            current_folder_name = current_folder.name;

            % The folder struct of the current folder element
            current_folder = getFromRelativePath(fullfile(current_directory_path + "\",current_folder_name));

            % Adding the folder struct of the current folder element to the
            % cell array of folders in the current folder
            folders{end+1} = current_folder;
        end
    end
end

