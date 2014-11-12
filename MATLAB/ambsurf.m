%% Fig Dir
fig_dir = '/Users/Bodangles/Documents/Research/spacetimeisramb/Figs/';

%% setup data
ny = 2^7;
nx = 2^7;
nz = 2^7;
xvec = linspace(-100,100,nx);
yvec = linspace(-100,100,ny);
d2r = pi/180;
r2d = 180/pi;
zvec = linspace(200,500,nz);

[X,Y,Z] = meshgrid(xvec,yvec,zvec);
h5file = 'lp240_20/AmbFunc.h5';
Arange = h5read(h5file,'/Range');
Arange = Arange/1e3;
Wrange = h5read(h5file,'/Wrange');
Wrange1 = Wrange(:,1);
avar = ceil(length(Wrange1)/2-5:length(Wrange1)/2+5);
avemax = mean(Wrange1(avar));
Wrange1 = Wrange1/avemax;
rngstart = 400;
%% Go to spherical coords
R = sqrt(X.^2+Y.^2+Z.^2);
Az = mod(atan2(Y,X),2*pi)*180/pi;
Azr = Az*d2r;
El = asind(Z./R);
Elr = pi/2-d2r*El;

interp1(Arange+rngstart,Wrange1,R,'nearest');


azlist = [86.94,96.36,71.87,52.03];
ellist = [86.84,83.93,82.83,85.01];
azlist = d2r*azlist;
ellist = pi/2-d2r*ellist;
%% Make plot
figure('Position',[520  500  815  598],'Color','w');
R_a = reshape(interp1(Arange+rngstart,Wrange1,R(:),'nearest'),size(R));
for k = 1:length(azlist)
    
    c_Az = azlist(k);
    c_El = ellist(k);
    E_a = AMISR_Pattern(Azr,Elr,c_Az,c_El);
    %E_a = E_a/max(E_a(:));
    fv = isosurface(X,Y,Z,E_a.*R_a,.5);
    p1 = patch(fv);
    isonormals(X,Y,Z,E_a,p1);
    set(p1,'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
end
% fv = isosurface(X,Y,Z,E_a.*R_a,.5);
% p1 = patch(fv);
% isonormals(X,Y,Z,E_a,p1);
% set(p1,'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
%daspect([1,1,1]);
view(3);
camlight;
lighting gouraud



grid on

xlabel('x in km','FontSize',16);
ylabel('y in km','FontSize',16);
zlabel('z in km','FontSize',16);
title('Spatial Ambiguity Functions','FontSize',18);
% export_fig(gcf,fullfile(fig_dir,'spaceamb.png'));

% fv2 = isosurface(X,Y,Z,E_a2.*R_a,.5);
% p2 = patch(fv2);
% isonormals(X,Y,Z,E_a2,p2);
% set(p2,'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);

% %% Az and el cuts
% Azvec = linspace(-180,170,360);
% Elvec = linspace(0,179,180);
% Eaz = diric(sind(Azvec),arsize);
% Eel = diric(cosd(Elvec),arsize);
% 
% figure,plot(Azvec,mag2db(abs(Eaz)));
% xlabel('Az');
% ylabel('dB');
% figure,plot(Elvec,mag2db(abs(Eel)));
% xlabel('El');
% ylabel('dB');