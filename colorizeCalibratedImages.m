function [final_colorized_image] = colorizeCalibratedImages(calibration_folder_path,date,desired_telescope_name,desired_target_name,colorization_table,display_colorized_images)
    if (nargin<6), display_colorized_images=true; end
    [calibratedImageDataArrays, informationTables] = getCalibratedObservations(calibration_folder_path,date);
    continue_searching = true;
    for t=1:length(informationTables)
        if(continue_searching)
            table = informationTables(:,t);
            table = table{1};
            colorized_images = {};
            for i=1:height(table)
                telescope = table{i,1};
                target_name = table{i,2};
                filter_name = table{i,3};
                if(telescope == desired_telescope_name)
                    if(target_name == desired_target_name)
                        desired_filters = colorization_table{:,1};
                        if(isempty(desired_filters))
                            desired_filters = table{:,3};
                        end
                        image_data_array = calibratedImageDataArrays(t);
                        image_data_array = image_data_array{1};
                        image_data = image_data_array(:,:,i);
                        color = [0,0,0];
                        if(ismember(filter_name,desired_filters))
                            color = colorization_table{find(desired_filters == filter_name),3};
                            color = color{1};
                            ADU_range = colorization_table{find(desired_filters == filter_name),2};
                            ADU_range = ADU_range{1};
                        else
                            color = [0,0,0];
                            ADU_range = [0,1000];
                        end
                        [colorized_image, color_object] = colorizeImage(image_data,color,ADU_range);
                        colorized_images{end+1} = colorized_image;
                        if(display_colorized_images)
                            figure
                            displayImage(colorized_image)
                            hold on
                            title(date + ":" + telescope + ":" + target_name + ":" + filter_name)
                            createColorbar(color_object,"ADU")
                            hold off
                        end
                        continue_searching = false;
                    end
                end
            end
            summed_colorized_image = zeros(size(colorized_images{1}));
            for n=1:length(colorized_images)
                summed_colorized_image = CoAdd(summed_colorized_image,colorized_images{n});
            end
            final_colorized_image = summed_colorized_image;
            if(display_colorized_images)
                figure
                displayImage(final_colorized_image)
            end
       end        
    end
end

