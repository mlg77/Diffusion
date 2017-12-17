% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\15. Koe';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\Koe';

cd(dir_source);

t0 = 0;   t1 = 400; dt = 0.01;
% dx = 1e-3;  
% x = 0:dx:1;   
% 
% LowestPt = -1 + 2*0.844;
% LowerBi = 0.844;
% mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
% mybeta = flipud(mybeta); 

x = linspace(0.5,1,round(0.5*1000/(2*0.156)));
mybeta = flipud(x');


D_vector = linspace(0,10,16)*1e-6;
% D_vector = 1.0e-05 *[0.067	0.13	0.27	0.3	0.47	0.53	0.67	0.73	0.87	0.93];
count = 0;

Diff_type = 1; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

Z_0 = 0.2218; Y_0 = 1.0854; V_0 = -44.1461; N_0 = 0.0832; I_0 = 0.7142;
y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
    
for ii = 1:length(D_vector)
    x = linspace(0.5,1,round(0.5*1000/(2*0.156)));
    mybeta = flipud(x');
    
    D = D_vector(ii);
    display(['Koe D = ', num2str(D)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 

    Z0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';
    V0D = y0D(:, 2*M+1:3*M)';
    N0D = y0D(:, 3*M+1:4*M)';
    I0D = y0D(:, 4*M+1:5*M)';
    
    mybeta = mybeta(1:1001);
    x = linspace(0,1,length(mybeta));
    
    Z0D = Z0D(1:1001, :);
    Y0D = Y0D(1:1001, :);
    V0D = V0D(1:1001, :);
    N0D = N0D(1:1001, :);
    I0D = I0D(1:1001, :);

    cd([dir_save]) 
%     count = count+1;  
    save(['Koe_Data_', num2str(D)], 'Z0D','Y0D','V0D','N0D','I0D', 't', 'x', 'mybeta', 'D')
%     save(['Koe_Data_no', num2str(count)], 'Z0D','Y0D','V0D','N0D','I0D', 't', 'x', 'mybeta', 'D')
    
    figure(ii);
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
        colorbar
		hold on
        plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
    
   savefig(ii, ['Koe_D_', num2str(D), '.fig'])
   cd([dir_save, '\Images'])
   set(gcf,'PaperPositionMode','auto')
   print(['Koe_D_', num2str(D)],'-dpng', '-r300')
   
%    savefig(ii, ['Koe_no_', num2str(count), '.fig'])
%    cd([dir_save, '\Images'])
%    set(gcf,'PaperPositionMode','auto')
%    print(['Koe_no_', num2str(count)],'-dpng', '-r300')
%         
end


cd(dir_parent);