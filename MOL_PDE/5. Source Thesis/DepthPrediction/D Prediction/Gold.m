% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

close all; clear; clc

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction\D Prediction';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\11. Height';

cd(dir_source);

t0 = 0;   t1 = 30; dt = 0.001;
dx = 1e-3;
x = 0:dx:1;



Diff_type = 1;
tspan = [t0:dt: t1];
t = tspan;
M = length(x);
N = length(t);
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];


for ii = 51:100
    D = rand()*9.0000e-06 + 1e-6;
    LowestPt = 0;
    LowerBi = 0.288;
    mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
    
    
    display(['Gold ii = ', num2str(ii)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';
    
    cd([dir_save])
    save(['Gold_', num2str(ii)], 'Z0D','Y0D','V0D', 't', 'x', 'mybeta', 'D')
    
%     figure(ii);
%     imagesc(t,flipud(x),Z0D)
%     set(gca,'YDir','normal')
%     xlabel('Time, [s]')
%     ylabel('Position, x')
%     colormap jet
%     colorbar
%     hold on
%     plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
%     
%     figure(ii+10);
%     hold on;
%     plot(mybeta, x,  'b', 'linewidth', 2)
%     idx_half = find(x>=0.5,1);
%     plot([mybeta(idx_half), mybeta(idx_half), mybeta(1)], [x(1), x(idx_half), x(idx_half)],'k', 'linewidth', 2)
%     ylabel('Position, x')
%     xlabel('Beta, \beta')
   
end
display('finished Run')
return

cd([dir_save])
num_figs = 1:5;
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