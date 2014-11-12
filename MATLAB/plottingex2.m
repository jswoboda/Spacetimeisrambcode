%% plottingex2
% by John Swoboda
% This is a plotting script for figures 8, 10 and 11. This script requires 
% the data files origdata.mat, origdata2.mat and patchex.mat.
%% load in data
load('origdata.mat','S_outorig')
% load('Interpdata.mat','S_out2interp')
load('origdata2.mat','S_outorig2')
S_in = load('patchex.mat');

datacell = {S_in,S_outorig,S_outorig2};
destimes = [30, 45, 60];
ntim =  length(destimes);
ncell = length(datacell);

% determine nans
% make mask for locations
nan_mask = isnan(S_outorig.Param_List);
for idim = 1:ndims(nan_mask)-1
    nan_mask = all(nan_mask,ndims(nan_mask));
end
%% set up
slicecell = {[0],[],[250]};
axlabels = {'x km','y km','z km'};
titlecell={'Phantom','Long Int.','Short Int.'};
filecell = {'phantom','blurreddata','variabledata'};
clims = [9.5,11];
axlims = [-100,100,-100,100,100,500];
viewang = [-40,20];
%% Plotting

for k = 1:length(datacell)
    figure('Position',[205,267,1400,375],'Color',[1,1,1])
    curS = datacell{k};
    Nx = length(curS.x);
    Ny = length(curS.y);
    Nz = length(curS.z);
    times = curS.Time_Vector;
    Nt = length(times);
    if ndims(curS.Param_List)==2
        v = reshape(curS.Param_List,[Ny,Nx,Nz,Nt]);
    else
        v = reshape(squeeze(curS.Param_List(:,:,3)),[Ny,Nx,Nz,Nt]);
    end
% set up a slice array
    for l = 1:length(destimes)
        curt = destimes(l);
        timenum = times(curt);
        curdata = squeeze(v(:,:,:,curt));
        curdata(nan_mask) = nan;

        titlestr =[titlecell{k}, ' at time ' num2str(timenum), ' s   '];
%         subplot(ntim,ncell,k+(l-1)*ncell)
        subplot(1,ntim,l)
        htemp = slice(curS.x,curS.y,curS.z,curdata,slicecell{1},slicecell{2},slicecell{3});
        set(htemp,'EdgeColor','none', 'FaceColor','interp');
        xlabel(axlabels{1},'FontSize',16);
        ylabel(axlabels{2},'FontSize',16);
        zlabel(axlabels{3},'FontSize',16);
        title(titlestr,'FontSize',16)
        colormap jet
        caxis(clims)
        cbh = colorbar;
        axis(axlims)
        view(viewang) 
        set(get(cbh,'ylabel'),'String','log_{10}(N_e)','FontSize',16)
    end
    saveas(gcf,filecell{k},'fig');
    export_fig([filecell{k},'.png']);
end