function [] = displayAdjustedFITS(fits_image,z,rotate)
    % Description: Displays FITS image data with some z-score adjustment with the ability to rotate it into the default orientation. 

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
    
    % Setting default values of z to 1 and rotate to true
    if (nargin==1), z=1; end
    if (nargin<=2), rotate=true; end
    
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

    % Display the adjusted image data in the FITS struct
    displayAdjustedImage(fits_image.data,z,rotate)
end

