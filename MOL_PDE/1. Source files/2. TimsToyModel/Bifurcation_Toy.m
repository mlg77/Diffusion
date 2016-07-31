%% Bifurcation Diagram

clear; clc; close all

AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\2. ToyModel_Compatable';
AllDir.SaveDir = '4. Output files\ODE45_solver';
%% Span and Inital Conditions
t0 = 0;   t1 = 600; dt = 0.0025;
tspan = [t0:dt: t1];
tspan = [t0, t1];
dx = 1e-3;  
x = 0:dx:1;    M = length(x); 
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
mybeta = x';

% mybeta = [0.1:0.4/(M-1):0.5]';
mybeta = [-0.25 :0.5/(M-1):0.25]';
%% Beta 0, linear, 0
% mybeta = (x-0.2)';
% mybeta(1:301) = 0; mybeta(801:end) = 0;

%% Beta fix?
% start_fixed_beta = find(x== 0.162);
% fixed_beta = mybeta(start_fixed_beta);
% mybeta(find(x== 0.156):start_fixed_beta) = fixed_beta;

Z_0 = 3; V_0 = 2; 
y0 = [x*0+Z_0, x*0+V_0];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1;

%% Amount of Diffusion
D =  0;% 
display(['Diffusion = ', num2str(D)])
%%
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y] = ode45(@(t,y) odefun_Toy(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z = y(:, 1:M)';

iti_Z = Z(:, find(t>=100,1):end);
plot(mybeta, max(iti_Z')')
hold on
plot(mybeta, min(iti_Z')')
