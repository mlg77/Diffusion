%Wave1_vs_Diffusion Different factors for the first wave against diffusion
%   Simulates the toy model with different diffusion's plots relationships
%   Expirement wave front 1 vs diffusion

clear; clc; close all

% Set up parameters for simulation 
t0 = 0;   t1 = 600; dt = 0.01;
tspan = [t0:dt: t1];
dx = 1e-3;  
xbase = (0:dx:1)';    M = length(xbase); 
Diff_type = 1;  D = 1e-6;
xbase = xbase*0.75;
beta_eqn = @(beta_grad) ((xbase-0.5)./ beta_grad) +0.5;

X_0 = 0.5; Y_0 = 0.1; 
y0 = [xbase*0+X_0, xbase*0+Y_0];

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

% Different Diffusion types loop parameters
DiffusionGradvalues = [0.4:0.1:1.1];
Data_vs_Diffusion = [];
legendentry = {};

for jj = DiffusionGradvalues
    figure(1);
    % Simulate with different gradients of diffusion
    mybeta = beta_eqn(jj);
    [min(mybeta), max(mybeta)]
    
    display(['Diffusion = ', num2str(jj)])
    [tt, yyFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    ZZFD = yyFD(:, 1:M)';
    VVFD = yyFD(:, M+1:2*M)';

    % Plot the first wave
    [ wave_data ] = Follow_wave( ZZFD, mybeta, tt, 0.6, 1, 120 );
    subplot(3,2,1)
    grid on
    hold on
    plot(wave_data.t, wave_data.po)
    legendentry{end+1} = [num2str(jj)];
    
    % Plot rate of change (Wave speed)
    rate_change_wave = (wave_data.po(1:end-1)- wave_data.po(2:end))./(wave_data.t(1:end-1) - wave_data.t(2:end));
    subplot(3,2,2)
    grid on
    hold on
    plot(wave_data.t(1:end-1) , rate_change_wave)
    
    % penetration depth vs Diffusion
    Data_vs_Diffusion(end+1,1) = jj; % Diffusion Gradient
    Data_vs_Diffusion(end,2) = min(wave_data.po); % Penetration Depth
    Data_vs_Diffusion(end,3) = max(wave_data.t); % Time at penetration Depth
    Data_vs_Diffusion(end,4) = max(rate_change_wave(2:end)); % Rate of change of wave speed
    
    figure(2)
    subplot(3,4,find(DiffusionGradvalues==jj))
        h = imagesc(tt,(mybeta),ZZFD);
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('x')
        title(num2str(jj))
        colormap jet
        colorbar
        hold on
        axis([0,600,0.25,0.75])
        
    subplot(3,1,3)
        hold on 
        plot(xbase, mybeta)
        
end

figure(2)
axis([0.25,0.75, 0.25,0.75])
xlabel('\Beta'); ylabel('position')
title('Gradient Beta to x Profile')
legend(legendentry)

figure(1);
subplot(3,2,1); title('First wave plotted for different gradient of diffusion')
xlabel('Time'); ylabel('Position')
legend(legendentry)

subplot(3,2,2); title('First wave wave speed for different gradient of diffusion')
xlabel('Time'); ylabel('\Delta Position/ \Delta Time')

subplot(3,2,3); 
plot(Data_vs_Diffusion(:,1), Data_vs_Diffusion(:,2), 'xb:')
title('Penetration Depth vs diffusion gradient')
xlabel('Diffusion gradient'); ylabel('Penetration Depth')

subplot(3,2,4); 
plot(Data_vs_Diffusion(:,1), Data_vs_Diffusion(:,4), 'xb:')
title('Max wave speed vs diffusion gradient')
xlabel('Diffusion gradient'); ylabel('Wave Speed')

subplot(3,2,5:6); 
plot(Data_vs_Diffusion(:,2), Data_vs_Diffusion(:,4), 'xb:')
title('Max wave speed vs Penetration depth')
xlabel('Penetration Depth'); ylabel('Wave Speed')


%% Adjusted Line 
% when beta = 1 the position equals beta and penetrates to a depth of 
figure(2); subplot(3,1,3); 
idx_equal = find(Data_vs_Diffusion(:,1)==1)
plot([0.25,Data_vs_Diffusion(idx_equal,2)], [Data_vs_Diffusion(idx_equal,2), Data_vs_Diffusion(idx_equal,2)], ':k', 'linewidth', 2)
plot([Data_vs_Diffusion(idx_equal,2), Data_vs_Diffusion(idx_equal,2)], [0.25, 0.75], 'k', 'linewidth', 2)


count = 1;
for jj = DiffusionGradvalues
    mybeta = beta_eqn(jj);
    Data_vs_Diffusion(count, 5) = xbase(find(mybeta >= Data_vs_Diffusion(idx_equal,2), 1 ));
    count = count + 1;
end

figure(3)
hold on
plot(Data_vs_Diffusion(:,1), Data_vs_Diffusion(:,2), 'xb:')
plot(Data_vs_Diffusion(:,1), Data_vs_Diffusion(:,5), 'xr:')
title('Expected penetration depth')
xlabel('Diffusion gradient'); ylabel('Penetration Depth')
legend('Actual', 'Expected')