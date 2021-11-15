function [color_normalized_image_RGB_data] = colorizeImage(image_data,color,numOfSigma)
    if (nargin==2), numOfSigma=0; end
    meanValue = mean(mean(image_data));
    color_normalized_image_data = image_data/(meanValue+numOfSigma*std(std(image_data)));
    color_normalized_image_RGB_data = cat(3,color_normalized_image_data,color_normalized_image_data,color_normalized_image_data);
    R = color(1);
    G = color(2);
    B = color(3);
    color_normalized_image_RGB_data(:,:,1) = color_normalized_image_RGB_data(:,:,1) * R;
    color_normalized_image_RGB_data(:,:,2) = color_normalized_image_RGB_data(:,:,2) * G;
    color_normalized_image_RGB_data(:,:,3) = color_normalized_image_RGB_data(:,:,3) * B;
end