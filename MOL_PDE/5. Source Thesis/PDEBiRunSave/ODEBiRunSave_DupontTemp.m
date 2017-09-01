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
% dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\2. PDE_Results';
dir_name = '\1. Dupont';

cd(dir_source);


%% Inital Conditions to eaisly change
t0 = 0;   t1 = 20; dt = 0.001;
dx = 1e-3;  
x = 0:dx:1;    
mybeta = x';

%% Inital Conditions dont change
Diff_type = 1; D_Array =0:10e-6/4:10e-6;
M = length(x); 
N = length(t); 
mtol = 1e-3;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

%% Run Simulation 0D
    Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
	y0 = [x*0+Z_0, x*0+A_0, x*0+Y_0];
    display(['Dupont '])
    tic
    D = D_Array(1);
    [t, y0D] = ode15s(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime15_0 = toc;
    Z0D_15 = y0D(:, 1:M)';
    A0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';

    
    figure();
    imagesc(t,flipud(x),Z0D_15)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
        
for ii = 3
    cd(dir_source);
	Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
	y0 = [x*0+Z_0, x*0+A_0, x*0+Y_0];
    display(['Dupont '])
    tic
    D = D_Array(ii+1);
    [t, y0D] = ode15s(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime15_D = toc;
    Z_15 = y0D(:, 1:M)';
    A = y0D(:, M+1:2*M)';
    Y = y0D(:, 2*M+1:3*M)';

    
    figure();
    imagesc(t,flipud(x),Z_15)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Fickian diffusion')
		colormap jet
		hold on

end

    




