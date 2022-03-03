function [telescope_names] = getTelescopeNames(telescopes_file_path)
    telescope_names = getDirectoryFolderNames(getFromRelativePath(telescopes_file_path));
end