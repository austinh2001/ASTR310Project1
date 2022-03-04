function [] = displaySkyNoiseRegion(bounding_array)
    % Sorting the column vectors (corresponds to the vector of x values and a
    % vector of y values) in order to go through the image data from lowest x
    % and y to highest x and y.
    bounding_array = sort(bounding_array);
   
    hold on
    rectangle("Position",[bounding_array(1,1),bounding_array(1,2),abs(bounding_array(2,1)-bounding_array(1,1)),abs(bounding_array(2,2)-bounding_array(1,2))],"EdgeColor","b")   
    hold off
end

