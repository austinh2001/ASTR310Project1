original_fits_image = rfits("C:\Users\Austin\Downloads\20220219_14in_planetarynebula\science\NGC2346-001-ha.fit");
shifted_fits_image = rfits("C:\Users\Austin\Downloads\20220219_14in_planetarynebula\science\NGC2346-016-ha.fit");
bins = 100;
s = min(size(original_fits_image.data))
original_data = imresize(original_fits_image.data,[s,s]);
s = min(size(shifted_fits_image.data))
shifted_data = imresize(shifted_fits_image.data,[s,s]);
standard_deviation = std(original_data(:))
n = 1
mean_value = mean(mean(original_data))
max_value = mean_value + n * standard_deviation
min_value =  mean_value - n * standard_deviation
normalized_fits_image = (original_data/(max_value-min_value))-min_value/(max_value-min_value);
standard_deviation = std(shifted_data(:))
mean_value = mean(mean(shifted_data))
max_value = mean_value + n * standard_deviation
min_value =  mean_value - n * standard_deviation
normalized_shifted_fits_image = (shifted_data/(max_value-min_value))-min_value/(max_value-min_value);
n_s = size(normalized_fits_image)
noise_removed = normalized_fits_image
for i=1:n_s(1)
    for j=1:n_s(2)
        if(normalized_fits_image(i,j) < 1)
            noise_removed(i,j) = 0;
        end
    end
end
fixed = noise_removed
%fixed = histeq(normalized_fits_image,bins);
figure
imhist(normalized_fits_image,bins);
n_s = size(normalized_shifted_fits_image)
for i=1:n_s(1)
    for j=1:n_s(2)
        if(normalized_shifted_fits_image(i,j) < 1)
            noise_removed(i,j) = 0;
        end
    end
end
moving = noise_removed
%moving = histeq(normalized_shifted_fits_image,bins);
figure
imshowpair(fixed,moving,'montage')
%figure
tformEstimate = imregcorr(moving,fixed);
isTranslation(tformEstimate)
x_shift = tformEstimate.T(3,1)
y_shift = tformEstimate.T(3,2)
Rfixed = imref2d(size(fixed));
movingReg = imwarp(moving,tformEstimate,'OutputView',Rfixed);
imshowpair(fixed,movingReg,'montage')
figure
imshowpair(fixed,movingReg,'falsecolor');