function [] = createUserEllipse()
    display("Select the center:")
    mousePos = ginput(1);
    center_coordinates = [mousePos(1),mousePos(2)];

    display("Select the major-axis edge:")
    mousePos = ginput(1);
    major_radius_edge_point = [mousePos(1),mousePos(2)];
    major_axis_vector =  [major_radius_edge_point(1)-center_coordinates(1),major_radius_edge_point(2)-center_coordinates(2)];
    major_radius = sqrt((center_coordinates(1)-major_radius_edge_point(1))^2+(center_coordinates(2)-major_radius_edge_point(2))^2);

    display("Select the minor-axis edge:")
    mousePos = ginput(1);
    minor_radius_edge_point = [mousePos(1),mousePos(2)];
    minor_axis_vector =  [minor_radius_edge_point(1)-center_coordinates(1),minor_radius_edge_point(2)-center_coordinates(2)];
    minor_radius = sqrt((center_coordinates(1)-minor_radius_edge_point(1))^2+(center_coordinates(2)-minor_radius_edge_point(2))^2);

    n = 1000;
    % Beta is the angle between the horizontal axis and the major axis vector
    beta = subspace(major_axis_vector',[-1,0]');
    theta = linspace(0,2*pi,n);
    x = zeros(n,1);
    y = zeros(n,1);
    for t=1:n
        x(t,1) =  major_radius*cos(theta(t));
        y(t,1) =  minor_radius*sin(theta(t));
    end
    angle = beta;
    alpha = angle;
    R  = [cos(alpha) -sin(alpha); sin(alpha)  cos(alpha)];
    rotatedXY = R*[x'; y'];
    xr = rotatedXY(1,:)';
    yr = rotatedXY(2,:)';
    hold on
    plot(xr+center_coordinates(1),yr+center_coordinates(2),'r');
    hold off
end

