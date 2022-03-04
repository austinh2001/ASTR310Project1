function [threshold_image, threshold_ADU] = threshImage(im,noise_region,z)
    % Description: Generates a threshold image for an entire image.
    
    %----------------------------------------------------------------------

    % Input: 
    
    % im: An n x m array where n is the pixel length in the 'x' 
    % (horizontal) direction and m is the pixel length in the 'y' (vertical)
    % direction.

    % noise_region: A 2 x 2 array consisting of two [x,y] pixel
    % coordinates, which uniquely define a rectangle.
    % Example: region = [[x1,y1] ; [x2,y2]]

    % z: The z-score/number of standard deviations away from the mean you
    % are trying to define an upper threshold for.

    %----------------------------------------------------------------------

    % Output:

    % threshold_image: An image array (matrix/2D array) containing all values
    % greater than some calculated upper threshold, and 0 otherwise.

    % threshold_ADU: The calculated cutoff ADU for the threshold image. All
    % values below this threshold will appear as 0 in the threshold image
    % as long as they are within the ellipse.

    %----------------------------------------------------------------------

    % Errors:

    % The input provided for im is not a matrix: The value of
    % im which was provided is not an array.

    % The input provided for noise_region is not a matrix: The value of
    % noise region is not a matrix.

    % The input provided for noise_region is not a valid set of points: The
    % size of the noise region points array is incorrect.

    % The input provided for z is not a valid scalar: The value of z is
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

    % Loop through the original image and check if the value in im is
    % greater than or equal to the threshold_ADU
    threshold_ADU = calculateThreshold(im,noise_region,z);
    threshold_image = zeros(size(im));
    image_size = size(threshold_image);
    
    for i=1:image_size(1)
        for j=1:image_size(2)
            if(im(i,j) >= threshold_ADU)
                threshold_image(i,j) = im(i,j);
            end
        end
    end

end

