% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

close all; clear; clc

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages\betaxChanges';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\betaChanges\Gold';

cd(dir_source);

t0 = 0;   t1 = 30; dt = 0.001;
dx = 1e-3;
x = 0:dx:1;


D = 5e-6;
Diff_type = 1;
tspan = [t0:dt: t1];
t = tspan;
M = length(x);
N = length(t);
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];


for ii = 1:4
    if ii == 1
        LowestPt = 0;
        LowerBi = 0.288;
        mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
    elseif ii == 2
        LowestPt = 0;
        LowerBi = 0.288;
        mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
        idx_1 = find(mybeta>= 0.170, 1)
        mybeta(401:451) = mybeta(idx_1);
    elseif ii == 3
        LowestPt = 0;
        LowerBi = 0.288;
        mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
        mybeta(376:451) = mybeta(376);
        mybeta(301:375) = mybeta(301);
        mybeta(226:300) = mybeta(226);
        mybeta(151:225) = mybeta(151);
        mybeta(76:150) = mybeta(76);
    elseif ii == 4
        LowestPt = 0;
        LowerBi = 0.288;
        mybetabase = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
        % intersect :
        x_eq = [0, 0.5  , 0.35, 0.25 ]';
        b_eq = [0, 0.288, 0.20, 0.32 ]';
        A = [x_eq.^3, x_eq.^2, x_eq, ones(4,1)];
        pars = A\b_eq
        a = pars(1); b= pars(2); c = pars(3);  d = pars(4);
        betacurve = a.*x.^3 + b.*x.^2 + c.*x + d;
        mybeta = [betacurve(1:500)'; mybetabase(501:end)];
    end
    
    
    display(['Gold ii = ', num2str(ii)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';
    
    cd([dir_save])
    save(['Gold_', num2str(ii)], 'Z0D','Y0D','V0D', 't', 'x', 'mybeta', 'D')
    
    figure(ii);
    imagesc(t,flipud(x),Z0D)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    hold on
    plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
    
    figure(ii+10);
    hold on;
    plot(mybeta, x,  'b', 'linewidth', 2)
    idx_half = find(x>=0.5,1);
    plot([mybeta(idx_half), mybeta(idx_half), mybeta(1)], [x(1), x(idx_half), x(idx_half)],'k', 'linewidth', 2)
    ylabel('Position, x')
    xlabel('Beta, \beta')
    if ii == 4
        figure(ii);
        idx2 = find(mybeta>= mybeta(idx_half), 1);
        idx3 = find(mybeta(201:end)<= mybeta(idx_half), 1) + 200;
        plot([t(1), t(end)], [x(idx2), x(idx2)],'k', 'linewidth', 2)
        plot([t(1), t(end)], [x(idx3), x(idx3)],'k', 'linewidth', 2)
    end
end
display('finished Run')
return

cd([dir_save])
num_figs = 1:4;
for ii = num_figs
    figure(ii)
    savefig(ii, ['Gold_st_', num2str(ii), '.fig'])
    cd([dir_save, '\Images'])
    set(gcf,'PaperPositionMode','auto')
    print(['Gold_st_', num2str(ii)],'-dpng', '-r300')
    
    figure(ii + 10)
    savefig(ii+10, ['Gold_beta_', num2str(ii), '.fig'])
    cd([dir_save, '\Images'])
    set(gcf,'PaperPositionMode','auto')
    print(['Gold_beta_', num2str(ii)],'-dpng', '-r300')
end


cd(dir_parent);