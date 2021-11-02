function [src_threshold] = findFluxOfTargetStar(target_aperture_radius,sky_annulus_inner_radius,sky_annulus_outer_radius)
m29_2 = rfits("m29-2.fit");
bright_star_coordinates = [1180,681];
dim_star_coordinates = [1251,650];
kccd = 0.74074072765;
src_threshold = threshE(m29_2.data,bright_star_coordinates(2),bright_star_coordinates(1),target_aperture_radius,target_aperture_radius,sky_annulus_inner_radius,sky_annulus_inner_radius,sky_annulus_outer_radius,sky_annulus_outer_radius,kccd);
%threshE(m29_2.data,dim_star_coordinates(2),dim_star_coordinates(1),target_aperture_radius,target_aperture_radius,sky_annulus_inner_radius,sky_annulus_inner_radius,sky_annulus_outer_radius,sky_annulus_outer_radius,kccd);
end

