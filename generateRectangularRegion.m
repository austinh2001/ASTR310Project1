function [rectangular_region] = generateRectangularRegion(image_data, bounding_array)
    % bounding_array is defined as two opposite points of a rectangular area

    % Sorting the column vectors (corresponds to the vector of x values and a
    % vector of y values) in order to go through the image data from lowest x
    % and y to highest x and y.

    bounding_array = sort(bounding_array);
    rectangular_region = zeros(size(image_data));
    s = size(image_data);
     for x=1:s(1)
        for y=1:s(2)
            if((bounding_array(1,1) <= x && x <= bounding_array(2,1)) && (bounding_array(1,2) <= y && y <= bounding_array(2,2)))
                rectangular_region(x,y) = 1;
            end
        end
    end   
end