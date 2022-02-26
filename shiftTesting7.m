original_fits_image = rfits(pwd + "\" + "Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-001-ha.fit");
shifted_fits_image = rfits(pwd + "\" + "Observations\2022-02-19\14in\Targets\NGC2346\Science Images\ha\NGC2346-008-ha.fit");
original_data = original_fits_image.data;
shifted_data = shifted_fits_image.data;

bins = 100;
n_devs = 2;
blur_number = 12;

standard_deviation = std(original_data(:));
mean_value = mean(mean(original_data));
max_value = mean_value + n_devs * standard_deviation;
min_value =  mean_value - n_devs * standard_deviation;
normalized_fits_image = (original_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_original_fits_image = filloutliers(imgaussfilt(histeq(normalized_fits_image,bins),blur_number),'nearest','mean');

standard_deviation = std(shifted_data(:));
mean_value = mean(mean(shifted_data));
max_value = mean_value + n_devs * standard_deviation;
min_value =  mean_value - n_devs * standard_deviation;
normalized_shifted_fits_image = (shifted_data/(max_value-min_value))-min_value/(max_value-min_value);
histogram_shifted_fits_image = filloutliers(imgaussfilt(histeq(normalized_shifted_fits_image,bins),blur_number),'nearest','mean');

%calculate the phase correlation
pcab=pcorr(histogram_original_fits_image,histogram_shifted_fits_image)
surf(pcab,'edgecolor','none')
%the pcorr funtion:

function [pc] = pcorr(f1,f2)
    F1=fft(f1);
    F2=fft(f2);
    F2c=conj(F2);
    PC=F1.*F2c./abs(F1.*F2c);
    pc=ifft(PC);
end