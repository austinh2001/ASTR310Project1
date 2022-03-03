function [target_names] = getTargetNames(targets_file_path)
    target_names = getDirectoryFolderNames(getFromRelativePath(targets_file_path));
end