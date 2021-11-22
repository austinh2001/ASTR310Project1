function [star_removed_image_data] = removeStars(image_data, star_data_file)
    star_data = readtable(star_data_file);
    x_coords = star_data.x;
    y_coords = star_data.y;
    star_radii = star_data.radius;
    star_inner_radii = star_data.inner_radius;
    star_outer_radii = star_data.outer_radius;
    star_centers = [x_coords,y_coords];
    star_removed_image_data = image_data;
    for i=1:length(star_centers)
        star_radius = star_radii(i);
        star_inner_radius = star_inner_radii(i);
        star_outer_radius = star_outer_radii(i);
        star_removed_image_data = replaceE(star_removed_image_data,star_centers(i,1),star_centers(i,2),star_radius,star_radius,star_inner_radius,star_inner_radius,star_outer_radius,star_outer_radius);
    end

    %figure
    %displayAdjustedImage(star_removed_image_data,5)
    %hold on
    %for i=1:length(star_centers)
    %    viscircles([star_centers(i,1),star_centers(i,2)],star_radius);
    %    viscircles([star_centers(i,1),star_centers(i,2)],star_inner_radius);
    %    viscircles([star_centers(i,1),star_centers(i,2)],star_outer_radius);
    %end
    %hold off
end

