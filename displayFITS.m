function [] = displayFITS(fits_image)
    % Description: Displays FITS image data directly with the ability to rotate it into the default orientation. 

    %----------------------------------------------------------------------

    % Input: 

    % image_data: A FITS image struct from the rfits.m function

    % rotate (optional): A boolean which controls whether the resulting
    % image displayed is rotated into the default orientation (such that n
    % is horizontal and m is vertical). This has a default value of true.
    
    %----------------------------------------------------------------------

    % Output: None

    %----------------------------------------------------------------------

    % Errors:

    % The input provided for fits_image is not a struct: The value of
    % fits_image which was provided is not a struct.
    
    %----------------------------------------------------------------------
    
    % Checking  whether the input value of fits_image is a struct and
    % raising an error if it is not
    if(~isstruct(fits_image))
        try
            display(fits_image)
        catch cannot_display
            display("Cannot display error-inducing parameter.")
        end
        error("The input provided for fits_image is not a struct.")
    end
    
    % Display the image data in the FITS struct
    displayImage(fits_image.data)
end

