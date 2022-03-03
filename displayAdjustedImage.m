function [] = displayAdjustedImage(image_data,z,rotate)
    % Description: Displays image data with some z-score adjustment with the ability to rotate it into the default orientation. 

    %----------------------------------------------------------------------

    % Input: 

    % image_data: An n x m array where n is the pixel length in the 'x' 
    % (horizontal) direction and m is the pixel length in the 'y' (vertical)
    % direction.

    % rotate (optional): A boolean which controls whether the resulting
    % image displayed is rotated into the default orientation (such that n
    % is horizontal and m is vertical). This has a default value of true.
    
    %----------------------------------------------------------------------

    % Output: None

    %----------------------------------------------------------------------

    % Errors:

    % The input provided for image_data is not a matrix: The value of
    % image_data which was provided is not an array.

    % The input provided for image_data is not a validly sized matrix: The
    % value of image_data which was provided is not a validly sized array.
    % A valid array has dimensions of n x m.

    % The input provided for rotate is not a boolean: The value of rotate
    % which was provided is not a boolean or boolean-like value.

    %----------------------------------------------------------------------

    % Warnings: 

    % Provided z-score was negative, was this intentional? Z-score has been 
    % made positive to compensate: Providing a value of z (z-score) which 
    % is negative is allowed as it will be converted to a positive value, 
    % but a warning will show as this function does not intend to use 
    % negative z-scores.

    %----------------------------------------------------------------------
    
    % Setting default values of z to 1 and rotate to true
    if (nargin==1), z=1; end
    if (nargin<=2), rotate=true; end

    % Checking  whether the input value of image_data is an array and
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
    
     % Checking whether the input value of image_data is a string, which
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
    if(~ismatrix(image_data))
        try
            display(image_data)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for image_data is not a validly sized matrix: " + mat2str(size(image_data)))
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

    % Checking whether the input value of rotate is a valid boolean and
    % raising an error if it is not.
    if(~isa(rotate,"logical"))
        try
            display(image_data)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for rotate is not a boolean.")
    end
    
    % Checking if the z-score is negative. If it is, send the user a
    % warning and convert it to a positive value
    if(z < 0)
        warning("Provided z-score was negative, was this intentional? Z-score has been made positive to compensate.")
        z = abs(z);
    end

    data_mean = mean(image_data(:));
    data_std = std(image_data(:));
    data_min = min(image_data(:));
    data_max = max(image_data(:));
    cmin = max(data_min, data_mean - z * data_std);
    cmax = min(data_max, data_mean + z * data_std);
    if(z~=0)
        if(rotate)
            imagesc(flipud(imrotate(image_data,90)),[cmin, cmax])
            axis image
            set(gca,'YDir','normal') 
        else
            imagesc(image_data,[cmin, cmax])
            axis image
        end
    else
        error("Z-score provided was 0, which is not a valid value.")
    end
end

