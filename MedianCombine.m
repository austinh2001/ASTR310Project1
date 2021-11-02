function [median_combined_image_data] = MedianCombine(image_data_array)
    image_data_array_size = size(image_data_array)
    median_combined_image_data = zeros(image_data_array_size)
    for row=1:image_data_array_size(1)
        for column=1:image_data_array_size(2)
            current_pixel_values = zeros(image_data_array_size(3))
            for image_depth=1:image_data_array_size(3)
                current_pixel_values(image_depth) = image_data_array(image_depth,row,column)
            end
            pixel_median_value = median(current_pixel_values)
            median_combined_image_data(row,column) = pixel_median_value
        end
    end
end
