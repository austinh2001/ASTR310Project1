function [im] = replaceE(im,col,row,rad1,rad2,ir1,ir2,or1,or2)

%{
AperE Original code by Professor Andrew Harris. Edited by Alyssa Pagan
%} 

%{
replaceE adaptations created from AperE by Team CANS
%}

[a,b]=size(im);
[xx,yy]=meshgrid(1:b,1:a);
ixsrc=(((xx-col)./rad1).^2)+(((yy-row)./rad2).^2)<=1;
ixnebula=(((xx-col)./or1).^2)+(((yy-row)./or2).^2)<=1 &(((xx-col)./ir1).^2)+(((yy-row)./ir2).^2)>=1;
nebula=median(im(ixnebula));                    % nebula value

im(ixsrc) = nebula;

end

