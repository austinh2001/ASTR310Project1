original_fits_image = rfits("C:\Users\austi\Documents\GitHub\NebulaProject\Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-001-ha.fit");
shifted_fits_image = rfits("C:\Users\austi\Documents\GitHub\NebulaProject\Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-002-ha.fit");
original_data = original_fits_image.data;
shifted_data = shifted_fits_image.data;
bins = 100;
n = 1;
blob_number = 5;
octaves = 20;
scale_levels = 5;
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

original_SURFPoints = detectSURFFeatures(histogram_original_fits_image,"MetricThreshold",blob_number,"NumOctaves",octaves,"NumScaleLevels",scale_levels);
shifted_SURFPoints = detectSURFFeatures(histogram_shifted_fits_image,"MetricThreshold",blob_number,"NumOctaves",octaves,"NumScaleLevels",scale_levels);
[original_SURFFeatures, original_SURFPoints] = extractFeatures(histogram_original_fits_image, original_SURFPoints);
[shifted_SURFFeatures, shifted_SURFPoints] = extractFeatures(histogram_shifted_fits_image, shifted_SURFPoints);

pairedSURFFeatures = matchFeatures(original_SURFFeatures, shifted_SURFFeatures);
blob_count = length(pairedSURFFeatures);
original_points = [];
shifted_points = [];
original_points_indices = [];
shifted_points_indices = [];
for i = 1:blob_count
    original_points = [original_points ; original_SURFPoints(pairedSURFFeatures(i, 1), :).Location];
    original_points_indices = [original_points_indices pairedSURFFeatures(i, 1)];
    shifted_points =  [shifted_points ; shifted_SURFPoints(pairedSURFFeatures(i, 2), :).Location];
    shifted_points_indices = [shifted_points_indices pairedSURFFeatures(i, 2)];
end
figure
showMatchedFeatures(histogram_original_fits_image, histogram_shifted_fits_image, original_SURFPoints(original_points_indices, :),shifted_SURFPoints(shifted_points_indices, :), 'falsecolor');
shifts = original_points-shifted_points;
removed_shift_outliers = rmoutliers(shifts);
avg_shift = mean(removed_shift_outliers,1);
corrected_image = imshift(histogram_shifted_fits_image,avg_shift(2),avg_shift(1));
figure
imshowpair(histogram_original_fits_image,corrected_image,'falsecolor');