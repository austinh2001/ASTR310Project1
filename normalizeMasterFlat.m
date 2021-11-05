function [normalized_master_flat] = normalizeMasterFlat(master_flat)
    master_flat_vector = master_flat(:)
    maximum_value = mean(master_flat_vector)
    %maximum_value = max(max(master_flat));
    normalized_master_flat = master_flat/maximum_value;
end