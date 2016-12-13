% ODE45s solver 
% Author: Michelle Goodman
% Date: 5/4/16

clear; clc; close all; 
tic
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\6. Eremntrout take 2';
AllDir.SaveDir = '4. Output files\Ernmentrout';
%% Span and Inital Conditions
prompt = 'What sections? Produce/plot: ';
mystr = input(prompt,'s');

acceptable = [{'Produce'}, {'plot'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end

if strcmp(mystr, 'Produce')
t0 = 0;   t1 = 50; dt = 0.01;
tspan = [t0:dt: t1];
dx = 1e-3;  
x = 0:dx:1;    M = length(x); 
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
% mybeta = x';

Z_0 = 300; V_0 = -40; N_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D =0;% 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z0D = y0D(:, 1:M)';
V0D = y0D(:, M+1:2*M)';
N0D = y0D(:, 2*M+1:3*M)';

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D = 60e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, yFD] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

ZFD = yFD(:, 1:M)';
VFD = yFD(:, M+1:2*M)';
NFD = yFD(:, 2*M+1:3*M)';

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 2; D = 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, yED] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

ZED = yED(:, 1:M)';
VED = yED(:, M+1:2*M)';
NED = yED(:, 2*M+1:3*M)';
display(['Simulation complete: ', num2str(toc), ' seconds'])
cd([AllDir.ParentDir ,AllDir.SaveDir])
save('All_data_ode')
cd([AllDir.ParentDir, AllDir.SourceDir])
end

My_plot_report(AllDir)

    
