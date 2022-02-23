original_fits_image = rfits("C:\Users\Austin\Downloads\20220219_14in_planetarynebula\science\NGC2346-001-ha.fit");
shifted_fits_image = rfits("C:\Users\Austin\Downloads\20220219_14in_planetarynebula\science\NGC2346-016-ha.fit");
original_data = original_fits_image.data;
shifted_data = shifted_fits_image.data;
bins = 100;
n = 1;
blob_number = 5;
octaves = 15;
scale_levels = 5;
blob_count = 1;
blur_number = 12;
standard_deviation = std(original_data(:));
mean_value = mean(mean(original_data));
max_value = mean_value + n * standard_deviation;
min_value =  mean_value - n * standard_deviation;
normalized_fits_image = (original_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_original_fits_image = imgaussfilt(histeq(normalized_fits_image,bins),blur_number);
%imshow(histogram_original_fits_image)
original_blobs = detectSURFFeatures(histogram_original_fits_image,"MetricThreshold",blob_number,"NumOctaves",octaves,"NumScaleLevels",scale_levels);
J = insertMarker(histogram_original_fits_image,original_blobs.selectStrongest(blob_count),'circle');
%figure
%imshow(J)

standard_deviation = std(shifted_data(:));
mean_value = mean(mean(shifted_data));
max_value = mean_value + n * standard_deviation;
min_value =  mean_value - n * standard_deviation;
normalized_shifted_fits_image = (shifted_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_shifted_fits_image = imgaussfilt(histeq(normalized_shifted_fits_image,bins),blur_number);
%imshow(histogram_original_fits_image)
shifted_blobs = detectSURFFeatures(histogram_shifted_fits_image,"MetricThreshold",blob_number,"NumOctaves",octaves,"NumScaleLevels",scale_levels);
J = insertMarker(histogram_shifted_fits_image,shifted_blobs.selectStrongest(blob_count),'circle');
%figure
%imshow(J)

original_SURFPoints = detectSURFFeatures(histogram_original_fits_image,"MetricThreshold",blob_number,"NumOctaves",octaves,"NumScaleLevels",scale_levels);
shifted_SURFPoints = detectSURFFeatures(histogram_shifted_fits_image,"MetricThreshold",blob_number,"NumOctaves",octaves,"NumScaleLevels",scale_levels);
[original_SURFFeatures, original_SURFPoints] = extractFeatures(histogram_original_fits_image, original_SURFPoints);
[shifted_SURFFeatures, shifted_SURFPoints] = extractFeatures(histogram_shifted_fits_image, shifted_SURFPoints);

pairedSURFFeatures = matchFeatures(original_SURFFeatures, shifted_SURFFeatures);
figure
showMatchedFeatures(histogram_original_fits_image, histogram_shifted_fits_image, original_SURFPoints(pairedSURFFeatures(:, 1), :),shifted_SURFPoints(pairedSURFFeatures(:, 2), :), 'montage');

original_points = round(original_SURFPoints(pairedSURFFeatures(:, 1), :).Location);
shifted_points = round(shifted_SURFPoints(pairedSURFFeatures(:, 2), :).Location);
original_points-shifted_points
avg_shift = round(median(original_points-shifted_points))
corrected_image = imshift(histogram_shifted_fits_image,avg_shift(1),avg_shift(2));
figure
imshowpair(histogram_original_fits_image,corrected_image,'falsecolor');