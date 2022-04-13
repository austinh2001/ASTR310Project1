function [] = saveImage(image_data,filename)
    imwrite(rot90(image_data),filename)
end