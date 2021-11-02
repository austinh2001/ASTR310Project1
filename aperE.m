function [flx,err]=aperE(im,col,row,rad1,rad2,ir1,ir2,or1,or2,Kccd,saturation)

%{
Original code by Professor Andrew Harris. Edited by Alyssa Pagan

Before using aperE.m, rotate your image using imrotate(im,angle) so the
major axis of your object is perpendicular or parallel to your x or y axis.

APER(im,col,row,rad1,rad1,ir1,ir2,or1,or2,Kccd) Do aperture photometry of image "im"
for a star, galaxy or nebula centered at the "row,col" coordinates, For an ellipse 
with a major and minor axis of "rad1,rad2" and an inner sky ellipse with a 
major and minor axis of (ir1,ir2)and outer sky ellipse of "or1,or2" with CCD
gain of Kccd ADU/electron. Optionally, a 11th parameter can be passed
with the saturation value for the CCD.

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
pz=reshape(im(ix),bb,aa);
clf;
imagesc(px(1,:),py(:,1),pz);
if (~isempty(im(ixsrc))),
  caxis([sky max(im(ixsrc))]); 
end

axis image
p=(0:360)*pi/180;
xc=(cos(p));
yc=sin(p);
hold on
plot(col+rad1*xc,row+rad2*yc,'w');
plot(col+ir1*xc,row+ir2*yc,'r');
plot(col+or1*xc,row+or2*yc,'r');
if (issat),
    ht=text(col,row,'CHECK SATURATION');
    set(ht,'horizontalalign','center','color','w','fontweig','bold','verticalalign','top');
    fprintf(1,'At the peak this source has %0.0f counts.\n',max(im(ixsrc)));
    disp('Judging by the number of counts, if this is a single exposure the');
    disp('source is likely to be saturated. If this is the coadding of many');
    disp('short exposures, check in one of them to see if this message appears.');
    disp('If it does, you need to flag the source as bad in this output file.');
end
hold off



