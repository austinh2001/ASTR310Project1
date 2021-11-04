function [master_bias] = generateMasterBias(bias_folder_path)
    bias_imageDataArray = createImageDataArray(bias_folder_path);
    master_bias = MedianCombine(bias_imageDataArray);
end