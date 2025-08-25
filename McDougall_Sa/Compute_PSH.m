addpath(genpath('/home/561/rmh561/software/matlab-utilities/GSW/'));
tmp_dir = '/g/data/e14/rmh561/McDougall_tmp/';
file_in = strcat(tmp_dir, '1deg_jra55v14_ryf_output099_SA_CT_p_global.nc');
file_outSA = strcat(tmp_dir, '1deg_jra55v14_ryf_output099_PISH_SA_global.nc');
file_outSstar = strcat(tmp_dir, '1deg_jra55v14_ryf_output099_PISH_Sstar_global.nc');

CT = ncread(file_in, 'CT');
SA = ncread(file_in, 'SA');
Sstar = ncread(file_in, 'Sstar');
p = ncread(file_in, 'p');

% Depths to evaluate:
pvec = [0. 500. 1000. 1500. 2000. 2500. 3000. 3500. 4000. 4500. 5000.];

% Reorder dimensions so that the last (depth) is first, and then combine the last two dimensions:
CTrs = permute(CT, [3, 1, 2]);
SArs = permute(SA, [3, 1, 2]);
Sstarrs = permute(Sstar, [3, 1, 2]);
prs = permute(p, [3, 1, 2]);
CTrs = reshape(CTrs, [size(CTrs, 1), size(CTrs, 2)*size(CTrs, 3)]);
SArs = reshape(SArs, [size(SArs, 1), size(SArs, 2)*size(SArs, 3)]);
Sstarrs = reshape(Sstarrs, [size(Sstarrs, 1), size(Sstarrs, 2)*size(Sstarrs, 3)]);
prs = reshape(prs, [size(prs, 1), size(prs, 2)*size(prs, 3)]);

PISH_SArs = zeros([size(pvec, 2), size(SArs, 2)]);
PISH_Sstarrs = zeros([size(pvec, 2), size(SArs, 2)]);
for i = 1:size(pvec, 2)
    i
    PISH_SArs(i,:) = gsw_geo_strf_PISH(SArs, CTrs, prs, pvec(i));
    PISH_Sstarrs(i,:) = gsw_geo_strf_PISH(Sstarrs, CTrs, prs, pvec(i));
end

% Reshape back to original dimensions:
PISH_SA = reshape(PISH_SArs, [size(pvec, 2), size(CT, 1), size(CT, 2)]);
PISH_Sstar = reshape(PISH_Sstarrs, [size(pvec, 2), size(CT, 1), size(CT, 2)]);

% Write out to netcdf:
nccreate(file_outSA, 'PISH_SA', 'Dimensions', {'st_ocean', size(PISH_SA, 1), 'xt_ocean', size(PISH_SA, 2), 'yt_ocean', size(PISH_SA, 3)});
nccreate(file_outSA, 'st_ocean', 'Dimensions', {'st_ocean', size(PISH_SA, 1)});
ncwrite(file_outSA, 'PISH_SA', PISH_SA);
ncwrite(file_outSA, 'st_ocean',pvec);

nccreate(file_outSstar, 'PISH_Sstar', 'Dimensions', {'st_ocean', size(PISH_Sstar, 1), 'xt_ocean', size(PISH_Sstar, 2), 'yt_ocean', size(PISH_Sstar, 3)});
nccreate(file_outSstar, 'st_ocean', 'Dimensions', {'st_ocean', size(PISH_SA, 1)});
ncwrite(file_outSstar, 'PISH_Sstar', PISH_Sstar);
ncwrite(file_outSstar, 'st_ocean',pvec);


