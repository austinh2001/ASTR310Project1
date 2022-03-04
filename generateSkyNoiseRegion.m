function [sky_noise_region] = generateSkyNoiseRegion(image_data, bounding_array)
    % bounding_array is defined as two opposite points of a rectangular area

    % Sorting the column vectors (corresponds to the vector of x values and a
    % vector of y values) in order to go through the image data from lowest x
    % and y to highest x and y.

    bounding_array = sort(bounding_array);
    image_data = flipud(imrotate(image_data,90));
    sky_noise_region = image_data(bounding_array(1,2):bounding_array(2,2),bounding_array(1,1):bounding_array(2,1));
end