function [] = writeCompositeFITS(image_data, component_image_fits_header_structs, filename)
    relevant_header_data = ["BITPIX","NAXIS","NAXIS1","NAXIS2","BSCALE","BZERO","TELESCOP","FOCALLEN","INSTRUME","EXPTIME","XPIXSZ","YPIXSZ","EGAIN"];
    composite_fits_header_struct = struct();
    composite_fits_header_struct = setfield(composite_fits_header_struct,"data",image_data);
    composite_fits_header_struct = setfield(composite_fits_header_struct,"numpt",size(image_data));
    composite_fits_header_struct = setfield(composite_fits_header_struct,"imagetyp",'Composite');
    composite_fits_header_struct = setfield(composite_fits_header_struct,"exptime",0);
    for i=1:length(component_image_fits_header_structs)
        for j=1:length(relevant_header_data)
            if(isfield(component_image_fits_header_structs{i},lower(relevant_header_data(j))))
                header_value = getfield(component_image_fits_header_structs{i},lower(relevant_header_data(j)));
                if(relevant_header_data(j) == "EXPTIME")
                    composite_fits_header_struct = setfield(composite_fits_header_struct,lower(relevant_header_data(j)),header_value + getfield(composite_fits_header_struct,lower(relevant_header_data(j))));
                else
                    composite_fits_header_struct = setfield(composite_fits_header_struct,lower(relevant_header_data(j)),header_value);
                end
            end
        end
    end
    
    wfits(composite_fits_header_struct,filename);
end