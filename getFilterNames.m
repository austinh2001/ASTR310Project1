function [filter_names] = getFilterNames(filter_file_path)
    filter_names = getDirectoryFilenames(getFromPath(filter_file_path));
end