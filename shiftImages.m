function [image_data_array] = shiftImages(shift_file, image_data_array)
    image_data_array_size = size(image_data_array);
    shift_data = readtable(shift_file);
    horizontal_shift = shift_data.Var1;
    vertical_shift = shift_data.Var2;
    for k=1:image_data_array_size(3)
        image_data_array(:,:,k) = imshift(image_data_array(:,:,k),vertical_shift(k),horizontal_shift(k));
    end
end

