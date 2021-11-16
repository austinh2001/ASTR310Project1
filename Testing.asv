%% Calibration Testing
date = "10-27-2021";
calibrated_science_images = calibrateScienceImages("Observations\" + date + "\","Image-shifts-" + date);
calibrated_Ha_M27_image = calibrated_science_images(:,:,1);
calibrated_OIII_M27_image = calibrated_science_images(:,:,2);
wfits(calibrated_Ha_M27_image,"calibrated_Ha_M27_" + date + ".fit")
wfits(calibrated_OIII_M27_image,"calibrated_OIII_M27_" + date + ".fit")
displayAdjustedImage(calibrated_Ha_M27_image)
title("Calibrated Hα: "+ date)
sky_noise_region = [[1100,700] ; [1300,900]];
displayRegion(sky_noise_region)
figure

displayAdjustedImage(calibrated_OIII_M27_image)
title("Calibrated OIII: "+ date)
displayRegion(sky_noise_region)

%% Display Testing
colorized_calibrated_Ha_M27_image = colorizeImage(calibrated_Ha_M27_image,[1,0,0],5);
displayAdjustedImage(colorized_calibrated_Ha_M27_image,-1)
title("Colorized Hα: "+ date)
figure
colorized_calibrated_OIII_M27_image = colorizeImage(calibrated_OIII_M27_image,[0,1,0],5);
displayAdjustedImage(colorized_calibrated_OIII_M27_image,-1)
title("Colorized OIII: "+ date)
figure
coadded_calibrated_images = CoAdd(colorized_calibrated_Ha_M27_image,colorized_calibrated_OIII_M27_image);
displayAdjustedImage(coadded_calibrated_images,-1)
title("CoAdded Colorized Hα & OIII: " + date)
%% threshE Testing
date = "10-27-2021";
calibrated_Ha_M27_image = rfits("calibrated_Ha_M27_" + date + ".fit");
calibrated_OIII_M27_image = rfits("calibrated_OIII_M27_" + date + ".fit");
sky_noise_region = [[1100,700] ; [1300,900]];
numOfSigma = 1.65;
threshold_calibrated_Ha_M27_image = threshE(calibrated_Ha_M27_image.data,sky_noise_region,numOfSigma);
imshow(colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],numOfSigma))
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα: " + date)
figure
threshold_calibrated_OIII_M27_image = threshE(calibrated_OIII_M27_image.data,sky_noise_region,numOfSigma);
imshow(colorizeImage(threshold_calibrated_OIII_M27_image,[0,1,0],numOfSigma))
title("Colorized-" + string(numOfSigma) + "σ Threshold of OIII: " + date)
figure

coadded_threshold_colorized_calibrated_images = CoAdd(colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],numOfSigma),colorizeImage(threshold_calibrated_OIII_M27_image,[0,1,0],numOfSigma));
imshow(coadded_threshold_colorized_calibrated_images)
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα & OIII: " + date)
%createVaryingThresholdVideo(calibrated_Ha_M27_image.data,sky_noise_region,10,10)