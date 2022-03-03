function [filter_names] = getFilterNames(filter_file_path)
    filter_names = getDirectoryFolderNames(getFromRelativePath(filter_file_path));
end