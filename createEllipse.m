function [] = createEllipse(col,row,rad1,rad2,degrees_angle)

    if (nargin==4), degrees_angle=0; end

    center_coordinates = [col,row];

    major_radius = rad1;

    minor_radius = rad2;

    n = 1000;
    theta = linspace(0,2*pi,n);
    x = zeros(n,1);
    y = zeros(n,1);
    for t=1:n
        x(t,1) =  major_radius*cos(theta(t));
        y(t,1) =  minor_radius*sin(theta(t));
    end

    alpha = degrees_angle * (pi/180);
    R  = [cos(alpha) -sin(alpha); sin(alpha)  cos(alpha)];
    rotatedXY = R*[x'; y'];
    xr = rotatedXY(1,:)';
    yr = rotatedXY(2,:)';
    colorArray = ['r','g','b']
    randomIndex = randi(length(colorArray), 1)
    hold on
    plot(xr+center_coordinates(1),yr+center_coordinates(2),colorArray(randomIndex));
    hold off
end

