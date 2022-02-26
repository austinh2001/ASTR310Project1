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
for t=1:length(informationTables)
    table = informationTables(:,t)
    table = table{1}
    for i=1:height(table)
        telescope = table{i,1};
        image_data_array = calibratedImageDataArrays(t);
        image_data_array = image_data_array{1};
        s = size(image_data_array);
        for j=1:length(s(3))
            figure
            displayAdjustedImage(image_data_array(:,:,j))
        end
        %multi_co_added_images = [multi_co_added_images ; MultiCoAdd(image_data_array{1})];
    end
end
% Remove Stars

% Egain and Kccd of CCD (taken from FITS header of images)

% Combine both observation nights by filter into image data arrays

% Shift the images in the image data arrays

% Coadd the images by filter

