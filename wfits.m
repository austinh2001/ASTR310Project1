function wfits(k,fname,options)

% WFITS	Write a FITS format file
%	WFITS(structure,file) produces a FITS file with the information 
%	contained in the structure.
%   WFITS(array,file) produces a FITS file with a minimal header.
%   WFITS(structure,file,options) enables the chosen option
%   Currently the only option is "simple", which produces a .fits
%   file with a minimal header containing the astrometry.

if (nargin==2),
    options='';
end

rlen=2880;	% FITS record length
h=fopen(fname,'w','b'); % Big endian IEEE format
if (h<0),
	error('Cannot open file');
end

if (~isstruct(k)),
    u=k;
    k=[];
    k.data=u;
end
% Defining defaults
if (~isfield(k,'bitpix')),
    k.bitpix=-32;
end
if (~isfield(k,'blank')),
    k.blank=NaN;
end
if (~isfield(k,'naxis')),
    k.naxis=ndims(k.data);
    s=size(k.data);
    for i=1:k.naxis,
        k.numpt(i)=s(i);
    end
end
if (~isfield(k,'ctype')),
    for i=1:k.naxis,
        k.ctype{i}='unknown ';
    end
end
if (~isfield(k,'crpix')),
    for i=1:k.naxis,
        k.crpix(i)=1;
        k.crval(i)=1;
        k.cdelt(i)=1;
        k.crota(i)=0;
    end
end
        

if (k.bitpix>0),
    if (~(isfield(k,'bscale')&&isfield(k,'bzero'))),
        nlev=2^(k.bitpix-1)-1;
        nval=prod(k.numpt(1:k.naxis));
        minv=min(k.data(1:nval));
        maxv=max(k.data(1:nval));
        k.bzero=minv;
        k.bscale=(maxv-minv)/nlev;
    end
else
    k.bscale=1;
    k.bzero=0;
end
str='SIMPLE  =                    T /'; c=wpad(h,str);
str=sprintf('BITPIX  = %20d /',k.bitpix); c=c+wpad(h,str);
str=sprintf('NAXIS   = %20d /',k.naxis); c=c+wpad(h,str);
for i=1:k.naxis,
	str=sprintf('NAXIS%d  = %20d /',i,k.numpt(i)); c=c+wpad(h,str);
end
for i=1:k.naxis,
    u=k.ctype{i};
	str=sprintf('CTYPE%d  = ''%-8s''           /',i,u); c=c+wpad(h,str);
	str=sprintf('CRPIX%d  = %20.8f /',i,k.crpix(i)); c=c+wpad(h,str);
	str=sprintf('CRVAL%d  = %20.8f /',i,k.crval(i)); c=c+wpad(h,str);
    if (isfield(k,'cdelt')),
    	str=sprintf('CDELT%d  = %20.8f /',i,k.cdelt(i)); c=c+wpad(h,str);
    end
    if (isfield(k,'crota')),
        str=sprintf('CROTA%d  = %20.8f /',i,k.crota(i)); c=c+wpad(h,str);
    end
	if (isfield(k,'cunit')),
        if (~isempty(k.cunit{i})),
            str=sprintf('CUNIT%d  = ''%s'' /',i,k.cunit{i}); c=c+wpad(h,str);
        end
    end
end
if (isfield(k,'cd1_1')),
    str=sprintf('CD1_1   = %20g /',k.cd1_1); c=c+wpad(h,str); 
    str=sprintf('CD1_2   = %20g /',k.cd1_2); c=c+wpad(h,str); 
    str=sprintf('CD2_1   = %20g /',k.cd2_1); c=c+wpad(h,str); 
    str=sprintf('CD2_2   = %20g /',k.cd2_2); c=c+wpad(h,str); 
elseif (isfield(k,'pc1_1')),
    str=sprintf('PC1_1   = %20g /',k.pc1_1); c=c+wpad(h,str); 
    str=sprintf('PC1_2   = %20g /',k.pc1_2); c=c+wpad(h,str); 
    str=sprintf('PC2_1   = %20g /',k.pc2_1); c=c+wpad(h,str); 
    str=sprintf('PC2_2   = %20g /',k.pc2_2); c=c+wpad(h,str); 
end
if (isfield(k,'bunit')),
    str=sprintf('BUNIT   = ''%s'' /',k.bunit); c=c+wpad(h,str);
end
if (isfield(k,'transit')),
    str=sprintf('TRANSIT = ''%s'' / Transition',k.transit); c=c+wpad(h,str);
end
if (isfield(k,'wavelen')),
    str=sprintf('WAVELEN = %f / Wavelength in Angstroms',k.wavelen); c=c+wpad(h,str);
end

if (isfield(k,'history')),
    for j=1:length(k.history),
        str=sprintf('HISTORY %-72s',k.history{j}); c=c+wpad(h,str);
    end
end    
if (~strcmp(options,'simple')),
  fna=fieldnames(k);
  avoid={'simple','bitpix','naxis','ctype','crpix','crval','cdelt','crota',...
    'cunit','bunit','cd1_1','cd1_2','cd2_1','cd2_2','pc1_1','pc1_2','pc2_1',...
    'pc2_2','x','numpt','extend','history','comment','data','wcs1','wcs2'};
  for i=1:length(fna),
    if isempty(strmatch(fna{i},avoid)),
        fv=getfield(k,fna{i});
        if (ischar(fv)),
            str=sprintf('%-8s= ''%s''',upper(fna{i}),fv);
        else
            str=sprintf('%-8s= %g',upper(fna{i}),fv);
        end
        c=c+wpad(h,str);
    end
  end
end
str=sprintf('END'); c=c+wpad(h,str);
str=' ';
while (rem(c,rlen)),
	c=c+wpad(h,str);
end

if (k.bitpix==32),
	prec='int32';
elseif (k.bitpix==16),
	prec='int16';
elseif (k.bitpix==-32),
	prec='float32';
elseif (k.bitpix==-64),
	prec='float64';
else
	prec='uint8';
end

ix=find(k.data==k.blank);
if (k.bitpix>0),
	v=round((k.data-k.bzero)/k.bscale);
else
	v=k.data;
end
v(ix)=k.blank*ones(size(ix));
ndata=fwrite(h,v,prec);
ndata=ndata*abs(k.bitpix/8);
npad=rlen-rem(ndata,rlen);
padstr=zeros(1,npad);
fwrite(h,padstr,'uchar');
fclose(h);

return

function cnt=wpad(h,str)

% Pad lines to be 80 chars long.
% Deal with lines that are longer and need to be split
% into several "CONTINUE" lines.

cnt=0;
if (~isempty(str)),
    if (length(str)<=80),
        str=[str,blanks(80)];
        str=str(1:80);
        fprintf(h,'%s',str);
        cnt=80;
    else
        done=0;
        ixs=1;
        ixe=78;
        fprintf(h,'%s',[str(ixs:ixe),'&''']);
        lstr=length(str);
        cnt=cnt+80;
        while (~done),
            ixs=ixe+1;
            if (lstr-ixe<69),
                u=[str(ixs:end),blanks(80)];
                fprintf(h,'CONTINUE= ''%s',u(1:69));
                done=1;
                cnt=cnt+80;
            else
                ixe=ixs+66;
                fprintf(h,'CONTINUE= ''%s&''',str(ixs:ixe));
                cnt=cnt+80;
            end
        end
    end     
end
return
