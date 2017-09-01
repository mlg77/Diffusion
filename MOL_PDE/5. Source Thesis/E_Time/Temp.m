%% Temp file check what happens if keep excited
clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';

%% Step one load the bifurcation data
x = 0.2;
mybeta = x;


%% Inital Conditions
t0 = 0;   t1 = 10; dt = 0.001;
tspan = [t0:dt: t1];
t = tspan;

Diff_type = 1; D=0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [Z_0', V_0', Y_0'];

    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D, flag), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';
    
 

