function [master_dark] = generateMasterDark(dark_folder,master_bias)
    dark_imageDataArray = createImageDataArray(dark_folder);
    dark_imageDataArray_size = size(dark_imageDataArray);
    for k=1:dark_imageDataArray_size(3)
        dark_imageDataArray(:,:,k) = dark_imageDataArray(:,:,k) - master_bias;
    end
    master_dark = medianCombine(dark_imageDataArray);
    %displayAdjustedImage(master_dark)
    %title("Master Dark")
    %figure
end