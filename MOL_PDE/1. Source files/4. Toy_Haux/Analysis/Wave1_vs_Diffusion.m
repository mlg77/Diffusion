%Wave1_vs_Diffusion Different factors for the first wave against diffusion
%   Simulates the toy model with different diffusion's plots relationships
%   Expirement wave front 1 vs diffusion

clear; clc; close all

% Set up parameters for simulation 
t0 = 0;   t1 = 600; dt = 0.01;
tspan = [t0:dt: t1];
dx = 1e-3;  
x = (0:dx:1);    M = length(x); 
mybeta = (0.5*x'+0.25);
x = mybeta';

X_0 = 0.5; Y_0 = 0.1; 
y0 = [x*0+X_0, x*0+Y_0];

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

% Different Diffusion types loop parameters
Diffusionvalues = [3:3:20, 30:10:100 150:50:1000];%,  [3:3:20, 30:10:100 150:50:1000];
Data_vs_Diffusion = [];
legendentry = {};

% Three x points crossing the bifurcation point x=0.5 +/- dx of data for
% each diffusion value
Above_Bi_Z_data = [];
At_Bi_Z_data = [];
Below_Bi_Z_data = [];


for jj = Diffusionvalues
    figure(1);
    % Simulate with different diffusion
    Diff_type = 1; D = jj*10^-6;%  0;%
    display(['Diffusion = ', num2str(D)])
    [tt, yyFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    ZZFD = yyFD(:, 1:M)';
    VVFD = yyFD(:, M+1:2*M)';

    % Plot the first wave
    [ wave_data ] = Follow_wave( ZZFD, x, tt, 0.6, 1, 120 );
    subplot(3,2,1)
    grid on
    hold on
    plot(wave_data.t, wave_data.po)
    legendentry{end+1} = [num2str(jj), 'x10^{-6} cm^2/s'];
    
    % Plot rate of change (Wave speed)
    rate_change_wave = (wave_data.po(1:end-1)- wave_data.po(2:end))./(wave_data.t(1:end-1) - wave_data.t(2:end));
    subplot(3,2,2)
    grid on
    hold on
    plot(wave_data.t(1:end-1) , rate_change_wave)
    
    % penetration depth vs Diffusion
    Data_vs_Diffusion(end+1,1) = jj; % Diffusion
    Data_vs_Diffusion(end,2) = min(wave_data.po); % max Penetration depth
    Data_vs_Diffusion(end,3) = max(wave_data.t); % Time at end
    Data_vs_Diffusion(end,4) = max(rate_change_wave); % wave speed
    Data_vs_Diffusion(end,5) = mybeta(find(min(wave_data.po)==wave_data.po)); % beta at depth
    
    Above_Bi_Z_data(end+1, :) = ZZFD(502,:);
    At_Bi_Z_data(end+1, :) = ZZFD(501,:);
    Below_Bi_Z_data(end+1, :) = ZZFD(500,:);
    
%     figure(2)
%     subplot(3,4,find(Diffusionvalues==jj))
%         h = imagesc(tt,(mybeta),ZZFD);
%         set(gca,'YDir','normal')
%         xlabel('Time, [s]')
%         ylabel('Beta')
%         title(['\Phi Zero Diffusion, [\mu M]'])
%         colormap jet
%         colorbar
%         hold on
end

figure(1);
subplot(3,2,1); title('First wave plotted for different diffusion')
xlabel('Time'); ylabel('Position')
legend(legendentry)

subplot(3,2,2); title('First wave wave speed for different diffusion')
xlabel('Time'); ylabel('\Delta Position/ \Delta Time')

subplot(3,2,3); 
plot(Data_vs_Diffusion(:,1), Data_vs_Diffusion(:,2), 'xb:')
title('Penetration Depth vs diffusion')
xlabel('Diffusion x10^{-6}cm^2/s'); ylabel('Penetration Depth')

subplot(3,2,4); 
plot(Data_vs_Diffusion(:,1), Data_vs_Diffusion(:,4), 'xb:')
title('Max wave speed vs diffusion')
xlabel('Diffusion x10^{-6}cm^2/s'); ylabel('Wave Speed')

subplot(3,2,5:6); 
plot(Data_vs_Diffusion(:,2), Data_vs_Diffusion(:,4), 'xb:')
title('Max wave speed vs diffusion')
xlabel('Diffusion x10^{-6}cm^2/s'); ylabel('Wave Speed')

%% Relationship Suggested by Tim
% Penetration depth times diffusion = velocity
figure()
subplot(1,2,1)
plot(-Data_vs_Diffusion(:,4), Data_vs_Diffusion(:,1)*10^(-6)./Data_vs_Diffusion(:,2), 'x-b')
% y = 30*(-Data_vs_Diffusion(:,4)).^2+0.0447*-Data_vs_Diffusion(:,4) - 9e-6;
hold on; grid on
% plot(-Data_vs_Diffusion(:,4), y, 'r-')
xlabel('Wave Speed at end of penetrating wave [L/T]')
ylabel('Diffusion/Penetration Depth [L/T]')

subplot(1,2,2)
loglog(-Data_vs_Diffusion(:,4), Data_vs_Diffusion(:,1)*10^(-6)./Data_vs_Diffusion(:,2), 'x-b')
% y = 30*(-Data_vs_Diffusion(:,4)).^2+0.0447*-Data_vs_Diffusion(:,4) - 9e-6;
hold on; grid on
% plot(-Data_vs_Diffusion(:,4), y, 'r-')
xlabel('Wave Speed at end of penetrating wave [L/T]')
ylabel('Diffusion/Penetration Depth [L/T]')
title('log log plot')

%% Does the rate of change at the bifurcation point indicate depth of penetration?
% first lets plot some of the concentration shapes
figure()
rate_change_Z_at_bi_below = (At_Bi_Z_data-Below_Bi_Z_data)/dx;
rate_change_Z_at_bi_above = (At_Bi_Z_data-Above_Bi_Z_data)/dx;
Second_rate_change_Z_at_bi = (rate_change_Z_at_bi_above - rate_change_Z_at_bi_below)/dx;

for ii = 1:length(Diffusionvalues)
    subplot(2,3,1); plot(tt, At_Bi_Z_data(ii, :)); hold on;
    subplot(2,3,2); plot(tt, rate_change_Z_at_bi_below(ii,:)); hold on;
    subplot(2,3,3); plot(tt, Second_rate_change_Z_at_bi(ii,:)); hold on;
end
subplot(2,3,1); axis([0,150,-2.5,2]); xlabel('time'); ylabel('Wave1 Concentration')
subplot(2,3,2); axis([0,150,-800,800]); xlabel('time'); ylabel('Wave1 d/dx(Concentration)')
subplot(2,3,3); axis([0,150,-1.5e6,1.5e6]);  xlabel('time'); ylabel('Wave1 d^2/dx^2(Concentration)')

legend(legendentry)
idx_firstwave = find(tt>=150,1);
max_rate_change_region = max(transpose(rate_change_Z_at_bi_below(:, 1:idx_firstwave)));
subplot(2,3,4); plot(max_rate_change_region, Data_vs_Diffusion(:,2))
xlabel('Max Wave1 d/dx(Concentration)'); ylabel('Penetration Depth')

max_second_rate_change_region = max(transpose(Second_rate_change_Z_at_bi(:, 1:idx_firstwave)));
subplot(2,3,5); plot(max_second_rate_change_region, Data_vs_Diffusion(:,2))
xlabel('Max Wave1 d^2/dx^2(Concentration)'); ylabel('Penetration Depth')

subplot(2,3,6); loglog(max_rate_change_region, Data_vs_Diffusion(:,2))
xlabel('Max Wave1 d/dx(Concentration)'); ylabel('Penetration Depth')
grid on; title('log log plot')

figure()
subplot(1,3,1); plot(max_rate_change_region.*Diffusionvalues, Data_vs_Diffusion(:,2))
xlabel('D* Max Wave1 d/dx(Concentration)'); ylabel('Penetration Depth'); grid on

subplot(1,3,2); plot(max_second_rate_change_region.*Diffusionvalues, Data_vs_Diffusion(:,2))
xlabel('D* Max Wave1 d^2/dx^2(Concentration)'); ylabel('Penetration Depth'); grid on

subplot(1,3,3); loglog(max_rate_change_region.*Diffusionvalues, Data_vs_Diffusion(:,2))
xlabel('D* Max Wave1 d/dx(Concentration)'); ylabel('Penetration Depth')
grid on; title('log log plot')





