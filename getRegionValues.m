function [region_values] = getRegionValues(image_data, region)
    % region is defined as a boolean 2D array the same size as image_data
    % which defines which pixels are included and not included in the
    % desired region of the image
    s = size(image_data);
    region_values = [];
    for x=1:s(1)
        for y=1:s(2)
            if(region(x,y))
                region_values = [region_values image_data(x,y)];
            end
        end
    end  
end