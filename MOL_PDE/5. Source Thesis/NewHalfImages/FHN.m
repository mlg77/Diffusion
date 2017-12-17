% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\FHN';


cd(dir_source);

t0 = 0;   t1 = 1000; dt = 0.02;
dx = 1e-3;  
x = 0:dx:1;   

LowestPt = 0;
LowerBi = 0.163*2;
mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;

D_vector = linspace(0,10,16)*1e-6;
% D_vector = 1.0e-05 *[0.067	0.13	0.27	0.3	0.47	0.53	0.67	0.73	0.87	0.93];
% count = 0;

Diff_type = 1; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

X_0 = -1; Y_0 = 1; 
y0 = [x*0+X_0, x*0+Y_0];

    
for ii = 1:length(D_vector)
    D = D_vector(ii);
    display(['FHN D = ', num2str(D)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 

    X0D = y0D(:, 1:M)';
    Z0D = y0D(:, M+1:2*M)';

    cd([dir_save]) 
%     count = count+1;  
    save(['FHN_Data_', num2str(D)], 'X0D','Z0D', 't', 'x', 'mybeta', 'D')
%     save(['FHN_Data_no', num2str(count)], 'X0D','Z0D', 't', 'x', 'mybeta', 'D')
    
    figure(ii);
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
        colorbar
		hold on
        plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
    
   savefig(ii, ['FHN_D_', num2str(D), '.fig'])
   cd([dir_save, '\Images'])
   set(gcf,'PaperPositionMode','auto')
   print(['FHN_D_', num2str(D)],'-dpng', '-r300')
        
%    savefig(ii, ['FHN_no_', num2str(count), '.fig'])
%    cd([dir_save, '\Images'])
%    set(gcf,'PaperPositionMode','auto')
%    print(['FHN_no_', num2str(count)],'-dpng', '-r300')
%         
end


cd(dir_parent);