% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

close all; clear; clc

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\Gold';

cd(dir_source);

t0 = 0;   t1 = 100; dt = 0.01;
dx = 1e-3;  
x = 0:dx:1;   

LowestPt = 0;
LowerBi = 0.288;
mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;

D_vector = linspace(0,10,16)*1e-6;
D_vector = 1.0e-05 *[0.067	0.13	0.27	0.3	0.47	0.53	0.67	0.73	0.87	0.93];



Diff_type = 1; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];

count = 0;
    
for ii = 1:length(D_vector)
    D = D_vector(ii);
    display(['Gold D = ', num2str(D)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 

    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';

    cd([dir_save]) 
    count = count+1;  
%     save(['Gold_Data_no', num2str(D)], 'Z0D','Y0D','V0D', 't', 'x', 'mybeta', 'D')
    save(['Gold_Data_no', num2str(count)], 'Z0D','Y0D','V0D', 't', 'x', 'mybeta', 'D')

    figure(ii);
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
        colorbar
		hold on
        plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
    
      
%    savefig(ii, ['Gold_D_', num2str(D), '.fig'])
%    cd([dir_save, '\Images'])
%    set(gcf,'PaperPositionMode','auto')
%    print(['Gold_D_', num2str(D)],'-dpng', '-r300')
   
   savefig(ii, ['Gold_no_', num2str(count), '.fig'])
   cd([dir_save, '\Images'])
   set(gcf,'PaperPositionMode','auto')
   print(['Gold_no_', num2str(count)],'-dpng', '-r300')
        
end


cd(dir_parent);