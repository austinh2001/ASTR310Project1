function [color_normalized_image_RGB_data,colorObject] = colorizeImage(image_data,color,range)
    % Normalize the image data relative to some cutoffADU value
    if (nargin==2), range=[0 max(image_data(:))]; end
    normalized_image_data = generateNormalizedImage(image_data,range);
    % Get the associated RGB values
    R = color(1);
    G = color(2);
    B = color(3);
    %Create the RGB image data array
    color_normalized_image_RGB_data = cat(3,normalized_image_data*R,normalized_image_data*G,normalized_image_data*B);
    %Create an generic colormap for your color 
    R_map = linspace(0,1,round(range(2)-range(1))) * R;
    G_map = linspace(0,1,round(range(2)-range(1))) * G;
    B_map = linspace(0,1,round(range(2)-range(1))) * B;
    c_map = [R_map',G_map',B_map'];
    colorObject = {c_map,range};
end