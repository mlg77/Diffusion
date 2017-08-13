%% Fit Height Error 
%   Fit the height of the actual solution to the PDE on the AoP grid
%   Consider the reduction in height 
%   Steps:
%       1) Load and plot AoP grid
%       2) Run prediction of first line
%       3) Run one simulation of the Dupont
%       4) Follow the waves on Dupont including height
%       5) Fit height plot as go to start to correct aop position
% Author: Michelle Goodman
% Date: 13/6/2017

clear; clc; close all
%% Step 1: Load and plot AoP grid
dirs.this_file = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Dupont';
cd(dirs.save_file)
load('sen_perts_data_full')
cd(dirs.this_file)

position_x = 0:1e-3:0.5;
Aop = [];
for ii = 1:length(position_x)
    Aop(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end
betas_coll = position_x*0.792;
Aop(find(Aop <= 1e-7)) = 0;
lastpertcare = find(perts >=0.5, 1);
myColorMap = summer; 
myColorMap(1, :) = [1 1 1];

figure(50)
[C,h1] = contourf(perts(1:lastpertcare), betas_coll, Aop(:, 1:lastpertcare), 20); hold on;
[C,h2] = contour(perts(1:lastpertcare), betas_coll, Aop(:, 1:lastpertcare), 20);
xlabel('Pertibations'); ylabel('Beta, \beta [-]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false);

% Plot
figure(1)
[C,h1] = contourf(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20); hold on;
[C,h2] = contour(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20);
axis([0,0.5,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
title('Contour Plot of AoP grid of (P, x)')

%% Step 2: Run prediction of first line
D = 4e-6;
a1a2a3a4 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
a = (a1a2a3a4(1)*log(D*1e6) + a1a2a3a4(2));
b = (a1a2a3a4(3)*log(D*1e6) + a1a2a3a4(4));
f_1 =  a*log(1) + b; % Wave 1
[ x_P, P ] = predict_depth_ex6( Aop, perts, [0:1e-3:1], 0.499, f_1, 1 );
idx_end = find(P<=1e-6,1);
plot(P(2:idx_end), x_P(2:idx_end), 'r', 'linewidth', 2)
for ii = 1:length(x_P)
    idx_P = find(perts>= P(ii), 1);
    aop_P(ii) = Aop(end-ii+1, idx_P);
end
mylegend{1} = 'Predicted Line 1';

%% Step 3: Run one simulation of the Dupont
t0 = 0;   t1 = 30; dt = 5e-4;
dx = 1e-3;  
x = 0:dx:1;    
Diff_type = 1; 
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
mybeta = x'*0.792;
Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
y0 = [Z_0+ x*0, A_0+ x*0, Y_0+ x*0];

% Run Dupont
prerun = 1;
set_to_ss = 1;
if prerun == 1
    cd(dirs.save_file)
    load('OneRunDupont');
    cd(dirs.this_file)
else
    D = 0;
    [t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    Z0D = y0D(:, 1:M)';
    A0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M + 1:3*M)';
    
    D = 4e-6;
    [t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    ZFD = yFD(:, 1:M)';
    
    cd(dirs.save_file)
    save('OneRunDupont', 't', 'ZFD', 'Z0D');
    cd(dirs.this_file)
end

figure(2); 
subplot(1,2,1); imagesc(t,flipud(x),Z0D)
    set(gca,'YDir','normal');  colormap jet
    xlabel('Time, [s]'); ylabel('Position, x'); title('Solution to ODE');
subplot(1,2,2); imagesc(t,flipud(x),ZFD)
    set(gca,'YDir','normal');  colormap jet
    xlabel('Time, [s]'); ylabel('Position, x'); title('Solution to PDE');

%% Step 4: Follow the waves on Dupont including height + Steady state vector 

% wave_data = struct [position, time, magnatude]
[ wave_data ] = Follow_wave( ZFD, x, t, 0.5, 1, [3,2] );
Z_SS = max(Z0D(1:length(position_x), floor(length(t)*3/4):end)')';

%% Third try create grid of possible aops 

% Grid_available_aop = [];
% for ii = 3 :length(wave_data.po)
%     % Step 1: Find Aop of actual point
%     idx_P = find(Aop(end+1-ii, :)+perts + Z_SS(end+1-ii)>wave_data.mag(ii), 1);
%     Aop_point = Aop(end+1-ii, idx_P);
%     % Find when that aop range apperar on the aop grid
%     pm_n = 0.03;
%     vect_1 = Aop(end+1-ii, :) <= (1 + pm_n) * Aop_point;
%     vect_2 = Aop(end+1-ii, :) >= (1 - pm_n) * Aop_point;
%     
%     actual_range = floor((vect_1 + vect_2)*0.5);
%     
%     Grid_available_aop(ii, :) = actual_range;
%     
%     
% %     plot(perts, Aop(end+1-ii, :), 'x-'); hold on;
% %     plot(perts, Aop_point + perts*0)
% %     hold off; axis([0,0.5,1,1.6]); title(num2str(wave_data.po(ii)))
% %     pause()
% end
% 
% figure(); imagesc(perts,wave_data.po, Grid_available_aop)
% set(gca,'YDir','normal'); set(gca,'layer','top');
% axis([0,0.5,0,0.5])

%% New try
figure(); hold on
height_aop = aop_P+P+flipud(Z_SS(1:length(P)))'; % Predicted
height_aop = height_aop(2:end);
idx_end = find(height_aop<=0.5, 1)-2;
plot(wave_data.po, wave_data.mag) % actual 
plot(x_P(2:idx_end+1), height_aop(1:idx_end)); % Predicted

%wave_data.mag(2:idx_end+1) - height_aop(1:idx_end)
% median of -0.26061 difference (- outlyer) ie the actual height is lower
figure(); boxplot(wave_data.mag(2:idx_end+1) - height_aop(1:idx_end))
% by 0.26061 6e-6
% by 0.333 8e-6
% by 0.2212 4e-6

% Loop through actual data and find aop value
Grid_available_aop = [];
eddit_f = 0.212; % 4e-6
for ii = 3 :length(wave_data.po)
    % Step 1: Find Aop of actual point
    idx_P = find(Aop(end+1-ii, :)+perts + Z_SS(end+1-ii)>=wave_data.mag(ii) + eddit_f, 1);
    Aop_point = Aop(end+1-ii, idx_P);
    % Find when that aop range apperar on the aop grid
    pm_n = 0.005;
    vect_1 = Aop(end+1-ii, :) <= (1 + pm_n) * Aop_point;
    vect_2 = Aop(end+1-ii, :) >= (1 - pm_n) * Aop_point;
    
    actual_range = floor((vect_1 + vect_2)*0.5);
    mid_aop_P(ii) = perts(idx_P);
    Grid_available_aop(ii, :) = actual_range;
end

Grid_available_aop(find(isnan(Grid_available_aop))) = 0;
% figure(); imagesc(perts,wave_data.po, Grid_available_aop)

figure(99)
myColorMap = summer; 
myColorMap(1, :) = [1 1 1];
myColorMap(end, :) = [1 0 0];

Grid_to_Plot = Aop(:, 1:lastpertcare);
highest_no = max(max(Grid_to_Plot)) + 0.1;
Grid_to_Plot(end:-1:end+1-size(Grid_available_aop, 1), :) = Grid_to_Plot(end:-1:end+1-size(Grid_available_aop, 1), :) + highest_no*Grid_available_aop;
Grid_to_Plot(find(Grid_to_Plot>= highest_no)) = highest_no;
Grid_to_Plot(end-1:end, :) = highest_no;

[C,h1] = contourf(perts(1:lastpertcare), position_x, Grid_to_Plot,20); hold on;
[C,h2] = contour(perts(1:lastpertcare), position_x, Grid_to_Plot, 20);
axis([0,0.5,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false); hasbehavior(h2, 'legend', false); 
title('Contour Plot of AoP grid of (P, x)')
hold on; plot(P(2:idx_end), x_P(2:idx_end), 'k', 'linewidth', 2)
plot(mid_aop_P, wave_data.po, 'k:', 'linewidth', 2)
legend('Predicted Trijectory', 'Actual height translated to AoP')
plot([0,0.2348], [1,1]*0.357, 'k-', 'linewidth', 2)
plot([0,0.2425], [1,1]*0.356, 'k:', 'linewidth', 2)