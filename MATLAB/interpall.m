%% interpall.m
% This will perform all of the interpolations of the data from spherical
% radar coordinates to Cartisian coordinates.
%% Original Fit
S_in = load('patchex.mat');
kvec = 1:100;
S_in.Param_List=S_in.Param_List(:,kvec,:);
S_in.Time_Vector=S_in.Time_Vector(kvec);

S_out = load('patchexNE.mat');
S_out.Param_List=S_out.Param_List(:,kvec,:);
S_out.Time_Vector=S_out.Time_Vector(kvec);

S_out2 = load('patchexNE2.mat');
S_out2.Param_List=S_out2.Param_List(:,kvec,:);
S_out2.Time_Vector=S_out2.Time_Vector(kvec);

S_out.Param_List = log10(S_out.Param_List);
S_outorig = ionocontinterp(S_out,{S_in.x,S_in.y,S_in.z});

S_out2.Param_List = log10(S_out2.Param_List);
S_outorig2 = ionocontinterp(S_out2,{S_in.x,S_in.y,S_in.z});

save('origdata.mat','S_outorig')
save('origdata2.mat','S_outorig2')

clear all
%% Stationary Data
S_in = load('patchexstation.mat');
kvec = 1:100;
S_in.Param_List=S_in.Param_List(:,kvec,:);
S_in.Time_Vector=S_in.Time_Vector(kvec);

S_out = load('patchexNEstation.mat');
S_out.Param_List=S_out.Param_List(:,kvec,:);
S_out.Time_Vector=S_out.Time_Vector(kvec);

S_out2 = load('patchexNE2stations.mat');
S_out2.Param_List=S_out2.Param_List(:,kvec,:);
S_out2.Time_Vector=S_out2.Time_Vector(kvec);

S_out.Param_List = log10(S_out.Param_List);
S_outorig = ionocontinterp(S_out,{S_in.x,S_in.y,S_in.z});

S_out2.Param_List = log10(S_out2.Param_List);
S_outorig2 = ionocontinterp(S_out2,{S_in.x,S_in.y,S_in.z});

save('origdatastation.mat','S_outorig')
save('origdatastation2.mat','S_outorig2')

clear all
%% With Tempreture difference
S_in = load('patchewtemp.mat');
kvec = 1:100;
S_in.Param_List=S_in.Param_List(:,kvec,:);
S_in.Time_Vector=S_in.Time_Vector(kvec);
S_out = load('patchwtempfit.mat');
S_out.Param_List=S_out.Param_List(:,kvec,:);
S_out.Time_Vector=S_out.Time_Vector(kvec);

S_out.Param_List(:,:,3) = log10(S_out.Param_List(:,:,3));
S_outorig = ionocontinterp(S_out,{S_in.x,S_in.y,S_in.z});
save('origdatatemp.mat','S_outorig')
