function [normalized_image] = generateNormalizedImage(image_data,range)
min_value = range(1);
max_value = range(2);
normalized_image = (image_data/(max_value-min_value))-min_value/(max_value-min_value);
end

