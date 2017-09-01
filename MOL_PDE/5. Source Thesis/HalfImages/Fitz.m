% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion

close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\HalfImages';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';

cd(dir_source);

%% Inital Conditions to eaisly change
t0 = 0;   t1 = 600; dt = 0.01;
dx = 1e-3;  
t = t0:dt:t1;
x = (0:dx:1);   

%% My beta For Half
% find(BifuMax.Z - BifuMin.Z >0.01*(max(BifuMax.Z) - min(BifuMin.Z)), 1)
LowerBi = 0.3240;
mybeta = (LowerBi/0.5)*(x');


%% Inital Conditions dont change
Diff_type = 1; D_Array =[0,6e-6];
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );


%% Run Simulation 0D
    X_0 = -1; Y_0 = 1; 
	y0 = [x*0+X_0, x*0+Y_0];
    display(['Fitz 0D '])
    tic
    D = D_Array(1);
    [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime = toc;
    Z0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';

    cd([dir_save]) 
    save('Data0D_Fitz', 'Z0D','Y0D', 't', 'x', 'mybeta', 'runtime')
    
    figure();
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion Fitz')
		colormap jet
        colorbar
		hold on
        plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
        
%% Run Sim FD
cd(dir_source);
    X_0 = -1; Y_0 = 1; 
	y0 = [x*0+X_0, x*0+Y_0];
    display(['Fitz FD '])
    tic
    D = D_Array(2);
    [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime = toc;
    Z0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';

    cd([dir_save]) 
    save('DataFD_Fitz', 'Z0D','Y0D', 't', 'x', 'mybeta', 'runtime')
    
    figure();
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Fickian diffusion Fitz')
		colormap jet
        colorbar
		hold on
        plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
        
        
     
%% Save Fig Files
cd([dir_save])
NumberOfFig = 2;
for ii = 1:NumberOfFig
    savefig(ii, ['Fitz', num2str(ii), 'Half.fig'])
end

cd([dir_save, '\Images'])
for i = 1:NumberOfFig
    figure(i)
    set(gcf,'PaperPositionMode','auto')
    print(['Fitz', num2str(i),'Half'],'-dpng', '-r300')
end


cd(dir_parent);