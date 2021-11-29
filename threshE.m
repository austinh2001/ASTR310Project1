function [threshold_image, pixel_angular_area,flx,err,threshold_ADU] = threshE(im,col,row,rad1,rad2,degrees_angle,noise_region,numOfSigma,Kccd)

%{
AperE Original code by Professor Andrew Harris. Edited by Alyssa Pagan
%} 

%{
ThreshE adaptations from AperE by Team CANS
%}

%Find the threshold value, as determined by the noise region
[threshold_ADU,skyNoiseMu,skyNoiseRegion] = calculateThreshold(im,noise_region,numOfSigma);
threshold_image = zeros(size(im));

[a,b]=size(im);
[xx,yy]=meshgrid(1:b,1:a);

% Figure out how to rotate the ellipse in this context
alpha = degrees_angle * (pi/180);
ixsrc=(((cos(alpha).*(xx-col)+sin(alpha).*(yy-row))./rad1).^2+(((sin(alpha).*(xx-col)-cos(alpha).*(yy-row))./rad2).^2))<=1;
pixel_count = 0;

for i=1:a
    for j=1:b
        if(im(i,j) >= threshold_ADU && ixsrc(i,j))
            pixel_count = pixel_count + 1;
            threshold_image(i,j) = im(i,j);
        end
    end
end

% mm
focal_length = 154 * 25.4;
% arc second/ mm
plate_scale = 206265/focal_length;
% arc second^2/mm^2
plate_scale_area = plate_scale^2;
% mm/pixel_side
pixel_scale = 0.009;
% mm^2/pixel_side^2
pixel_area = pixel_scale^2;

% mm^2
total_pixel_area = pixel_area*pixel_count;

% arc second^2
pixel_angular_area = total_pixel_area * plate_scale_area;

% arc minute^2
pixel_angular_area = pixel_angular_area / (60^2)

sky=skyNoiseMu;                              % sky value
pix=threshold_image(ixsrc)-sky;              % source without sky
sig=sqrt(threshold_image(ixsrc)/Kccd);       % photon noise per pixel
ssig=std(skyNoiseRegion(:))/sqrt(length(skyNoiseRegion(:)))/Kccd; % sky noise in average
flx=sum(pix)/Kccd;                            % flux
err=sqrt(sum(sig).^2+ssig^2);                 % total error

end

