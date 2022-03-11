function [elliptical_region] = generateEllipticalRegion(image_data,center_coordinates,semi_major_axis,semi_minor_axis, degrees_angle)
    if (nargin==4), degrees_angle=0; end
    
    [a,b]=size(image_data);

    % Generate a meshgrid
    [yy,xx]=meshgrid(1:b,1:a);

    % Create a 2D array of boolean values the same size as the original image
    % to determine whether a given point in im is within the rotated ellipse
    alpha = degrees_angle * (pi/180);
    elliptical_region = (((cos(alpha).*(xx-center_coordinates(1))+sin(alpha).*(yy-center_coordinates(2)))./semi_major_axis).^2+(((sin(alpha).*(xx-center_coordinates(1))-cos(alpha).*(yy-center_coordinates(2)))./semi_minor_axis).^2))<=1;
end