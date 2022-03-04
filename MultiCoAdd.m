function [summated_image_data] = multiCoAdd(image_data_array)
    image_data_array_size = size(image_data_array);
    summated_image_data = zeros(image_data_array_size(1),image_data_array_size(2));
    for i=1:image_data_array_size(3)
        summated_image_data = coAdd(summated_image_data,image_data_array(:,:,i));
    end
end

