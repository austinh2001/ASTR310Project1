function [im] = replaceE(im,col,row,rad1,rad2,ir1,ir2,or1,or2,saturation)

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

replaceE adaptations by Team CANS

%}

if (nargin==9), saturation=Inf; end

[a,b]=size(im);
[xx,yy]=meshgrid(1:b,1:a);
ixsrc=(((xx-col)./rad1).^2)+(((yy-row)./rad2).^2)<=1;
ixnebula=(((xx-col)./or1).^2)+(((yy-row)./or2).^2)<=1 &(((xx-col)./ir1).^2)+(((yy-row)./ir2).^2)>=1;
nebula=median(im(ixnebula));                    % nebula value

im(ixsrc) = nebula;

end

