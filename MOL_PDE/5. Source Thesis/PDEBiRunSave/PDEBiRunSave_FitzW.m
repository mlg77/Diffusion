%% What I want to save for just the ODE Bifurcation diagrams

%       Z = 1 entire concentration matrix + other parameters
%       t = The matching time
%       x = The matching position (shouldn't be used)
%       mybeta = the matching beta array
%       Zmax = Bifurcation max line
%       Zmin = Bifurcation min line
%       TZ = The period of oscillations

%% What I want to plot for just the ODE Bifurcation diagrams

%       1	concentration vs Time Graphs 		Low Stim
%       2	concentration vs Time Graphs 		Low Stim
%       3	concentration vs Time Graphs 		Med Stim
%       4	concentration vs Time Graphs 		Med Stim
%       5	concentration vs Time Graphs 		High Stim
%       6	concentration vs Time Graphs 		High Stim

%       7	concentration vs Time Graphs 		All in one

%       8 	Bifurcation Graph
%       9	Period Graph

%       10 	Bifurcation Graph + Period Graph
close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\PDEBiRunSave';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\2. PDE_Results';
dir_name = '\3. Fitz';

cd(dir_source);


%% Inital Conditions to eaisly change
t0 = 0;   t1 = 600; dt = 0.01;
dx = 1e-3;  
t = t0:dt:t1;
x = (0:dx:1);   
mybeta = 2*x';

%% Inital Conditions dont change
Diff_type = 1; D_Array =0:10e-6/4:10e-6;
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

    cd([dir_save, dir_name]) 
    save('DataPDEW', 'Z0D','Y0D', 't', 'x', 'mybeta', 'runtime')
    
    figure();
    imagesc(t,flipud(x),Y0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
        
for ii = 1:4
    cd(dir_source);
	X_0 = -1; Y_0 = 1; 
	y0 = [x*0+X_0, x*0+Y_0];
    display(['Fitz '])
    tic
    D = D_Array(ii+1);
    [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime = toc;
    Z = y0D(:, 1:M)';
    Y = y0D(:, M+1:2*M)';
    
    cd([dir_save, dir_name]) 
    save(['DataPDEW', num2str(ii)], 'Z','Y', 't', 'x', 'mybeta', 'runtime', 'D')
    
    figure();
    imagesc(t,flipud(x),Y)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Fickian diffusion')
		colormap jet
		hold on

end

% Diff_type = 2; 
% for ii = 1:4
%     cd(dir_source);
% 	X_0 = -1; Y_0 = 1; 
% 	y0 = [x*0+X_0, x*0+Y_0];
%     display(['Fitz '])
%     tic
%     D = D_Array(ii+1);
%     [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
%     runtime = toc;
%     Z = y0D(:, 1:M)';
%     Y = y0D(:, M+1:2*M)';
%     
%     cd([dir_save, dir_name]) 
%     save(['DataPDE', num2str(ii+4)], 'Z','Y', 't', 'x', 'mybeta', 'runtime', 'D')
%     
%     figure();
%     imagesc(t,flipud(x),Z)
%         set(gca,'YDir','normal')
% 		xlabel('Time, [s]')
% 		ylabel('Position, x')
% 		title('Electro diffusion')
% 		colormap jet
% 		hold on
% 
% end
%% Save Plots

cd([dir_save, dir_name])
NumberOfFig = 5;
for ii = 1:NumberOfFig
    savefig(ii, [num2str(ii), 'DataPDEW.fig'])
end

cd([dir_save, dir_name, '\Images'])
for i = 1:NumberOfFig
    figure(i)
    set(gcf,'PaperPositionMode','auto')
    print([num2str(i),'DataPDEW'],'-dpng', '-r300')
end


cd(dir_parent);








