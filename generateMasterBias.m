function [master_bias] = generateMasterBias(bias_folder)
    bias_imageDataArray = createImageDataArray(bias_folder);
    master_bias = MedianCombine(bias_imageDataArray);
    displayAdjustedImage(master_bias)
    title("Master Bias")
    figure
end