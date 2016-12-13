% ODE45s solver 
% Author: Michelle Goodman
% Date: 5/4/16

clear; clc; close all; 
tic
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.SaveDir = '4. Output files\OralPresentation';
%% Span and Inital Conditions
prompt = 'What sections? Produce/plot: ';
mystr = input(prompt,'s');

acceptable = [{'Produce'}, {'plot'}];
while ismember(mystr,acceptable) == 0
    display('Choose again! Check correct captles')
    mystr = input(prompt,'s');
end

if strcmp(mystr, 'Produce')
t0 = 0;   t1 = 100; dt = 0.005;
tspan = [t0:dt: t1];
dx = 1e-3;  
x = 0:dx:1;    M = length(x); 
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
% mybeta = (x*0.56)';
% mybeta = x';
% start_fixed_beta = find(x== 0.162);
% fixed_beta = mybeta(start_fixed_beta);
% mybeta(find(x== 0.156):start_fixed_beta) = fixed_beta;

Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D =0;% 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z0D = y0D(:, 1:M)';
V0D = y0D(:, M+1:2*M)';
Y0D = y0D(:, 2*M+1:3*M)';

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D = 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, yFD] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

ZFD = yFD(:, 1:M)';
VFD = yFD(:, M+1:2*M)';
YFD = yFD(:, 2*M+1:3*M)';

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 2; D = 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, yED] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

ZED = yED(:, 1:M)';
VED = yED(:, M+1:2*M)';
YED = yED(:, 2*M+1:3*M)';
display(['Simulation complete: ', num2str(toc), ' seconds'])
cd([AllDir.ParentDir ,AllDir.SaveDir])
save('All_data_ode')
cd([AllDir.ParentDir, AllDir.SourceDir])
end

My_plot_report(AllDir)
% My_plot(AllDir)

% bt_point = 0.8;  top_pt = 0.8470; top_point = 0.28; bt_pt = 0.2640;
% t_end = t(end);
% figure(1)
%     subplot(1,2,2)
%         plot(mybeta,x)
%         ylabel('Position, x')
%         xlabel('beta, [-]')
%         hold on
%         list_1 = find(mybeta>bt_point); list_2 = find(mybeta>top_point);
%         top_pt = x(list_1(1)) ; bt_pt = x(list_2(1));
%         plot([bt_point, bt_point, 0], [0, top_pt, top_pt], 'k','LineWidth',2)
%         plot([top_point, top_point, 0], [0, bt_pt, bt_pt],  'k','LineWidth',2)
%     subplot(1,2,1)
% % figure()
%         imagesc(t,flipud(x),Z)
%         set(gca,'YDir','normal')
%         xlabel('Time, [s]')
%         ylabel('Position, x')
%         title(['[Ca^2^+], Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
%         colormap jet
%         hold on
%         plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
%         plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)


% cd([AllDir.ParentDir ,AllDir.SaveDir])
% save('SD_data_ode')
% cd([AllDir.ParentDir, AllDir.SourceDir])

    
