function [] = displayImage(image_data)
image_data = rot90(image_data,-1);
image_data = fliplr(image_data);
imshow(image_data)
axis image
set(gca,'YDir','normal') 
end

