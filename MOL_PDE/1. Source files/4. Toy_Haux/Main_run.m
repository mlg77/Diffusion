clear; clc; 
close all
clf
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\4. Toy_Haux';
AllDir.SaveDir = '4. Output files\ODE45_solver';

addpath([AllDir.ParentDir, AllDir.SourceDir, '\Analysis']) 
%%
t0 = 0;   t1 = 1000; dt = 0.01;
tspan = [t0:dt: t1];
dx = 1e-3;  
x = (0:dx:1);    M = length(x); 
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
% mybeta = 0.5+0.4*(1+tanh((x-0.5)/0.25))'; % HomoPaper Symetric
% mybeta = 0.4*(1+tanh((x-0.5)/0.25))'; % HomoPaper Front heavy
% mybeta = 0.2*(1+tanh((x-0.5)/0.4))';
mybeta = x';
% mybeta = (0.5*x'+0.25);
x = mybeta';

X_0 = -1; Y_0 = -1; 
% X_0 = 0.5; Y_0 = 0.1; 
y0 = [x*0+X_0, x*0+Y_0];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D =0;% 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z0D = y0D(:, 1:M)';
V0D = y0D(:, M+1:2*M)';

figure(1)
subplot(2,3,1)
        h = imagesc(t,(mybeta),Z0D);
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Beta')
        title(['\Phi Zero Diffusion, [\mu M]'])
        colormap jet
        colorbar
        hold on
%         plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
%         plot([0,1], [bt_pt, bt_pt],  'k','LineWidth',2)

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1; D = 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
% yFD = y0D;
ZFD = yFD(:, 1:M)';
VFD = yFD(:, M+1:2*M)';

subplot(2,3,2)
        imagesc(t,(mybeta),ZFD)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+]_{Cytosol} FD (6x10^{-6}), [\muM]'])
        colormap jet
        colorbar
%         hold on
% %         plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
% %         plot([0,t1, [bt_pt, bt_pt],  'k','LineWidth',2)


    
subplot(2,3,6)
    hold on
    plot(mybeta, max(Z0D(:, round(0.75*t1/dt):end)'), 'b')
    plot(mybeta, max(ZFD(:, round(0.75*t1/dt):end)'), 'r')
    title('bifurcation Diagrams')
    xlabel('beta')
    ylabel('Concentration')
    legend('0D', 'FD')
    plot(mybeta, min(Z0D(:, 0.5*t1/dt:end)'), 'b')
    plot(mybeta, min(ZFD(:, 0.5*t1/dt:end)'), 'r')
    grid on
    
 [ periodarray_Z, periodarraymin, periodarraymax ] = Period_gen( x, t, Z0D);
 [ periodarray_ZFD, periodarraymin_ZFD, periodarraymax_ZFD ] = Period_gen( x, t, ZFD);
subplot(2,3,3)
    hold on
    plot(mybeta, periodarray_Z, 'b')
    plot(mybeta, periodarray_ZFD, 'r')
    plot(mybeta, periodarraymin_ZFD, 'g')
    plot(mybeta, periodarraymax_ZFD, 'k')
    title('period')
    xlabel('beta')
    ylabel('Period')
    legend('0D', 'FD', 'FD min', 'FD max')

[ Wave0D, BW_0D,t_wave0D ] = OneWave( Z0D,t, x, 0.7);
subplot(2,3,4:5)
    hold on
    plot(t_wave0D, Wave0D, 'b')
    plot(t_wave0D, BW_0D, 'r')
    title('Do waves overlap?')
    xlabel('time')
    ylabel('one wave')
    legend('Forward', 'Backward')

%% Plot Giff
% RunInTimePlot( Z0D,ZFD, t,x, 'uh', 0, 0, [50, 80], [0.3, 0.8], 0.01)
% Limit_cycles( Z0D,V0D, t, x, 1, 'uh', 0, [50, 80], [-0.2, 0.4, 0.8, 1], 1.5, 0.01)
% time_quad = Time_in_Quad(  Z0D,V0D, t, x, [30, 95], [-0.2, 0.4, 0.8, 1])


%% Plot Follow wave
% Note wont plot the 16th wave as it comes back in
figure()
wave_nu_legend = {};
for jj = 1:15
    [ wave_data ] = Follow_wave( ZFD, x, t, 0.55, jj, 120 );
    subplot(1,2,1)
    grid on
    hold on
    plot(wave_data.t, wave_data.po)
    
    % Plot the gradient of the waves
    % Change in position over the change in time
    rate_change_wave = (wave_data.po(1:end-1)- wave_data.po(2:end))./(wave_data.t(1:end-1) - wave_data.t(2:end));
    subplot(1,2,2)
    grid on
    hold on
    plot(wave_data.t(1:end-1) , rate_change_wave)

    wave_nu_legend{end+1} = num2str(jj);
end
subplot(1,2,1); title('Wave Fronts'); xlabel('Time'); ylabel('Position')
subplot(1,2,2); title('rate of change of Wave Fronts'); xlabel('Time'); ylabel('\Delta Position/\Delta time')
legend(wave_nu_legend)

