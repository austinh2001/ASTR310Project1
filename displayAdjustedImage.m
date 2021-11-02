function [] = displayAdjustedImage(image_data)
%Modified version of:
%https://www.mathworks.com/matlabcentral/answers/42434-how-to-increase-the-contrast-in-an-image-using-imagesc-with-removal-of-outliers
ndev = 3;
data_mean = mean(image_data(:));
data_std = std(image_data(:));
data_min = min(image_data(:));
data_max = max(image_data(:));
cmin = max(data_min, data_mean - ndev * data_std );
cmax = min(data_max, data_mean + ndev * data_std );
imagesc(image_data,[cmin, cmax])
end
