function [master_dark] = generateMasterDark(dark_folder_path,master_bias)
    dark_imageDataArray = createImageDataArray(dark_folder_path);
    dark_imageDataArray_size = size(dark_imageDataArray);
    for k=1:dark_imageDataArray_size(3)
        dark_imageDataArray(:,:,k) = dark_imageDataArray(:,:,k) - master_bias;
    end
    master_dark = MedianCombine(dark_imageDataArray);
end