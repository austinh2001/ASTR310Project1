function [] = displayImage(image_data)
    % Description: Displays image data directly with the ability to rotate it into the default orientation. 

    %----------------------------------------------------------------------

    % Input: 

    % image_data: An n x m array where n is the pixel length in the 'x' 
    % (horizontal) direction and m is the pixel length in the 'y' (vertical)
    % direction. This image data can also be an RGB image, such that it has
    % an array shape of n x m x 3.
    
    %----------------------------------------------------------------------

    % Output: None

    %----------------------------------------------------------------------

    % Errors:

    % The input provided for image_data is not a matrix: The value of
    % image_data which was provided is not an array.

    % The input provided for image_data is not a validly sized matrix: The
    % value of image_data which was provided is not a validly sized array.
    % A valid array has dimensions of n x m or n x m x 3.

    %----------------------------------------------------------------------
    
    % Setting default value of rotate to true
    if (nargin==1), rotate=true; end

    % Checking whether the input value of image_data is an array and
    % raising an error if it is not
    try
        ndims(image_data);
    catch not_a_valid_input
        try
            display(image_data)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for image_data is not a matrix.")
    end
    
     % Checking  whether the input value of image_data is a string, which
     % is technically an array and raising an error if it is
    if(isa(image_data,"string"))
        try
            display(image_data)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for image_data is not a matrix.")
    end
    
    % Checking whether the input value of image_data is a validly sized
    % array, of either two or three dimensions and raising an error if it
    % is not
    if(~ismatrix(image_data) && ndims(image_data) ~= 3)
        try
            display(image_data)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for image_data is not a validly sized matrix: " + mat2str(size(image_data)))
    end

    % Display rotated image_data
    imagesc(flipud(rot90(image_data)))
    axis image
    set(gca,'YDir','normal') 
end

