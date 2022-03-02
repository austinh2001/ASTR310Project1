% Provide the dates of observation which will be used in this analysis
dates = ["2022-02-19"];

% Create the folder path string for each observation night and the calibrated
% images
observation_folder_path = "Observations\";
calibration_folder_path = "Calibrated Images\";

% Establish generic filenames for resulting calibrated images
generic_filenames = dates + "_calibrated_image";

[calibratedImageDataArrays, informationTables] = getCalibratedObservations(calibration_folder_path,dates(1));
multi_co_added_images = [];
colorized_combined_images = [];
for t=1:length(informationTables)
    table = informationTables(:,t);
    table = table{1};
    colorized_images = {};
    for i=1:height(table)
        telescope = table{i,1};
        target_name = table{i,2};
        filter_name = table{i,3};
        image_data_array = calibratedImageDataArrays(t);
        image_data_array = image_data_array{1};
        color = [0,0,0];
        if(filter_name == "ha")
            color = [1,0,0];
        elseif(filter_name == "o")
            color = [0,1,135/255];
        elseif(filter_name == "n")
            color = [1,135/255,0];
        elseif(filter_name == "s")
            color = [234/255,1,0];
        end
        figure
        n_devs = 1;
        image_data = image_data_array(:,:,i);
        %standard_deviation = std(image_data(:));
        %mean_value = mean(image_data(:));
        %min_value = mean_value - n_devs * standard_deviation;
        ADU_range = [400,2000];
        [colorized_image, color_object] = colorizeImage(image_data,color,ADU_range);
        colorized_images{end+1} = colorized_image; 
        displayImage(colorized_image)
        hold on
        title(telescope + ":" + target_name + ":" + filter_name)
        createColorbar(color_object,"ADU")
        hold off
    end
    summed_colorized_image = zeros(size(colorized_images{1}));
    for n=1:length(colorized_images)
        summed_colorized_image = CoAdd(summed_colorized_image,colorized_images{n});
    end
    displayImage(summed_colorized_image)
end

% Remove Stars

% Egain and Kccd of CCD (taken from FITS header of images)

% Combine both observation nights by filter into image data arrays

% Shift the images in the image data arrays

% Coadd the images by filter

