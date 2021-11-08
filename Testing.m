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
option1_fits = rfits("double-option1.fit");
calibrated_data = option1_fits.data;
calibrated_data_size = size(calibrated_data);
scaled_differences = zeros(calibrated_data_size);
for i=1:calibrated_data_size(1)
    for j=1:calibrated_data_size(2)
        value = (calibrated_data(i,j) - calibrated_science_images(i,j,1))/calibrated_data(i,j);
        if(isnan(value) | isinf(value))
            scaled_differences(i,j) = 0;
        else
            scaled_differences(i,j) = (calibrated_data(i,j) - calibrated_science_images(i,j,1))/calibrated_data(i,j)*100;
        end
    end
end

%displayAdjustedImage(scaled_differences)

% NOTE: When comparing to the provided calibrated image (option 1), the
% values don't match up exactly (but seem reasonable?)
%% threshE Testing
m27_Ha = rfits("M27-001-ha.fit");
%m29_2 = rfits("m29-2.fit");
%egain = m29_2.egain;
m29_2_center_coordinates = [1181 681];
target_aperture_radius = 5;
sky_annulus_inner_radius = 10;
sky_annulus_outer_radius = 15;
%src_pix_threshold = threshE(m29_2.data,m29_2_center_coordinates(2),m29_2_center_coordinates(1),target_aperture_radius,target_aperture_radius,sky_annulus_inner_radius,sky_annulus_inner_radius,sky_annulus_outer_radius,sky_annulus_outer_radius,1/egain);


data = m27_Ha.data;
displayAdjustedFITS(m27_Ha)
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