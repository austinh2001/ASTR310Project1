function [] = writeCalibratedFITS(image_data, component_image_fits_header_struct, filename)
    if(~isstruct(component_image_fits_header_struct))
        error("Not a struct.")
    end
    relevant_header_data = ["BITPIX","NAXIS","NAXIS1","NAXIS2","BSCALE","BZERO","DATE_OBS","TELESCOP","FOCALLEN","INSTRUME","EXPTIME","FILTER","XPIXSZ","YPIXSZ","EGAIN"];
    current_fits_header_struct = struct();
    current_fits_header_struct = setfield(current_fits_header_struct,"data",image_data);
    current_fits_header_struct = setfield(current_fits_header_struct,"numpt",size(image_data));
    current_fits_header_struct = setfield(current_fits_header_struct,"imagetyp",'Calibrated');
    for j=1:length(relevant_header_data)
        if(isfield(component_image_fits_header_struct,lower(relevant_header_data(j))))
            header_value = getfield(component_image_fits_header_struct,lower(relevant_header_data(j)));
            current_fits_header_struct = setfield(current_fits_header_struct,lower(relevant_header_data(j)),header_value);
        end
    end
    wfits(current_fits_header_struct,filename);
end