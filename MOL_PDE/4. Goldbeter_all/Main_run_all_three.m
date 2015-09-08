% Generates three sets of results, No Diffusion, Simple and Electro
% Diffusion
% Author: Michelle Goodman
% Date 8/6/2015

clear; clc; close all; 

dt = 0.005;
dx = 1e-3;
t_end = 15;

x = 0:dx:1;
t = 0:dt:t_end;

M = length(x); 
N = length(t);

Z_0 = 0.3;
V_0 = -40;
Y_0 = 0.5;

v_1_top = -18;%-18; 
v_1_bot = -35;%-30;

beta = 0:0.01:1;
%% First run the Simple 
for i = 1:length(beta)
    
    [ Z1, V1 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, beta(i), 0);
    my_max(i) = max(Z1(10, 1001:end));
    my_min(i) = min(Z1(10, 1001:end));
%     figure(1)    
%     subplot(4,3,beta*10+1)
%         plotyy(t, Z1(10,:), t, V1(10,:))
%         xlabel('Time, [s]')
%         ylabel('Calcium Concentration [\muM]')
%         legend('Z', 'V')
end
figure(1)
    plot(beta, my_max, beta, my_min)
    xlabel('beta')
    ylabel('Calcium Concentration [\muM]')
    legend('max', 'min')
%     set(gca,'xdir','reverse')
bt_point_found = 1;
for k = 1:length(my_max)
    if abs(my_max(k) - my_min(k)) < 0.007 & bt_point_found
        bt_point = beta(k);
        x_bt_pt = my_max(k);
    elseif bt_point_found
        bt_point_found = 0;
    elseif abs(my_max(k) - my_min(k)) < 0.01
        top_point = beta(k);
        x_top_pt = my_max(k);
        break
    end
end

hold on
plot([bt_point, bt_point], [0, x_bt_pt], 'k','LineWidth',2)
plot([top_point, top_point], [0, x_top_pt],  'k','LineWidth',2)

%% Run Simple 
dt = 0.002; t_end = 40; t = 0:dt:t_end;   N = length(t);
dx = 1e-3; x = 0:dx:1;   M = length(x); 
beta = (0.5*(1+tanh((x-0.5)/0.5)))';
[ Z2, V2 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, beta, 1);
figure(2)
subplot(1,2,2)
    plot(beta,flipud(x))
    ylabel('Position, x')
    xlabel('beta, [-]')
    hold on
    list_1 = find(beta>bt_point); list_2 = find(beta>top_point);
    top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
    plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
    plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
subplot(1,2,1)
    imagesc(t,flipud(x),Z2)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Z, Calcium Concentration in the Cytosol zero diffusion, [\muM]')
    colormap jet
    hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

    %% Run Simple Diffusion 6e-6 diffusion
D = 100e-6;
dt = 5e-3; t_end = 40; t = 0:dt:t_end;   N = length(t);
dx = 1e-3; x = 0:dx:1;   M = length(x); 
beta = (0.5*(1+tanh((x-0.5)/0.3)))';
[ Z2b, V2b ] = Gold_Simple_Diffusion( dt, dx, x, t, M, N, Z_0, V_0, Y_0, beta, D);
figure(3)
subplot(1,2,2)
    plot(beta,x)
    ylabel('Position, x')
    xlabel('beta, [-]')
    hold on
    list_1 = find(beta>bt_point); list_2 = find(beta>top_point);
    top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
    plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
    plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
subplot(1,2,1)
    imagesc(t,flipud(x),Z2b)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Z, Calcium Concentration in the Cytosol 6e-6 diffusion, [\muM]')
    colormap jet
    hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
    
%% Run Electro Diffusion 
D = 6e-6;
dt = 5e-3; t_end = 40; t = 0:dt:t_end;   N = length(t);
dx = 0.5e-3; x = 0:dx:1;   M = length(x); 
beta = (0.5*(1+tanh((x-0.5)/0.3)))';

[ Z3, V3 ] = Gold_Electro_Diffusion( dt, dx, x, t, M, N, Z_0, V_0, Y_0, beta, D);
figure(4)
subplot(1,2,2)
    plot(beta,x)
    ylabel('Position, x')
    xlabel('Beta, [-]')
    hold on
    plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
    plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
subplot(1,2,1)
    imagesc(t,flipud(x),Z3)
    set(gca,'YDir','normal') 
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Z, Calcium Concentration in the Cytosol, [\muM]')
    colormap jet
    hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)

%% View Grid
figure(5)
subplot(1,2,1)
    imagesc(t,flipud(x),Z3)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Z, Calcium Concentration in the Cytosol, [\muM]')
    colormap jet
    hold on
    plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
    plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
subplot(1,2,2)
    h = surf(aa,bb,Z3);
    xlabel('Time, [s]')
    ylabel('Position, x')
    title('Z, Calcium Concentration in the Cytosol, [\muM]')
    colormap jet
    view(2)
    figure_handle = figure(5);
    all_ha = findobj( figure_handle, 'type', 'axes', 'tag', '' );
    linkaxes( all_ha, 'xy');
    set(h, 'edgecolor','k');
save('Results2')
    