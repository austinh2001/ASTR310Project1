function [master_flat] = generateMasterFlat(flat_folder_path,master_bias,master_dark, exposure_time_correction_factor)
    flat_imageDataArray = createImageDataArray(flat_folder_path);
    flat_imageDataArray_size = size(flat_imageDataArray);
    master_dark = master_dark * exposure_time_correction_factor;
    for k=1:flat_imageDataArray_size(3)
        flat_imageDataArray(:,:,k) = flat_imageDataArray(:,:,k) - master_bias;
        flat_imageDataArray(:,:,k) = flat_imageDataArray(:,:,k) - master_dark;
    end
    master_flat = MedianCombine(flat_imageDataArray);
end