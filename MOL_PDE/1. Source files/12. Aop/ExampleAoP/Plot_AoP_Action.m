%% Run the Goldbeter for some 3 beta values to show the AoP for different P
%   Step 1: Run the steady state for the 3 beta
clear; clc; close all
%% Span and Inital Conditions
% Time
t0 = 0;   t1 = 25; dt = 1e-3;
tspan = [t0:dt: t1];

% Space
x = [0.25,0.3, 0.4];    M = length(x); 
mybeta = (x*0.792)';

% Inital Conditions
Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+A_0, x*0+Y_0];

% Diffusion
Diff_type = 1;
D = 0;
display(['Finding Steady State ...'])

% Tolerence
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z0 = y(:, 1:M)';
V = y(:, M+1:2*M)';
Y = y(:, 2*M+1:3*M)';

%% Take steady state results and set to inital conditions
y02 = [Z0(:, end)',V(:, end)' ,Y(:, end)'];
pertibations_to_plot = [0.12, 0.18];
t0 = 0;   t1 = 10; dt = 1e-3;
tspan = [t0:dt: t1];
figure(1)
legendtoadd = {};
colours_po = {'y','m','g','c','r','b'};
for ii = pertibations_to_plot
    y0 = y02;
    y0(1:M) = y0(1:M) + ii;
    display(['Pertibation of ', num2str(ii)])
    [t, y] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    Z = y(:, 1:M)';
    for jj = 1:length(x)
        subplot(1, length(x), jj)
        hold on; 
        plot(t+0.5, Z(jj, :), colours_po{find(ii==pertibations_to_plot,1)}, 'linewidth', 2)
        plot(0.5, y0(jj),[colours_po{find(ii==pertibations_to_plot,1)}, 'x'], 'linewidth', 3)
    end
    legendtoadd{end+1} = num2str(ii);
    legendtoadd{end+1} = '       Z_{SS} + P ';
end

for ii = 1:3
    subplot(1, length(x), ii)
    grid on
    title(['x of ', num2str(x(ii)), '. (\beta = ', num2str(mybeta(ii)) , ' )'])
    legend(legendtoadd)    
    axis([0, 2, 0,3])
    plot([0,0.5], y02(ii)*[1,1], 'k', 'linewidth', 2)
    xlabel('Time, [s]'); ylabel('Calcium Concentration, [\mu M]')
end

%% Do just on position and one of each
for ii = pertibations_to_plot
    figure()
    y0 = y02;
    y0(1:M) = y0(1:M) + ii;
    display(['Pertibation of ', num2str(ii)])
    [t, y] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    Z = y(:, 1:M)';
    jj = 3;
        hold on; 
        plot([0,0.5], y02(3)*[1,1], 'k', 'linewidth', 2)
        plot([0.5, 0.5], [y02(jj), y0(jj)],'r', 'linewidth', 2)
        plot(t+0.5, Z(jj, :), 'b', 'linewidth', 2)
    grid on
    plot(0,0,'g', 'linewidth', 2)
    legend('Steady state solution', 'Perturbation, P', 'Perturbed Solution', 'AoP')    
   
    
    xlabel('Time, [s]'); ylabel('Cytosol Calcium Concentration, [\mu M]')
end

