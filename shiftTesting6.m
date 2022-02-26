original_fits_image = rfits(pwd + "\" + "Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-001-ha.fit");
shifted_fits_image = rfits(pwd + "\" + "Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-016-ha.fit");
original_data = original_fits_image.data;
shifted_data = shifted_fits_image.data;

bins = 100;
n_devs = 1;
blur_number = 12;

standard_deviation = std(original_data(:));
mean_value = mean(mean(original_data));
max_value = mean_value + n_devs * standard_deviation;
min_value =  mean_value - n_devs * standard_deviation;
normalized_fits_image = (original_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_original_fits_image = filloutliers(imgaussfilt(histeq(normalized_fits_image,bins),blur_number),'nearest','mean');

standard_deviation = std(shifted_data(:));
mean_value = mean(mean(shifted_data));
max_value = mean_value + n_devs * standard_deviation;
min_value =  mean_value - n_devs * standard_deviation;
normalized_shifted_fits_image = (shifted_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_shifted_fits_image = filloutliers(imgaussfilt(histeq(normalized_shifted_fits_image,bins),blur_number),'nearest','mean');

k = 1000

[largest_original_k_values, id] = maxk(histogram_original_fits_image(:),k);

[maxOriginalRows,maxOriginalCols] = ind2sub(size(histogram_original_fits_image), id);

figure
imshow(histogram_original_fits_image)
hold on
plot(maxOriginalCols,maxOriginalRows,"r*")
hold off

[largest_shifted_k_values, id] = maxk(histogram_shifted_fits_image(:),k);

[maxShiftedRows,maxShiftedCols] = ind2sub(size(histogram_shifted_fits_image), id);

figure
imshow(histogram_shifted_fits_image)
hold on
plot(maxShiftedCols,maxShiftedRows,"r*")
hold off
display("P")
[d,Z,tr] = procrustes([maxShiftedRows,maxShiftedCols],[maxOriginalRows,maxOriginalCols])

imshow(histogram_original_fits_image)

