function [pix_threshold] = threshE(im,col,row,rad1,rad2,ir1,ir2,or1,or2,Kccd, saturation)

%{
AperE Original code by Professor Andrew Harris. Edited by Alyssa Pagan

Before using aperE.m, rotate your image using imrotate(im,angle) so the
major axis of your object is perpendicular or parallel to your x or y axis.

APER(im,col,row,rad1,rad1,ir1,ir2,or1,or2,Kccd) Do aperture photometry of image "im"
for a star, galaxy or nebula centered at the "row,col" coordinates, For an ellipse 
with a major and minor axis of "rad1,rad2" and an inner sky ellipse with a 
major and minor axis of (ir1,ir2)and outer sky ellipse of "or1,or2" with CCD
gain of Kccd ADU/electron. Optionally, a 11th parameter can be passed
with the saturation value for the CCD.

%} 

%{

ThreshE adaptations by Team CANS

%}

if (nargin==10), saturation=Inf; end

[a,b]=size(im);
[xx,yy]=meshgrid(1:b,1:a);
ixsrc=(((xx-col)./rad1).^2)+(((yy-row)./rad2).^2)<=1;
ixsky=(((xx-col)./or1).^2)+(((yy-row)./or2).^2)<=1 &(((xx-col)./ir1).^2)+(((yy-row)./ir2).^2)>=1;

sky=median(im(ixsky));                        % sky value
pix=im(ixsrc)-sky;                            % source without sky
sig=sqrt(im(ixsrc)/Kccd);                     % photon noise per pixel
ssig=std(im(ixsky))/sqrt(length(ixsky))/Kccd; % sky noise in average

%Find useful threshold value
%Determine optimal threshold and way to achieve it: median may not be the
%best
threshold = median(pix);

%Fit Ellipse
%fitEllipseToImage(ixsrc)

pix_threshold = zeros(size(im));
image_size = size(pix_threshold);
for i=1:image_size(1)
    for j=1:image_size(2)
        if(im(i,j) >= threshold)
            pix_threshold(i,j) = im(i,j)-sky;
        end
    end
end




flx=sum(pix)/Kccd;                            % flux
err=sqrt(sum(sig).^2+ssig^2);                 % total error
issat=0;
if (max(im(ixsrc))>saturation), issat=1; end

fw=or1;
ix=find((xx>=(col-2*fw))&(xx<=(col+2*fw))&(yy>=(row-2*fw))&(yy<=(row+2*fw)));
aa=length(find((xx(1,:)>=(col-2*fw))&(xx(1,:)<=(col+2*fw))));
bb=length(find((yy(:,1)>=(row-2*fw))&(yy(:,1)<=(row+2*fw))));
px=reshape(xx(ix),bb,aa);
py=reshape(yy(ix),bb,aa);
pz=reshape(pix_threshold(ix),bb,aa);
clf;

%Displaying Sky-Subtracted Threshold Image
imagesc(px(1,:),py(:,1),pz);
title("Sky Subtracted Threshold Image");
axis image;
p=(0:360)*pi/180;
xc=(cos(p));
yc=sin(p);
hold on
plot(col+rad1*xc,row+rad2*yc,'w');
plot(col+ir1*xc,row+ir2*yc,'r');
plot(col+or1*xc,row+or2*yc,'r');
hold off
figure

%Displaying Sky-Subtracted Image
pz=reshape(im(ix)-sky,bb,aa);
imagesc(px(1,:),py(:,1),pz);
axis image
p=(0:360)*pi/180;
xc=(cos(p));
yc=sin(p);
hold on
plot(col+rad1*xc,row+rad2*yc,'w');
plot(col+ir1*xc,row+ir2*yc,'r');
plot(col+or1*xc,row+or2*yc,'r');
hold off
title("Sky Subtracted Original Image");
if (~isempty(im(ixsrc))),
  caxis([sky max(im(ixsrc))]); 
end

end

