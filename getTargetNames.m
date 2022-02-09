function [target_names] = getTargetNames(targets_file_path)
    target_names = getDirectoryFilenames(getFromPath(targets_file_path))
end