function [normalized_master_flat] = normalizeMasterFlat(master_flat)
    master_flat_vector = master_flat(:);
    %maximum_value = max(master_flat_vector);
    median_value = median(master_flat_vector);
    normalized_master_flat = master_flat/median_value;

    %displayAdjustedImage(normalized_master_flat)
    %title("Normalized Master Flat")
    %figure
end