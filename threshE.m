function [threshold_image,threshold_image_values,threshold_ADU] = threshE(im,col,row,rad1,rad2,degrees_angle,bounding_array,z)
    % Description: Generates a threshold image within an elliptical region of an image.
    
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

    % bounding_array: A 2 x 2 array consisting of two [x,y] pixel
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

    % total_angular_area: The calculated angular area associated with the
    % values within the ellipse and are greater than the calculated 
    % threshold value.

    % flx: The calculated total flux of the values remaining in the
    % threshold image.

    % flx_err: The calculated error associated with the flux.
    
    % threshold_ADU: The calculated cutoff ADU for the threshold image. All
    % values below this threshold will appear as 0 in the threshold image
    % as long as they are within the ellipse.

    %----------------------------------------------------------------------

    % Errors:

    % The input provided for im is not a matrix: The value of
    % im which was provided is not an array.

    % The input provided for col is not a valid scalar: The value of col is
    % not a scalar.

    % The input provided for row is not a valid scalar: The value of row is
    % not a scalar.

    % The input provided for rad1 is not a valid scalar: The value of rad1 is
    % not a scalar.

    % The input provided for rad2 is not a valid scalar: The value of rad2 is
    % not a scalar.

    % The input provided for degrees_angle is not a valid scalar: The value 
    % of degrees_angle is not a scalar.

    % The input provided for bounding_array is not a matrix: The value of
    % noise region is not a matrix.

    % The input provided for bounding_array is not a valid set of points: The
    % size of the noise region points array is incorrect.

    % The input provided for z is not a valid scalar: The value of z is
    % not a scalar.

    % The input provided for kccd is not a valid scalar: The value of kccd is
    % not a scalar.

    % The input provided for focal_length is not a valid scalar: The value of focal_length is
    % not a scalar.

    % The input provided for pixel_size is not a valid scalar: The value of pixel_size is
    % not a scalar.
    
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
    
    % Checking whether the input value of bounding_array is a 2 x 2 array and
    % raising an error if it is not
    if(~ismatrix(bounding_array))
        try
            display(bounding_array)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for bounding_array is not a matrix.")
    else
        s = size(bounding_array);
        if(s(1) ~= 2 || s(2) ~= 2)
            try
                display(bounding_array)
            catch cannot_display
                display("Cannot display error-inducing parameter.")
            end
            error("The input provided for bounding_array is not a valid set of points.")
        end
    end
    
    % Find the threshold value, as determined by the sky noise region
    sky_noise_region = generateSkyNoiseRegion(im,bounding_array);
    threshold_ADU = calculateThreshold(sky_noise_region,z)

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
    figure
    threshold_image_values = [];
    % Loop through the original image and check if the value in im is both
    % greater than or equal to the threshold_ADU and is within the rotated ellipse
    pixel_count = 0;
    for i=1:a
        for j=1:b
            if(im(i,j) >= threshold_ADU && ixsrc(i,j))
                pixel_count = pixel_count + 1;
                threshold_image_values = [threshold_image_values im(i,j)];
                threshold_image(i,j) = im(i,j);
            end
        end
    end   
end

