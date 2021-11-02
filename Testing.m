%m27_Ha = rfits("M27-001-ha.fit");
m29_2 = rfits("m29-2.fit");
egain = m29_2.egain;
m29_2_center_coordinates = [1181 681];
target_aperture_radius = 5;
sky_annulus_inner_radius = 10;
sky_annulus_outer_radius = 15;
src_threshold = threshE(m29_2.data,m29_2_center_coordinates(2),m29_2_center_coordinates(1),target_aperture_radius,target_aperture_radius,sky_annulus_inner_radius,sky_annulus_inner_radius,sky_annulus_outer_radius,sky_annulus_outer_radius,1/egain);
[non_zero_subscript_row, non_zero_subscript_column] = ind2sub(size(src_threshold),find(src_threshold))

image_data = zeros(size(m29_2.data))

valid_point_data = find(src_threshold)
s = size(non_zero_subscript_column)
for i=1:s
    for j=1:s
        image_data(non_zero_subscript_row(i),non_zero_subscript_row(j)) = valid_point_data()
    end
end

imagesc(image_data)