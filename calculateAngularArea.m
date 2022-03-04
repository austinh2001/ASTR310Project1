function [total_angular_area] = calculateAngularArea(focal_length,pixel_size,pixel_count)
    % Description: Calculates the total angular area associated with a set of pixels of a certain size for some focal length telescope.
    
    %----------------------------------------------------------------------

    % Input: 

    % focal_length: The focal length of the telescope used to take the
    % original image, im, in millimeters (mm)

    % pixel_scale: The pixel scale of the CCD used to take the
    % original image, im, in millimeters (mm)

    % pixel_count: The number of pixels which make up the desired area.

    %----------------------------------------------------------------------

    % Output:

    % total_angular_area: A scalar which represents the total angular area
    % for the given parameters, measured in arc minutes^2.

    %----------------------------------------------------------------------

    % Errors:

    % The input provided for focal_length is not a valid scalar: The value of focal_length is
    % not a scalar.

    % The input provided for pixel_size is not a valid scalar: The value of pixel_size is
    % not a scalar.

    % The input provided for pixel_count is not a valid scalar: The value of pixel_count is
    % not a scalar.
    
    %----------------------------------------------------------------------
    
    % Checking whether the input value of focal_length is a valid scalar
    if(~isscalar(focal_length) || isa(focal_length,"string"))
        try
            display(focal_length)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for focal_length is not a valid scalar.")
    end
    
    % Checking whether the input value of pixel_size is a valid scalar
    if(~isscalar(pixel_size) || isa(pixel_size,"string"))
        try
            display(pixel_size)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for pixel_size is not a valid scalar.")
    end

     % Checking whether the input value of pixel_count is a valid scalar
    if(~isscalar(pixel_count) || isa(pixel_count,"string"))
        try
            display(pixel_count)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for pixel_count is not a valid scalar.")
    end

    % Calculate the total area associated with the pixels

    % arc second/pixel size
    resolution = 206.265*(pixel_size/focal_length);

    % arc second^2/pixel
    pixel_angular_area = resolution^2;
    
    % arc seconds^2
    total_pixel_area = pixel_angular_area * pixel_count;
    
    % arc minutes^2
    total_angular_area = total_pixel_area/(60^2);
end

