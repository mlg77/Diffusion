% ODE45s solver 
% Author: Michelle Goodman
% Date: 5/4/16

clear; clc; close all; 
tic
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\2. ToyModel_Compatable';
AllDir.SaveDir = '4. Output files\ODE45_solver';
%% Span and Inital Conditions
t0 = 0;   t1 = 50; dt = 0.0025;
tspan = [t0:dt: t1];
tspan = [t0, t1];
dx = 1e-3;  
x = 0:dx:1;    M = length(x); 
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
mybeta = x';

mybeta = [-2:2/(M-1):0]';
% mybeta = [-0.4:0.4/(M-1):0]';
% mybeta = [-2:2/(M-1):0]';
% mybeta = [0 :0.25/(M-1):0.25]';
%% Beta 0, linear, 0
% mybeta = (x-0.2)';
% mybeta(1:301) = 0; mybeta(801:end) = 0;

%% Beta fix?
% start_fixed_beta = find(x== 0.162);
% fixed_beta = mybeta(start_fixed_beta);
% mybeta(find(x== 0.156):start_fixed_beta) = fixed_beta;

Z_0 = -1; V_0 = 2; 
y0 = [x*0+Z_0, x*0+V_0];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1;

%% Amount of Diffusion
D =  0;%  1e-6; %  0;% 
display(['Diffusion = ', num2str(D)])
%%
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y] = ode45(@(t,y) odefun_Toy(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z = y(:, 1:M)';
V = y(:, M+1:2*M)';



bt_point = 0.5;  top_pt = 0.5; top_point = 0; bt_pt = 0;
t_end = t(end);
figure(1)
    subplot(1,2,2)
        plot(mybeta,x)
        ylabel('Position, x')
        xlabel('beta, [-]')
        hold on
%         plot([0, 0, 0], [0, 0.2,0.2], 'k','LineWidth',2)
        plot([-0.2,-0.2,0], [0, 0.5,0.5],  'k','LineWidth',2)
    subplot(1,2,1)
% figure()
        imagesc(t,x,Z)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+], Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
%         plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
display(['Simulation complete: ', num2str(toc), ' seconds'])

%% Find Fluxes
% % break
L_Z=[]; L_V=[]; v_2=[]; v_3=[]; d2Zdx2 = [];
for j = 1:length(t) % Loop through each time to find L, v2 and v3
    [ dydt , L_Zt, L_Vt, d2Zdx2t] = odefun_Toy( j, y(j,:)' , mybeta, 1, D);
    L_Z(:, j) = L_Zt;
    L_V(:, j) = L_Vt;
    d2Zdx2(:, j) = d2Zdx2t; 
end
display(['Fluxes Found: ', num2str(toc), ' seconds'])
% % cd([AllDir.ParentDir ,AllDir.SaveDir])
% % save('SD_data_ode')
% % cd([AllDir.ParentDir, AllDir.SourceDir])

%% Plot at different x values
xval= [0.1,0.4, 0.6, 0.9];
figure(2)
for i = 1:length(xval)
    subplot(2,4,i)
    plot(t, Z(xval(i)*1000+1,:))
    title(['x = ', num2str(xval(i))])
end
%% Is symetrical??    
checkZ = xval(3)*1000+1;
[pks, loc] = findpeaks(Z(checkZ,:));
% Use second peek
subplot(2,1,2)
hold on
plot(Z(checkZ, loc(2):loc(3)), 'b')
plot(Z(checkZ, loc(2):-1:loc(1)), 'r')
title('Is symetrical?? Do they overlap?')
legend('Forward', 'Backward')
