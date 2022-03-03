function [shifts_array] = calculateShift(original_data,shifted_data)
%     bins = 100;
%     n = 1;
%     blob_number = 5;
%     octaves = 20;
%     scale_levels = 5;
%     blur_number = 12;
    bins = 100;
    n_devs = 1;
%     blur_number = 20;

%     standard_deviation = std(original_data(:));
%     mean_value = mean(mean(original_data));
%     max_value = mean_value + n_devs * standard_deviation;
%     min_value =  mean_value - n_devs * standard_deviation;
%     normalized_fits_image = (original_data/(max_value-min_value))-min_value/(max_value-min_value);
%     histogram_original_fits_image = filloutliers(imgaussfilt(histeq(normalized_fits_image,bins),blur_number),'nearest','mean');
% 
%     standard_deviation = std(shifted_data(:));
%     mean_value = mean(mean(shifted_data));
%     max_value = mean_value + n_devs * standard_deviation;
%     min_value =  mean_value - n_devs * standard_deviation;
%     normalized_shifted_fits_image = (shifted_data/(max_value-min_value))-min_value/(max_value-min_value);
%     histogram_shifted_fits_image = filloutliers(imgaussfilt(histeq(normalized_shifted_fits_image,bins),blur_number),'nearest','mean');

    standard_deviation = std(original_data(:));
    mean_value = mean(original_data(:));
    max_value = mean_value + n_devs * standard_deviation;
    min_value =  mean_value - n_devs * standard_deviation;
    normalized_fits_image = (original_data/(max_value-min_value))-min_value/(max_value-min_value);
    histogram_original_fits_image = histeq(normalized_fits_image,bins);

    standard_deviation = std(shifted_data(:));
    mean_value = mean(shifted_data(:));
    max_value = mean_value + n_devs * standard_deviation;
    min_value =  mean_value - n_devs * standard_deviation;
    normalized_shifted_fits_image = (shifted_data/(max_value-min_value))-min_value/(max_value-min_value);
    histogram_shifted_fits_image = histeq(normalized_shifted_fits_image,bins);
    
    % Credit for POCShift (https://www.mathworks.com/matlabcentral/fileexchange/46978-pocshift)
    shifts_array = POCShift(histogram_shifted_fits_image,histogram_original_fits_image);
    rn = shifts_array(2);
    cn = shifts_array(1);
    %imshowpair(histogram_original_fits_image, imshift(histogram_shifted_fits_image,rn,cn),"falsecolor")
end