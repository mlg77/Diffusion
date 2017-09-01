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
dir_name = '\4. Ernmentrout';

cd(dir_source);


%% Inital Conditions to eaisly change
t0 = 0;   t1 = 200; dt = 0.005;
dx = 1e-3;  
x = 0:dx:1;    
mybeta = x';

%% Inital Conditions dont change
Diff_type = 1; D_Array =0:10e-6/4:10e-6;
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );


%% Run Simulation 0D
    Z_0 = 300; V_0 = -40; N_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];
    display(['Ernmentrout '])
    tic
    D = D_Array(1);
    [t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime = toc;
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    N0D = y0D(:, 2*M+1:3*M)';

    cd([dir_save, dir_name]) 
    save('DataPDE', 'Z0D','N0D', 'V0D', 't', 'x', 'mybeta', 'runtime')
    
    figure();
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on

for ii = 1:4
    cd(dir_source);
	Z_0 = 300; V_0 = -40; N_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];
    display(['Ernmentrout '])
    tic
    D = D_Array(ii+1);
    [t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime = toc;
    Z = y0D(:, 1:M)';
    V = y0D(:, M+1:2*M)';
    N = y0D(:, 2*M+1:3*M)';

    cd([dir_save, dir_name]) 
    save(['DataPDE', num2str(ii)], 'Z','N', 'V', 't', 'x', 'mybeta', 'runtime', 'D')
    
    figure();
    imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Fickian diffusion')
		colormap jet
		hold on

end

Diff_type = 2; 
for ii = 1:4
    cd(dir_source);
	Z_0 = 300; V_0 = -40; N_0 = 0.5;
	y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];
    display(['Ernmentrout '])
    tic
    D = D_Array(ii+1);
    [t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime = toc;
    Z = y0D(:, 1:M)';
    V = y0D(:, M+1:2*M)';
    N = y0D(:, 2*M+1:3*M)';

    cd([dir_save, dir_name]) 
    save(['DataPDE', num2str(ii+4)], 'Z','N', 'V', 't', 'x', 'mybeta', 'runtime', 'D')
    
    figure();
    imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Electro diffusion')
		colormap jet
		hold on

end
%% Save Plots

cd([dir_save, dir_name])
NumberOfFig = 9;
for ii = 1:NumberOfFig
    savefig(ii, [num2str(ii), 'DataPDE.fig'])
end

cd([dir_save, dir_name, '\Images'])
for i = 1:9
    figure(i)
    set(gcf,'PaperPositionMode','auto')
    print([num2str(i),'DataPDE'],'-dpng', '-r300')
end


cd(dir_parent);








