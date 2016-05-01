% Generates three sets of results, No Diffusion, Simple and Electro
% Diffusion
% Author: Michelle Goodman
% Date 8/6/2015

clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';

%% Ask what sections
prompt = 'What sections? all/bounds/simple/SD/ED/plot_only: ';
mystr = input(prompt,'s');

acceptable = [{'all'}, {'bounds'}, {'simple'}, {'SD'}, {'ED'}, {'plot_only'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end

%% Do Bounds Section Produce Biforcation
cd([AllDir.ParentDir, AllDir.InitalDataDir]);
if strcmp(mystr, 'bounds') | strcmp(mystr, 'all')
    load('Defult_data.mat');
    cd([AllDir.ParentDir, AllDir.SourceDir])
    
    dt = 0.005; t_end = 20;
    t = 0:dt:t_end;   N = length(t);
    for i = 1:length(mybeta)
        [ Z1, V1 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta(i), 0);
        my_max(i) = max(Z1(10, 1001:end));
        my_min(i) = min(Z1(10, 1001:end));
%         plot(V1(10, 1001:end))
%         pause(0.1)
%         my_max(i) = max(V1(10, 3001:end));
%         my_min(i) = min(V1(10, 1001:end));
    end
    bt_point_found = 1;
    for k = 1:length(my_max)
        if abs(my_max(k) - my_min(k)) < 0.01 & bt_point_found % 0.007
            bt_point = mybeta(k);
            x_bt_pt = my_max(k);
        elseif bt_point_found
            bt_point_found = 0;
        elseif abs(my_max(k) - my_min(k)) < 0.01
            top_point = mybeta(k);
            x_top_pt = my_max(k);
            break
        end
    end
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('bounds_data', '-regexp', '^(?!(mystr)$).')
end

%% They all have the same IC
tic
Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
D = 6e-6;
dt = 0.1e-3; t_end = 100;
dx = 1e-3;  

t = 0:dt:t_end;   N = length(t);
x = 0:dx:1;   M = length(x); 

mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
% mybeta = linspace(0,1,M)';
% mybeta = [0.2*ones(1, round(0.2*M)),linspace(0.3,0.5,round(0.6*M)),0.2*ones(1, round(0.2*M))]';

% Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
% D = 2e-6;
% dt = 2e-3; t_end = 20;
% dx = 0.001;  
% 
% t = 0:dt:t_end;   N = length(t);
% x = 0:dx:dx;   M = length(x); 

%     mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
% mybeta = [0.6,0]';

%% Do Simple no Diffusion Section
if strcmp(mystr, 'simple') | strcmp(mystr, 'all')
    cd([AllDir.ParentDir, AllDir.SourceDir])
    [ Z2, V2 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, 1);
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('simple_data', '-regexp', '^(?!(mystr)$).')
end
%% Do Simple Diffusion (Fickian) section
if strcmp(mystr, 'SD') | strcmp(mystr, 'all')
    cd([AllDir.ParentDir, AllDir.SourceDir])
    [ Z2b, V2b ] = Gold_Simple_Diffusion_sp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('SD_data', '-regexp', '^(?!(mystr)$).')
end
%% Do Electro Diffusion Section
if strcmp(mystr, 'ED') | strcmp(mystr, 'all')
    cd([AllDir.ParentDir, AllDir.SourceDir])
    [ Z3, V3 ] = Gold_Electro_Diffusion_noinvsp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('ED_data', '-regexp', '^(?!(mystr)$).')
end

%% Plot results
cd([AllDir.ParentDir, AllDir.SourceDir])
My_plot( mystr , AllDir)
cd([AllDir.ParentDir, AllDir.SourceDir])
toc
% figure(3); colormap gray; 
% figure(4); colormap gray