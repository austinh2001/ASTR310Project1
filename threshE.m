function [threshold_image, pixel_angular_area,flx,flx_err,threshold_ADU] = threshE(im,col,row,rad1,rad2,degrees_angle,noise_region,z,kccd,focal_length,pixel_size)
    % Description: Generates a threshold image as well as providing some numerical results relating to the threshold image. 
    % based on a center
    % of some ellipse which defines the bounds of some object, the major
    % and minor radii of an inner sky annulus, the major and minor radii of
    % an outer sky annulus, a region from which to extract noise data, some
    % z-score which will define the bounds of the threshold image, and the
    % CCD gain represented as ADU/electron (which is 1/egain).

    %----------------------------------------------------------------------

    % Input: 
    
    % im: An n x m array where n is the pixel length in the 'x' 
    % (horizontal) direction and m is the pixel length in the 'y' (vertical)
    % direction.
    
    % col: The horizontal pixel index of the center of the ellipse of the
    % target aperture

    % row: The vertical pixel index of the center of the ellipse of the
    % target aperture

    % rad1: The pixel length of the major axis of the target aperature

    % rad2: The pixel length of the minor axis of the target aperature

    % degrees_angle: The angle (in degrees), measured counter-clockwise, from the 
    % horizontal direction to rotate the ellipse of the target aperture

    % noise_region: A 2 x 2 array consisting of two [x,y] pixel
    % coordinates, which uniquely define a rectangle.
    % Example: region = [[x1,y1] ; [x2,y2]]

    % z: The z-score/number of standard deviations away from the mean you
    % are trying to define an upper threshold for.
    
    % kccd: Represents the number of ADU per electron associated with the
    % CCD, this is equivalent to 1/egain.

    % focal_length: The focal length of the telescope used to take the
    % original image, im, in millimeters (mm)

    % pixel_scale: The pixel scale of the CCD used to take the
    % original image, im, in millimeters (mm)

    %----------------------------------------------------------------------

    % Output:

    % threshold_image: An image array (matrix/2D array) containing all values
    % greater than some calculated upper threshold, and 0 otherwise.

    %----------------------------------------------------------------------

    % Errors:
    
    %----------------------------------------------------------------------

    %Credit: AperE Original code by Professor Andrew Harris. Edited by Alyssa Pagan
    
    % ThreshE adaptations from AperE by Team CANS

    %----------------------------------------------------------------------
    
    % Checking whether the input value of im is a matrix (2D array) and
    % raising an error if it is not
    if(~ismatrix(im))
        try
            display(im)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for im is not a matrix.")
    end

    % Checking whether the input value of col is a valid scalar and
    % raising an error if it is not
    if(~isscalar(col) || isa(col,"string"))
        try
            display(col)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for col is not a valid scalar.")
    end

    % Checking whether the input value of row is a valid scalar and
    % raising an error if it is not
    if(~isscalar(row) || isa(row,"string"))
        try
            display(row)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for row is not a valid scalar.")
    end

    % Checking whether the input value of rad1 is a valid scalar and
    % raising an error if it is not
    if(~isscalar(rad1) || isa(rad1,"string"))
        try
            display(rad1)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for rad1 is not a valid scalar.")
    end

    % Checking whether the input value of rad2 is a valid scalar and
    % raising an error if it is not
    if(~isscalar(rad2) || isa(rad2,"string"))
        try
            display(rad2)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for rad2 is not a valid scalar.")
    end

    % Checking whether the input value of degrees_angle is a valid scalar and
    % raising an error if it is not
    if(~isscalar(degrees_angle) || isa(degrees_angle,"string"))
        try
            display(degrees_angle)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for degrees_angle is not a valid scalar.")
    end
    
    % Checking whether the input value of noise_region is a 2 x 2 array and
    % raising an error if it is not
    if(~ismatrix(noise_region))
        try
            display(noise_region)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for noise_region is not a matrix.")
    else
        s = size(noise_region);
        if(s(1) ~= 2 || s(2) ~= 2)
            try
                display(noise_region)
            catch cannot_display
                display("Cannot display error-inducing parameter.")
            end
            error("The input provided for noise_region is not a valid set of points.")
        end
    end
    
    % Checking whether the input value of z is a valid scalar
    if(~isscalar(z) || isa(z,"string"))
        try
            display(z)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for z is not a valid scalar.")
    end

    % Checking whether the input value of kccd is a valid scalar
    if(~isscalar(kccd) || isa(kccd,"string"))
        try
            display(kccd)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for kccd is not a valid scalar.")
    end

    % Checking whether the input value of focal_length is a valid scalar
    if(~isscalar(focal_length) || isa(focal_length,"string"))
        try
            display(focal_length)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for focal_length is not a valid scalar.")
    end


    
    % Find the threshold value, as determined by the noise region
    [threshold_ADU,skyNoiseMu,skyNoiseRegion] = calculateThreshold(im,noise_region,z);

    % Generate an empty template array the same size as the original image
    threshold_image = zeros(size(im));
    
    % Generate a meshgrid
    [a,b]=size(im);
    [xx,yy]=meshgrid(1:b,1:a);
    
    % Create a 2D array of boolean values the same size as the original image
    % to determine whether a given point in im is within the calculated 
    % rotated ellipse
    alpha = degrees_angle * (pi/180);
    ixsrc=(((cos(alpha).*(xx-col)+sin(alpha).*(yy-row))./rad1).^2+(((sin(alpha).*(xx-col)-cos(alpha).*(yy-row))./rad2).^2))<=1;
    
    % Loop through the original image and check if the value in im is both
    % greater than or equal to the threshold_ADU and is within the rotated ellipse
    pixel_count = 0;
    for i=1:a
        for j=1:b
            if(im(i,j) >= threshold_ADU && ixsrc(i,j))
                pixel_count = pixel_count + 1;
                threshold_image(i,j) = im(i,j);
            end
        end
    end
    
    % Calculate the total_angular_area of the threshold image

    % arc second/pixel side
    resolution = 206.265*(pixel_size/focal_length);

    % arc second^2/pixel
    pixel_angular_area = resolution^2;
    
    % arc second^2
    total_pixel_area = pixel_angular_area * pixel_count;
    
    % arc minute^2
    total_pixel_area = total_pixel_area/ (60^2);
    
    % Calculate the associated flux and error in the flux associated with
    % the threshold image

    sky=skyNoiseMu;                 % sky value
    pix=im(ixsrc)-sky;              % source without sky
    sig=sqrt(im(ixsrc)/kccd);       % photon noise per pixel
    ssig=std(skyNoiseRegion(:))/sqrt(length(skyNoiseRegion(:)))/kccd; % sky noise in average
    flx=sum(pix)/kccd;                            % flux
    flx_err=sqrt(sum(sig).^2+ssig^2);             % total error

end

