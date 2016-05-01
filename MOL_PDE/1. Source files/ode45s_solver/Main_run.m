% ODE45s solver 
% Author: Michelle Goodman
% Date: 5/4/16

clear; clc; %close all; 
tic
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.SaveDir = '4. Output files\ODE45_solver';
%% Span and Inital Conditions
t0 = 0;   t1 = 100;
tspan = [t0, t1];
dx = 1e-3;  
x = 0:dx:1;    M = length(x); 
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
% mybeta = x';
Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 2;

%% Amount of Diffusion
D = 6e-6;

%%
mtol = 1e-8;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z = y(:, 1:M)';
V = y(:, M+1:2*M)';
Y = y(:, 2*M+1:3*M)';


bt_point = 0.8;  top_pt = 0.8470; top_point = 0.28; bt_pt = 0.2640;
t_end = t(end);
figure(1)
    subplot(1,2,2)
        plot(mybeta,x)
        ylabel('Position, x')
        xlabel('beta, [-]')
        hold on
        list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
        top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
        plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
        plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
    subplot(1,2,1)
        imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['Z, Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
        plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
toc


% cd([AllDir.ParentDir ,AllDir.SaveDir])
% save('SD_data_ode')
% cd([AllDir.ParentDir, AllDir.SourceDir])

    
