% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\17. ToyClean';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\Toy2';

cd(dir_source);

t0 = 0;   t1 = 2000; dt = 0.02;
dx = 1e-3;  
x = 0:dx:1;   

mybeta = x';
% LowestPt = 0.1;
% LowerBi = 0.2;
% mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;

D_vector = linspace(1,16,16)*1e-7;
% D_vector = 1.0e-05 *[0.067	0.13	0.27	0.3	0.47	0.53	0.67	0.73	0.87	0.93];
count = 0;

Diff_type = 1; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

X_0 = -1.2; Y_0 = 0.1; 
y0 = [x*0+X_0, x*0+Y_0];
    
for ii = 1:length(D_vector)
    D = D_vector(ii);
    display(['Toy2 D = ', num2str(D)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Toy2(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 

    Z0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';
    

    cd([dir_save]) 
%     count = count+1;  
    save(['Toy2_Data_', num2str(ii)], 'Z0D','Y0D', 't', 'x', 'mybeta', 'D')
%     save(['Toy2_Data_no', num2str(count)], 'Z0D','Y0D', 't', 'x', 'mybeta', 'D')
    
    figure(ii);
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
        colorbar
		hold on
        plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
    
   savefig(ii, ['Toy2_D_', num2str(ii), '.fig'])
   cd([dir_save, '\Images'])
   set(gcf,'PaperPositionMode','auto')
   print(['Toy2_D_', num2str(ii)],'-dpng', '-r300')
   
%    savefig(ii, ['Toy2_no_', num2str(count), '.fig'])
%    cd([dir_save, '\Images'])
%    set(gcf,'PaperPositionMode','auto')
%    print(['Toy2_no_', num2str(count)],'-dpng', '-r300')
        
end


cd(dir_parent);