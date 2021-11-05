function [normalized_master_flat] = normalizeMasterFlat(master_flat)
    maximum_value = max(max(master_flat));
    normalized_master_flat = master_flat/maximum_value;
end