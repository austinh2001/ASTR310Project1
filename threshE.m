function [threshold_image, threshold] = threshE(im,col,row,rad1,rad2,degrees_angle,noise_region,numOfSigma)

%{
AperE Original code by Professor Andrew Harris. Edited by Alyssa Pagan
%} 

%{
ThreshE adaptations from AperE by Team CANS
%}

%Find the threshold value, as determined by the noise region
threshold = calculateThreshold(im,noise_region,numOfSigma);
threshold_image = zeros(size(im));

[a,b]=size(im);
[xx,yy]=meshgrid(1:b,1:a);

% Figure out how to rotate the ellipse in this context
alpha = degrees_angle * (pi/180);
ixsrc=(((cos(alpha).*(xx-col)+sin(alpha).*(yy-row))./rad1).^2+(((sin(alpha).*(xx-col)-cos(alpha).*(yy-row))./rad2).^2))<=1;
for i=1:a
    for j=1:b
        if(im(i,j) >= threshold && ixsrc(i,j))
            threshold_image(i,j) = im(i,j);
        end
    end
end

end

