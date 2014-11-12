%% Fig Dir
fig_dir = '/Users/Bodangles/Documents/Research/spacetimeisramb/Figs/';

%% setup data
IPP = 0.0087;% ipp in seconds
Nsecs = 2*60;
Nbeams = 4;
ny = 2^7;
nx = 2^7;
nz = 2^7;
nt = floor(Nsecs/(Nbeams*IPP));
xvec = linspace(-100,100,nx);
yvec = linspace(-100,100,ny);
d2r = pi/180;
r2d = 180/pi;
zvec = linspace(200,500,nz);

[X_orig,Y_orig,Z_orig] = meshgrid(xvec,yvec,zvec);
h5file = 'lp240_20/AmbFunc.h5';
Arange = h5read(h5file,'/Range');
Arange = Arange/1e3;
Wrange = h5read(h5file,'/Wrange');
Wrange1 = Wrange(:,1);
avar = ceil(length(Wrange1)/2-5:length(Wrange1)/2+5);
avemax = mean(Wrange1(avar));
Wrange1 = Wrange1/avemax;
% time = linspace(0,5*60,nt);
% vel = [0,.1,0]; 

time = linspace(0,Nsecs,nt/10);
vel = [0,.5,0]; 

azlist = [86.94,96.36,71.87,52.03];
ellist = [86.84,83.93,82.83,85.01];
azlist = d2r*azlist;
ellist = pi/2-d2r*ellist;
%% Go to spherical coords

figure('Position',[520  500  815  598],'Color','w');
nsteps = nt*length(azlist);

h = waitbar(0,sprintf('0 of %d steps',nsteps),'Name','Making ambiguity surface...',...
            'CreateCancelBtn',...
            'setappdata(gcbf,''canceling'',1)');
for k = 1:length(azlist)
    if getappdata(h,'canceling')
        break    
    end
    c_Az = azlist(k);
    c_El = ellist(k);
    for itime = 1:length(time)
        
        if getappdata(h,'canceling')
            break     
        end
        curtime = (k-1)*nt+itime;
        
        waitbar(curtime/nsteps,h,sprintf('%d of %d steps',curtime,nsteps))
        
        X = X_orig-vel(1)*time(itime);
        Y = Y_orig-vel(2)*time(itime);
        Z = Z_orig-vel(3)*time(itime);

        R = sqrt(X.^2+Y.^2+Z.^2);
        Az = mod(atan2(Y,X),2*pi)*180/pi;
        Azr = Az*d2r;
        El = asind(Z./R);
        Elr = pi/2-d2r*El;
        interp1(Arange+250,Wrange1,R,'nearest');
        
       
        if itime==1
            R_a = reshape(interp1(Arange+250,Wrange1,R(:),'nearest'),size(R));
            E_a = AMISR_Pattern(Azr,Elr,c_Az,c_El);
        else
            R_a = R_a+reshape(interp1(Arange+250,Wrange1,R(:),'nearest'),size(R));
            E_a = E_a+AMISR_Pattern(Azr,Elr,c_Az,c_El);
        end
    end
    %R_a = R_a;
    %E_a= E_a;
    fullamb = E_a.*R_a;
    fv = isosurface(X_orig,Y_orig,Z_orig,fullamb,.5*max(fullamb(:)));
    p1 = patch(fv);
    isonormals(X_orig,Y_orig,Z_orig,E_a,p1);
    set(p1,'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
end

view(3);
camlight;
lighting gouraud
grid on

xlabel('x in km','FontSize',16);
ylabel('y in km','FontSize',16);
zlabel('z in km','FontSize',16);
title('Spatial Ambiguity Functions with Motion','FontSize',18);
export_fig(gcf,fullfile(fig_dir,'spaceambmoving.png'));
