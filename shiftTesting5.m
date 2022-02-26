original_fits_image = rfits(pwd + "\" + "Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-001-ha.fit");
shifted_fits_image = rfits(pwd + "\" + "Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-016-ha.fit");
original_data = original_fits_image.data;
shifted_data = shifted_fits_image.data;
bins = 100;
n = 1;
blur_number = 12;
standard_deviation = std(original_data(:));
mean_value = mean(mean(original_data));
max_value = mean_value + n * standard_deviation;
min_value =  mean_value - n * standard_deviation;
normalized_fits_image = (original_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_original_fits_image = imgaussfilt(histeq(normalized_fits_image,bins),blur_number);

standard_deviation = std(shifted_data(:));
mean_value = mean(mean(shifted_data));
max_value = mean_value + n * standard_deviation;
min_value =  mean_value - n * standard_deviation;
normalized_shifted_fits_image = (shifted_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_shifted_fits_image = imgaussfilt(histeq(normalized_shifted_fits_image,bins),blur_number);

%figure
%surf(histogram_original_fits_image,'edgecolor','none')
%title("Original")
%figure
%surf(histogram_shifted_fits_image,'edgecolor','none')
%title("Shifted")


% First Subtracted
subtracted_image = histogram_original_fits_image-histogram_shifted_fits_image;
[Zmax,Idx] = max(subtracted_image(:));
[ZmaxRow,ZmaxCol] = ind2sub(size(subtracted_image), Idx);

[Zmin,Idx] = min(subtracted_image(:));
[ZminRow,ZminCol] = ind2sub(size(subtracted_image), Idx);

shiftRow = ZmaxRow-ZminRow
shiftCol = ZmaxCol-ZminCol

figure
surf(subtracted_image,'edgecolor','none')
title("First Subtracted")

% Second Subtracted
figure
surf(histogram_shifted_fits_image,'edgecolor','none')
title("OG Shifted")
figure
imshift(histogram_shifted_fits_image,shiftRow,shiftCol)
surf(imshift(histogram_shifted_fits_image,shiftRow,shiftCol),'edgecolor','none')
title("Shifted")
a = imshift(histogram_shifted_fits_image,shiftRow,shiftCol);
a(a==0) = std(histogram_shifted_fits_image(:))
subtracted_image = histogram_original_fits_image-a;
[Zmax,Idx] = max(subtracted_image(:));
[ZmaxRow,ZmaxCol] = ind2sub(size(subtracted_image), Idx);

[Zmin,Idx] = min(subtracted_image(:));
[ZminRow,ZminCol] = ind2sub(size(subtracted_image), Idx);

shiftRow = ZmaxRow-ZminRow
shiftCol = ZmaxCol-ZminCol

figure
surf(subtracted_image,'edgecolor','none')
title("Second Subtracted")


%figure
%imshowpair(histogram_original_fits_image, imshift(histogram_shifted_fits_image,shiftRow,shiftCol),'Scaling','joint')