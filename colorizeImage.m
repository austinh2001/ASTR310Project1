function [color_normalized_image_RGB_data,colorObject] = colorizeImage(image_data,color,cutoffADU)
    image_data_vector = image_data(:);
    % Normalize the image data relative to some cutoffADU value
    normalized_image_data = image_data/cutoffADU;
    % Get the associated RGB values
    R = color(1);
    G = color(2);
    B = color(3);

    %Create the RGB image data array
    color_normalized_image_RGB_data = cat(3,normalized_image_data*R,normalized_image_data*G,normalized_image_data*B);
    
    %Create an generic colormap for your color 
    R_map = linspace(0,1,cutoffADU) * R;
    G_map = linspace(0,1,cutoffADU) * G;
    B_map = linspace(0,1,cutoffADU) * B;
    c_map = [R_map',G_map',B_map'];
    limits = [0,cutoffADU];
    colorObject = {c_map,limits};
end