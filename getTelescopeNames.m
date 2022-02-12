function [telescope_names] = getTelescopeNames(telescopes_file_path)
    telescope_names = getDirectoryFilenames(getFromPath(telescopes_file_path));
end