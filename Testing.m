%% Calibration Testing
date = "10-27-2021";
data_folder_path = "Observations\" + date + "\";
calibrated_images_folder_path = "Calibrated Images\";
generic_filename = date + "_calibrated_image";

calibrated_science_images = calibrateScienceImages(data_folder_path,calibrated_images_folder_path,generic_filename);
calibrated_Ha_M27_image = calibrated_science_images(:,:,1);
calibrated_OIII_M27_image = calibrated_science_images(:,:,2);
displayAdjustedImage(calibrated_Ha_M27_image,1)
title("Calibrated Hα: "+ date)
sky_noise_region = [[1100,700] ; [1300,900]];
displayRegion(sky_noise_region)
figure

displayAdjustedImage(calibrated_OIII_M27_image,1)
title("Calibrated OIII: "+ date)
displayRegion(sky_noise_region)

% Abnormal pixels appear to be coming from the darks, which are being
% applied to each science image and then shifted to form the seen pattern

% Each dark image has the same hot pixels, indicating that these might be
% due to the ccd rather than cosmic rays. The subtraction of these values
% in the science image result in a hot/cold pixel (depending on resulting
% ADU value)

%% threshE Testing
calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + date + "_calibrated_image_OIII"+ ".fit");
sky_noise_region = [[1100,700] ; [1300,900]];
numOfSigma = 5;

threshold_calibrated_Ha_M27_image = threshE(calibrated_Ha_M27_image.data,sky_noise_region,numOfSigma);
[colorized_threshold_calibrated_Ha_M27_image,Ha_colorObject] = colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],Ha_cutoff_ADU);
imshow(colorized_threshold_calibrated_Ha_M27_image)
createColorbar(Ha_colorObject,"ADU Counts")

display("Select the center:")
mousePos = ginput(1)
Ha_center_coordinates = [mousePos(1),mousePos(2)];

display("Select the major-axis edge:")
mousePos = ginput(1)
Ha_major_radius_edge_point = [mousePos(1),mousePos(2)];
Ha_major_axis_vector =  [Ha_major_radius_edge_point(1)-Ha_center_coordinates(1),Ha_major_radius_edge_point(2)-Ha_center_coordinates(2)]
Ha_major_radius = sqrt((Ha_center_coordinates(1)-Ha_major_radius_edge_point(1))^2+(Ha_center_coordinates(2)-Ha_major_radius_edge_point(2))^2);

display("Select the major-axis edge:")
mousePos = ginput(1)
Ha_minor_radius_edge_point = [mousePos(1),mousePos(2)];
Ha_minor_axis_vector =  [Ha_minor_radius_edge_point(1)-Ha_center_coordinates(1),Ha_minor_radius_edge_point(2)-Ha_center_coordinates(2)]
Ha_minor_radius = sqrt((Ha_center_coordinates(1)-Ha_minor_radius_edge_point(1))^2+(Ha_center_coordinates(2)-Ha_minor_radius_edge_point(2))^2);

n = 1000;
% Beta is the angle between the horizontal axis and the major axis vector
beta = subspace(Ha_major_axis_vector',[-1,0]')
theta = linspace(0,2*pi,n);
x = zeros(n,1);
y = zeros(n,1);
for t=1:n
    x(t,1) =  Ha_major_radius*cos(theta(t));
    y(t,1) =  Ha_minor_radius*sin(theta(t));
end
angle = beta;
alpha = angle;
R  = [cos(alpha) -sin(alpha); sin(alpha)  cos(alpha)];
rotatedXY = R*[x'; y'];
xr = rotatedXY(1,:)';
yr = rotatedXY(2,:)';


Ha_cutoff_ADU = 4000;
threshold_calibrated_Ha_M27_image = threshE(calibrated_Ha_M27_image.data,sky_noise_region,numOfSigma);
[colorized_threshold_calibrated_Ha_M27_image,Ha_colorObject] = colorizeImage(threshold_calibrated_Ha_M27_image,[1,0,0],Ha_cutoff_ADU);
figure
imshow(colorized_threshold_calibrated_Ha_M27_image)
createColorbar(Ha_colorObject,"ADU Counts")
hold on
plot(xr+Ha_center_coordinates(1),yr+Ha_center_coordinates(2),'r');
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα: " + date)

OIII_cutoff_ADU = 2000;
threshold_calibrated_OIII_M27_image = threshE(calibrated_OIII_M27_image.data,sky_noise_region,numOfSigma);
[colorized_threshold_calibrated_OIII_M27_image, OIII_colorObject] = colorizeImage(threshold_calibrated_OIII_M27_image,[0,1,0],OIII_cutoff_ADU);
figure
imshow(colorized_threshold_calibrated_OIII_M27_image)
createColorbar(OIII_colorObject,"ADU Counts")
title("Colorized-" + string(numOfSigma) + "σ Threshold of OIII: " + date)

coadded_threshold_colorized_calibrated_images = CoAdd(colorized_threshold_calibrated_Ha_M27_image,colorized_threshold_calibrated_OIII_M27_image);
figure
imshow(coadded_threshold_colorized_calibrated_images)
title("Colorized-" + string(numOfSigma) + "σ Threshold of Hα & OIII: " + date)
%createVaryingThresholdVideo(calibrated_Ha_M27_image.data,sky_noise_region,5,10)

%% Star Removal

%% Brightness Comparison
calibrated_Ha_M27_image = rfits("Calibrated Images\Ha\" + date + "_calibrated_image_Ha"+ ".fit");
calibrated_OIII_M27_image = rfits("Calibrated Images\OIII\" + date + "_calibrated_image_OIII"+ ".fit");
