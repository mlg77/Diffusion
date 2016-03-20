% Generates three sets of results, No Diffusion, Simple and Electro
% Diffusion
% Author: Michelle Goodman
% Date 8/6/2015

clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\Sneyd';
AllDir.SaveDir = '4. Output files';

%% Ask what sections
prompt = 'What sections? all/bounds/simple/SD/ED/plot_only: ';
mystr = input(prompt,'s');

acceptable = [{'all'}, {'bounds'}, {'simple'}, {'SD'}, {'ED'}, {'plot_only'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end
%% Inital Data
dt = 0.005; dx = 1e-3; t_end = 50;
t = 0:dt:t_end; x = 0:dx:1; M = length(x); N = length(t);
bperc = 1;
mybeta = (0:0.01:1)*bperc;
CCtPH_0 = [0.2, 0.5, 1, 0.5];


%% Do Bounds Section Produce Biforcation
if strcmp(mystr, 'bounds') | strcmp(mystr, 'all')
   dx = 0.2; x = 0:dx:1; M = length(x);
    dt = 0.005; t_end = 500;
    t = 0:dt:t_end;   N = length(t);
    for i = 1:length(mybeta)
        [ C.bounds, Ct.bounds, P.bounds, H.bounds ] = Sneyd_Simple( dt, dx, x, t, M, N, CCtPH_0, mybeta(i), 0);
        mrange = 20000;
        my_max(i) = max(C.bounds(2, mrange:end));
        my_min(i) = min(C.bounds(2, mrange:end));
%         pause(0.1); figure(10); plot(t(mrange:end), C.bounds(2, mrange:end));
    end
    bt_point_found = 1;
    for k = 1:length(my_max)
        if abs(my_max(k) - my_min(k)) < 0.50 & bt_point_found % 0.007
            bt_point = mybeta(k);
            x_bt_pt = my_max(k);
        elseif bt_point_found
            bt_point_found = 0;
        elseif abs(my_max(k) - my_min(k)) < 0.50%0.01
            top_point = mybeta(k);
            x_top_pt = my_max(k);
            break
        end
    end
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('bounds_data', '-regexp', '^(?!(mystr)$).')
end

%% They all have the same IC

dt = 0.005; dx = 1e-3; t_end = 300;
t = 0:dt:t_end; x = 0:dx:1; M = length(x); N = length(t);
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))'*bperc;
% mybeta = linspace(0,1,M)';
CCtPH_0 = [0.2, 0.5, 0.5, 0.5];
D =2;%00e-6;
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

%% Do Second Section
if strcmp(mystr, 'simple') | strcmp(mystr, 'all')
    cd([AllDir.ParentDir, AllDir.SourceDir])
    [ C.simple, Ct.simple, P.simple, H.simple ] = Sneyd_Simple( dt, dx, x, t, M, N, CCtPH_0, mybeta, 0);
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('simple_data', '-regexp', '^(?!(mystr)$).')
end
%% Do Simple Diffusion section
if strcmp(mystr, 'SD') | strcmp(mystr, 'all')
    cd([AllDir.ParentDir, AllDir.SourceDir])
    [ C.SD, Ct.SD, P.SD, H.SD ] = Sneyd_Simple_Diffusion_sp( dt, dx, x, t, M, N, CCtPH_0, mybeta, D);
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('SD_data', '-regexp', '^(?!(mystr)$).')
end
%% Do Second Section
if strcmp(mystr, 'ED') | strcmp(mystr, 'all')
    cd([AllDir.ParentDir, AllDir.SourceDir])
    [ Z3, V3 ] = Gold_Electro_Diffusion_noinvsp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
    cd([AllDir.ParentDir ,AllDir.SaveDir])
    save('ED_data', '-regexp', '^(?!(mystr)$).')
end

%% Plot results
cd([AllDir.ParentDir, AllDir.SourceDir])
My_plot_report( mystr , AllDir)
cd([AllDir.ParentDir, AllDir.SourceDir])

% figure(3); colormap gray; 
% figure(4); colormap gray