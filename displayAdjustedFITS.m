function [] = displayAdjustedFITS(fits_file)
%Modified version of:
%https://www.mathworks.com/matlabcentral/answers/42434-how-to-increase-the-contrast-in-an-image-using-imagesc-with-removal-of-outliers
ndev = 3;
data_mean = mean(fits_file.data(:));
data_std = std(fits_file.data(:));
data_min = min(fits_file.data(:));
data_max = max(fits_file.data(:));
cmin = max(data_min, data_mean - ndev * data_std );
cmax = min(data_max, data_mean + ndev * data_std );
imagesc(fits_file.data,[cmin, cmax])
end

