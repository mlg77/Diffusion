% Generates three sets of results, No Diffusion, Simple and Electro
% Diffusion
% Author: Michelle Goodman
% Date 8/6/2015

clear; clc; close all; 

%% Ask what sections
prompt = 'What sections? all/bounds/simple/SD/ED/plot_only: ';
mystr = input(prompt,'s');

acceptable = [{'all'}, {'bounds'}, {'simple'}, {'SD'}, {'ED'}, {'plot_only'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end

cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp\Pervious_saves')
%% Do first section
if strcmp(mystr, 'bounds') | strcmp(mystr, 'all')
    load('inital_data.mat');
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp')
    for i = 1:length(mybeta)
        [ Z1, V1 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta(i), 0);
        my_max(i) = max(Z1(10, 1001:end));
        my_min(i) = min(Z1(10, 1001:end));
    end
    bt_point_found = 1;
    for k = 1:length(my_max)
        if abs(my_max(k) - my_min(k)) < 0.007 & bt_point_found
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
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp\Pervious_saves')
    save('bounds_data', '-regexp', '^(?!(mystr)$).')
end
%% Do Second Section
if strcmp(mystr, 'simple') | strcmp(mystr, 'all')
    clearvars -except mystr
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp')
    Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
    dt = 0.002; t_end = 50; t = 0:dt:t_end;   N = length(t);
    dx = 1e-3; x = 0:dx:1;   M = length(x); 
    mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
    [ Z2, V2 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, 1);
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp\Pervious_saves')
    save('simple_data', '-regexp', '^(?!(mystr)$).')
end
%% Do first section
if strcmp(mystr, 'SD') | strcmp(mystr, 'all')
    clearvars -except mystr
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp')
    Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
    D = 6e-6;
   dt = 0.002; t_end = 50; t = 0:dt:t_end;   N = length(t);
    dx = 1e-3; x = 0:dx:1;   M = length(x);  
    mybeta = (0.5*(1+tanh((x-0.5)/0.3)))';
    [ Z2b, V2b ] = Gold_Simple_Diffusion( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp\Pervious_saves')
    save('SD_data', '-regexp', '^(?!(mystr)$).')
end
%% Do Second Section
if strcmp(mystr, 'ED') | strcmp(mystr, 'all')
    clearvars -except mystr
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp')
    Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
    D = 6e-6;
    dt = 10e-3; t_end = 40; t = 0:dt:t_end;   N = length(t);
    dx = 5e-3; x = 0:dx:1;   M = length(x); 
    mybeta = (0.5*(1+tanh((x-0.5)/0.3)))';
    [ Z3, V3 ] = Gold_Electro_Diffusion( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
    cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp\Pervious_saves')
    save('ED_data', '-regexp', '^(?!(mystr)$).')
end

%% Plot results
My_plot( mystr )
cd('C:\Users\mlg77\Local Documents\Git\Diffusion\MOL_PDE\5. Goldbeter_all_Simp')