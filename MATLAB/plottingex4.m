%% Plottingex4
% This script will make plots for figures 14 and 15. The plots will consist of 
% one data set for each of the figures at one time and each sub figure will be a parameter. 
% The files origdatatemp.mat and patchewtemp.mat are required to run this
% code.
%% load in data
load('origdatatemp.mat','S_outorig')
S_in = load('patchewtemp.mat');

destimes = [30, 45, 60];
ntim =  length(destimes);
num_params = 3;% size(S_outorig.Param_List,3);
% determine nans
% make mask for locations
nan_mask = isnan(S_outorig.Param_List);
for idim = 1:ndims(nan_mask)-1
    nan_mask = all(nan_mask,ndims(nan_mask));
end
%% Fix the parameters
S_in.Param_List(:,:,2) = prod(S_in.Param_List(:,:,1:2),3);
datacell = {S_in,S_outorig};
ncell = length(datacell);
parmnames = {'Ti','Te','Nel'};
parnames2 = {'T_i','T_e','log_{10}(N_e)'};
axlims = [-100,100,-100,100,100,500];
viewang = [-40,20];
%% set up
slicecell = {[0],[],[250]};
axlabels = {'x km','y km','z km'};
titlecell={'Phantom','Blurred Data'};
filecell = {'phantom','blurreddata'};
clims = {[500,2500],[500,2500],[9.5,11]};
%% Plotting
% figure('Position',[205,267,1600,716],'Color',[1,1,1])
hvec = zeros(1,length(datacell));
for iparam = 1:num_params
    for k = 1:length(datacell)
        if iparam==1
            
            hvec(k) = figure('Position',[205,267,1400,375],'Color',[1,1,1]);
        else
            figure(hvec(k));
        end
        curS = datacell{k};
        Nx = length(curS.x);
        Ny = length(curS.y);
        Nz = length(curS.z);
        times = curS.Time_Vector;
        Nt = length(times);
        if ndims(curS.Param_List)==2
            v = reshape(curS.Param_List,[Ny,Nx,Nz,Nt]);
        else
            v = reshape(squeeze(curS.Param_List(:,:,iparam)),[Ny,Nx,Nz,Nt]);
        end
    % set up a slice array
        
            curt = destimes(2);
            timenum = times(curt);
            curdata = squeeze(v(:,:,:,curt));
            curdata(nan_mask) = nan;
            titlestr =[parmnames{iparam},' ',titlecell{k}, ' at time ' num2str(timenum), ' s'];
    %         subplot(ntim,ncell,k+(l-1)*ncell)
            subplot(1,num_params,iparam)
            htemp = slice(curS.x,curS.y,curS.z,curdata,slicecell{1},slicecell{2},slicecell{3});
            set(htemp,'EdgeColor','none', 'FaceColor','interp');
            xlabel(axlabels{1},'FontSize',16);
            ylabel(axlabels{2},'FontSize',16);
            zlabel(axlabels{3},'FontSize',16);
            title(titlestr,'FontSize',16)
            colormap jet
            caxis(clims{iparam})
            cbh = colorbar;
            axis(axlims)
            set(get(cbh,'ylabel'),'String',parnames2{iparam},'FontSize',16)
            view(viewang);
%         saveas(gcf,['allparams',filecell{k}],'fig');
%         export_fig(['allparams',filecell{k},'.png']);
    end
end