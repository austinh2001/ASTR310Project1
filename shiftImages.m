function [image_data_array] = shiftImages(shift_file, image_data_array)
    image_data_array_size = size(image_data_array)
    shift_data = readtable(shift_file)
    for k=1:image_data_array_size(3)
        image_data_array(:,:,k) = imshift(image_data_array(:,:,k),shift_data(k,1),shift_data(k,2))
    end
end
