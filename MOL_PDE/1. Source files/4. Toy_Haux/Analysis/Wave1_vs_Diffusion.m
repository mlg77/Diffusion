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
Diffusionvalues = [0.1, 3:5,  6:12:1000];
Data_vs_Diffusion = [];
legendentry = {};

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
plot(-Data_vs_Diffusion(:,4), Data_vs_Diffusion(:,1)*10^(-6)./Data_vs_Diffusion(:,2), 'x-b')
y = 30*(-Data_vs_Diffusion(:,4)).^2+0.0447*-Data_vs_Diffusion(:,4) - 9e-6;
hold on
plot(-Data_vs_Diffusion(:,4), y, 'r-')



