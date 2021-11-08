%% Calibration Testing
calibrated_science_images = calibrateScienceImages("Data\");
calibrated_Ha_M27_image = calibrated_science_images(:,:,1);
min_val = min(calibrated_Ha_M27_image(:))
calibrated_OIII_M27_image = calibrated_science_images(:,:,2);
%wfits(calibrated_science_images(:,:,1),"challenge2_example_calibration.fit");
wfits(calibrated_Ha_M27_image,"calibrated_Ha_M27.fit")
wfits(calibrated_OIII_M27_image,"calibrated_OIII_M27.fit")
displayAdjustedImage(calibrated_Ha_M27_image)
figure
displayAdjustedImage(calibrated_OIII_M27_image)
%% threshE Testing
calibrated_m27_Ha = rfits("calibrated_Ha_M27.fit");
m27_001 = rfits("Data/Science Images/Ha/M27-001-ha.fit");
egain = m27_001.egain;
m27_center_coordinates = [672 481];
target_aperture_radius = 450;
sky_annulus_inner_radius = 500;
sky_annulus_outer_radius = 550;
src_pix_threshold = threshE(calibrated_m27_Ha.data,m27_center_coordinates(2),m27_center_coordinates(1),target_aperture_radius,target_aperture_radius,sky_annulus_inner_radius,sky_annulus_inner_radius,sky_annulus_outer_radius,sky_annulus_outer_radius,1/egain);
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