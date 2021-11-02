m27_Ha = rfits("M27-001-ha.fit");
%m29_2 = rfits("m29-2.fit");
%egain = m29_2.egain;
m29_2_center_coordinates = [1181 681];
target_aperture_radius = 5;
sky_annulus_inner_radius = 10;
sky_annulus_outer_radius = 15;
%src_pix_threshold = threshE(m29_2.data,m29_2_center_coordinates(2),m29_2_center_coordinates(1),target_aperture_radius,target_aperture_radius,sky_annulus_inner_radius,sky_annulus_inner_radius,sky_annulus_outer_radius,sky_annulus_outer_radius,1/egain);


data = m27_Ha.data;
displayAdjustedFITS(m27_Ha)
%[non_zero_subscript_row, non_zero_subscript_column, image_data_points] = ind2sub(size(adjustedData),find(adjustedData));
%image_data = zeros(size(data));
%s = size(non_zero_subscript_column);
%for i=1:s
%    image_data(non_zero_subscript_row(i),non_zero_subscript_column(i)) = image_data_points(i);
%end
%[z,a,b,alpha] = fitellipse([non_zero_subscript_row,non_zero_subscript_column]);
%hold on
%plotellipse(z,a,b,alpha)