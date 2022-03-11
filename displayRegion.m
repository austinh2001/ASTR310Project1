function [] = displayRegion(region,transparency,color)
    if (nargin==1), transparency=0.5; end
    if (nargin<=2), color=[1,0,0]; end
    region = flipud(rot90(region));
    hold on
    rgb_region = cat(3, region*color(1), region*color(2), region*color(3));
    alpha = transparency;
    image(rgb_region,'AlphaData',region*alpha)
    hold off
end

