function [ranged_image] = generateRangedImage(image_data,range,replacement_value)
    if (nargin==2), replacement_value=0; end
    min_value = range(1);
    max_value = range(2);
    s = size(image_data);
    for row=1:s(1)
        for col=1:s(2)
            if(image_data(row,col) > max_value || image_data(row,col) < min_value)
                image_data(row,col) = replacement_value;
            end
        end
    end
    ranged_image = image_data;
end

