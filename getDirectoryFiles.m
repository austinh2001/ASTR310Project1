function [folder_files] = getDirectoryFiles(folder)
    %Input: a folder struct provided by the dir method or the custom-made
    %getFromPath method
    %Ouput: an array containing structs which correspond to the files in
    %the provided folder

    if(isempty(folder))
        error("There is nothing in the directory: " + folder.folder)
    end

    folder_files = [];
    for i = 1:length(folder)
        if(not(folder(i).isdir))
            folder_files = [folder_files folder(i)];
        end
    end

end

