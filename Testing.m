%% Calibration Testing
date = "10-27-2021";
calibrated_science_images = calibrateScienceImages("Observations\" + date + "\","Image-shifts-" + date);
calibrated_Ha_M27_image = calibrated_science_images(:,:,1);
calibrated_OIII_M27_image = calibrated_science_images(:,:,2);
wfits(calibrated_Ha_M27_image,"calibrated_Ha_M27_" + date + ".fit")
wfits(calibrated_OIII_M27_image,"calibrated_OIII_M27_" + date + ".fit")
displayAdjustedImage(calibrated_Ha_M27_image)
title("Calibrated H-alpha: "+ date)
sky_noise_region = [[1100,700] ; [1300,900]];
displayRegion(sky_noise_region)
figure

displayAdjustedImage(calibrated_OIII_M27_image)
title("Calibrated OIII: "+ date)
displayRegion(sky_noise_region)

%% Display Testing
colorized_calibrated_Ha_M27_image = colorizeImage(calibrated_Ha_M27_image,[1,0,0],5);
imshow(colorized_calibrated_Ha_M27_image)
title("Colorized H-alpha: "+ date)
figure
colorized_calibrated_OIII_M27_image = colorizeImage(calibrated_OIII_M27_image,[0,1,0],5);
imshow(colorized_calibrated_OIII_M27_image)
title("Colorized OIII: "+ date)
figure
coadded_calibrated_images = CoAdd(colorized_calibrated_Ha_M27_image,colorized_calibrated_OIII_M27_image);
imshow(coadded_calibrated_images)
title("CoAdded Colorized Ha & OIII: " + date)
%% threshE Testing
date = "10-27-2021";
calibrated_Ha_M27_image = rfits("calibrated_Ha_M27_" + date + ".fit");
calibrated_OIII_M27_image = rfits("calibrated_OIII_M27_" + date + ".fit");
sky_noise_region = [[1100,700] ; [1300,900]];
numOfSigma = 5;
threshold_calibrated_Ha_M27_image = threshE(calibrated_Ha_M27_image.data,sky_noise_region,numOfSigma);
imshow(colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],numOfSigma))
title("Colorized-" + string(numOfSigma) + "σ Threshold of H-alpha: " + date)
figure
threshold_calibrated_OIII_M27_image = threshE(calibrated_OIII_M27_image.data,sky_noise_region,numOfSigma);
imshow(colorizeImage(threshold_calibrated_OIII_M27_image,[0,1,0],numOfSigma))
title("Colorized-" + string(numOfSigma) + "σ Threshold of OIII: " + date)
figure

coadded_threshold_colorized_calibrated_images = CoAdd(colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],numOfSigma),colorizeImage(threshold_calibrated_OIII_M27_image,[0,1,0],numOfSigma));
imshow(coadded_threshold_colorized_calibrated_images)
title("Colorized-" + string(numOfSigma) + "σ Threshold of H-alpha & OIII: " + date)
%createVaryingThresholdVideo(calibrated_m27_Ha.data,5,20)
%% Ellipse Testing
[non_zero_subscript_row, non_zero_subscript_column, image_data_points] = ind2sub(size(adjustedData),find(adjustedData));
image_data = zeros(size(data));
s = size(non_zero_subscript_column);
for i=1:s
    image_data(non_zero_subscript_row(i),non_zero_subscript_column(i)) = image_data_points(i);
end
[z,a,b,alpha] = fitellipse([non_zero_subscript_row,non_zero_subscript_column]);
hold on
plotellipse(z,a,b,alpha)