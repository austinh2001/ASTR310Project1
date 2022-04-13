function [colorization_table] = createColorizationTable(filters,ADU_ranges,colors)
    colorization_table = table(filters',ADU_ranges',colors');
end

