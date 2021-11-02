function imr=imshift(im,nr,nc)

% IMSHIFT(im,nr,nc) shifts and image by nr rows and nc columns
% (which can be either positive or negative)

nr=round(nr);
nc=round(nc);
[a,b]=size(im);
imr=zeros(size(im));
tr=(1:a)-nr;
ix=find((tr>0)&(tr<=a)); 
tr=tr(ix);
tc=(1:b)-nc;
ix=find((tc>0)&(tc<=b)); 
tc=tc(ix);
r1=max([1,nr+1]);
r2=min([a,nr+a]);
c1=max([1,nc+1]);
c2=min([b,nc+b]);
imr(r1:r2,c1:c2)=im(tr(1):tr(end),tc(1):tc(end));
