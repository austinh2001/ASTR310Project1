function [] = createColorbar(colorObject,title,ticks)
    if (nargin==1), title=""; end
    if (nargin==2), ticks=6; end
    c_map = colorObject{1};
    limits = colorObject{2};
    colormap(c_map);
    c_bar = colorbar;
    c_bar.LimitsMode = 'manual';
    c_bar.Limits = [0,1];
    c_bar.Ticks = linspace(0,1,ticks);
    c_bar.TickLabels = round(linspace(limits(1),limits(2),ticks));
    c_bar.Location = 'southoutside';
    c_bar.Label.String = title;
end

