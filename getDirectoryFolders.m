function [folders] = getDirectoryFolders(folder)
    %Input: a folder struct provided by the dir method or the custom-made
    %getFromPath method
    %Ouput: an array containing structs which correspond to the files in
    %the provided folder

    if(isempty(folder))
        error("There is nothing in the directory: " + folder.folder)
    end

    folders = [];
    for i = 1:length(folder)
        folder(i)
        if(folder(i).isdir)
            current_directory_path = folder.folder;
            current_folder = folder(i);
            current_folder_name = current_folder.name;
            current_folder = getFromPath(fullfile(current_directory_path + "\",current_folder_name));
            folders = [folders current_folder];
        end
    end
end

