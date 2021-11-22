function [] = createColorbar(colorObject,title)
    if (nargin==1), title=""; end
    c_map = colorObject{1};
    limits = colorObject{2};
    colormap(c_map);
    c_bar = colorbar;
    c_bar.TickLabels = round(linspace(limits(1),limits(2),11));
    c_bar.Location = 'southoutside';
    c_bar.Label.String = title;
end
