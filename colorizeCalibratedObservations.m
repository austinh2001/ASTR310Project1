function [colorized_combined_images] = colorizeCalibratedObservations(calibration_folder_path,date,ADU_range,display)
    if (nargin==2), ADU_range=[400,2000]; end
    if (nargin<=3), display=true; end
    [calibratedImageDataArrays, informationTables] = getCalibratedObservations(calibration_folder_path,date);
    informationTables{1}
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
                %color = [0,1,135/255];
                color = [0,1,0];
            elseif(filter_name == "n")
                %color = [1,135/255,0];
                color = [0,0,1];
            elseif(filter_name == "s")
                %color = [234/255,1,0];
                color = [0,0,0];
            end
            n_devs = 1;
            image_data = image_data_array(:,:,i);
            %standard_deviation = std(image_data(:));
            %mean_value = mean(image_data(:));
            %min_value = mean_value - n_devs * standard_deviation;
            [colorized_image, color_object] = colorizeImage(image_data,color,ADU_range);
            colorized_images{end+1} = colorized_image;
            if(display)
                figure
                displayImage(colorized_image)
                hold on
                title(date + ":" + telescope + ":" + target_name + ":" + filter_name)
                createColorbar(color_object,"ADU")
                hold off
            end
        end
        summed_colorized_image = zeros(size(colorized_images{1}));
        for n=1:length(colorized_images)
            summed_colorized_image = coAdd(summed_colorized_image,colorized_images{n});
        end
        colorized_combined_images = [colorized_combined_images summed_colorized_image];
        if(display)
            figure
            displayImage(summed_colorized_image)
        end
    end
end

