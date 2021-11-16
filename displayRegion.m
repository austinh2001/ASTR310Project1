function [] = displayRegion(region)
    % Sorting the column vectors (corresponds to the vector of x values and a
    % vector of y values) in order to go through the image data from lowest x
    % and y to highest x and y.
    region = sort(region);
   
    hold on
    rectangle("Position",[region(1,1),region(1,2),region(2,1)-region(1,1),region(2,2)-region(1,2)],"EdgeColor","b")   
    hold off
end

