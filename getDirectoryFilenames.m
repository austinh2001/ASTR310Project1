function [folder_filenames] = getDirectoryFilenames(folder)
    %Input: a folder struct provided by the dir method or the custom-made
    %getFromPath method
    %Ouput: a string array of folder filenames

    if(isempty(folder))
        error("There are no files in the directory: " + folder.folder)
    end

    folder_filenames = strings(size(folder));
    for i = 1:length(folder)
        folder_filenames(i) = folder(i).name;
    end
    
end

