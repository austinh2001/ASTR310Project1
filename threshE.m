function [threshold_image,threshold_image_values,threshold_ADU, noise_region] = threshE(im,center_coodinates,rad1,rad2,degrees_angle,z,noise_region,method)
    % Description: Generates a threshold image within an elliptical region of an image.
    
    %----------------------------------------------------------------------

    % Input: 
    
    % im: An n x m array where n is the pixel length in the 'x' 
    % (horizontal) direction and m is the pixel length in the 'y' (vertical)
    % direction.
    
    % center_coodinates: A 2 x 1 array containing the horizontal pixel index and the vertical pixel index of the center of the ellipse of the
    % target aperture

    % rad1: The pixel length of the major axis of the target aperature

    % rad2: The pixel length of the minor axis of the target aperature

    % degrees_angle: The angle (in degrees), measured counter-clockwise, from the 
    % horizontal direction to rotate the ellipse of the target aperture

    % z: The z-score/number of standard deviations away from the mean you
    % are trying to define an upper threshold for.

    % noise_region: A boolean 2 x 2 array which has the same size as im (n x m)
    % consisting of a 1 if a given pixel is in the region and a 0 if it is
    % not

    % method: A string which determines by which method (mean or median)
    % the threshold ADU value should be determined from the sky noise

    %----------------------------------------------------------------------

    % Output:

    % threshold_image: An image array (matrix/2D array) containing all values
    % greater than some calculated upper threshold, and 0 otherwise.

    % threshold_image_values: 1 x (number of remaining values out of n*m
    % original image values) array containing the desired values which
    % remain in the threshold image
    
    % threshold_ADU: The calculated cutoff ADU for the threshold image. All
    % values below this threshold will appear as 0 in the threshold image
    % as long as they are within the ellipse.

    % noise_region: A boolean 2 x 2 array which has the same size as im (n x m)
    % consisting of a 1 if a given pixel is in the region and a 0 if it is
    % not

    %----------------------------------------------------------------------

    % Errors:

    % The input provided for im is not a matrix: The value of
    % im which was provided is not an array.

    % The input provided for center_coodinates is not a valid coordinate array: The value of center_coodinates is
    % not a matrix.

    % The input provided for rad1 is not a valid scalar: The value of rad1 is
    % not a scalar.

    % The input provided for rad2 is not a valid scalar: The value of rad2 is
    % not a scalar.

    % The input provided for degrees_angle is not a valid scalar: The value 
    % of degrees_angle is not a scalar.

    % The input provided for z is not a valid scalar: The value of z is
    % not a scalar.

    % The input provided for method is not a valid scalar: The value of method is
    % not a string.
    
    %----------------------------------------------------------------------

    %Credit: AperE Original code by Professor Andrew Harris. Edited by Alyssa Pagan
    
    % ThreshE adaptations from AperE by Team CANS

    %----------------------------------------------------------------------

    % Setting default value of method, if not provided
    if (nargin<=7), method="mean"; end

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

    % Checking whether the input value of center_coodinates is a valid coordinate array and
    % raising an error if it is not
    if(~ismatrix(center_coodinates))
        try
            display(center_coodinates)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for center_coodinates is not a valid scalar.")
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

    % Checking whether the input value of z is a valid scalar and
    % raising an error if it is not
    if(~isscalar(z) || isa(z,"string"))
        try
            display(z)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for z is not a valid scalar.")
    end

    % Checking whether the input value of method is a valid string and
    % raising an error if it is not
    if(~isa(method,"string"))
        try
            display(method)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for method is not a valid string.")
    end
    
    % Generate an empty template array the same size as the original image
    threshold_image = zeros(size(im));

    threshold_image_values = [];

    % Generate the elliptical region of the source
    ixsrc = generateEllipticalRegion(im,center_coodinates,rad1,rad2,degrees_angle);
    
    % Find the threshold value, as determined by the sky noise region
    % If no noise region is provided, it will default to everything which
    % is not the source being the noise region
    if (nargin==6), noise_region=~ixsrc; end
    sky_noise_values = getRegionValues(im,noise_region);
    threshold_ADU = calculateThreshold(sky_noise_values,z,method)

    % Loop through the original image and check if the value in im is both
    % greater than or equal to the threshold_ADU and is within the rotated ellipse
    pixel_count = 0;
    s = size(im);
    for x=1:s(1)
        for y=1:s(2)
            if(im(x,y) >= threshold_ADU && ixsrc(x,y))
                pixel_count = pixel_count + 1;
                threshold_image_values = [threshold_image_values im(x,y)];
                threshold_image(x,y) = im(x,y);
            end
        end
    end   
end

