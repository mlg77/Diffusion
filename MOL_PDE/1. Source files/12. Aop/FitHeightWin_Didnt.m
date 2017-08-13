% Fit Height Win!!!!

%% Fit Height Error 
%   Fit the height of the actual solution to the PDE on the AoP grid
%   Consider the reduction in height 
%   Steps:
%       1) Load and plot AoP grid
%       2) Run prediction of first line
%       3) Run one simulation of the Dupont
%       4) Follow the waves on Dupont including height
%       5) Fit height on AoP
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

%% Step 3: Run one simulation of the Dupont
t0 = 0;   t1 = 30; dt = 5e-4;
dx = 1e-3;  
x = 0:dx:1;    
Diff_type = 1; 
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
% mybeta = x'*0.792;
mybeta = (0.1980/0.5*x+0.1980)';
Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
y0 = [Z_0+ x*0, A_0+ x*0, Y_0+ x*0];

% Run Dupont
prerun = 0;
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
    
    D = 6e-6;
    [t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    ZFD = yFD(:, 1:M)';
    
    cd(dirs.save_file)
    save('OneRunDupont1', 't', 'ZFD', 'Z0D', 'mybeta');
%     save('OneRunDupont', 't', 'ZFD', 'Z0D'); % Use 1,2,3,4 different beta profiles
    cd(dirs.this_file)
end

figure(2); 
subplot(1,2,1); imagesc(t,flipud(x),Z0D)
    set(gca,'YDir','normal');  colormap jet
    xlabel('Time, [s]'); ylabel('Position, x'); title('Solution to ODE');
subplot(1,2,2); imagesc(t,flipud(x),ZFD)
    set(gca,'YDir','normal');  colormap jet
    xlabel('Time, [s]'); ylabel('Position, x'); title('Solution to PDE');

    
betas_coll = position_x'*0.792;
NewBetastuff = mybeta(1:length(betas_coll));
reordered_AoP = Aop*0;
for kk = 1:length(NewBetastuff)
    if isnan(NewBetastuff(kk) )
        reordered_AoP(kk,:) = Aop(1, :)*nan;
    elseif isempty(find(NewBetastuff(kk)<=betas_coll))
        reordered_AoP(kk,:) = Aop(1, :)*nan;
    else
        reordered_AoP(kk,:) = Aop(find(NewBetastuff(kk)<=betas_coll,1), :);
    end
end
Aop = reordered_AoP;

%% Plot different wave numbers
figure(1)
for wvae_no = [1,2,3,4]
    subplot(1,4,wvae_no)
%% Plot contour
[C,h1] = contourf(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20); hold on;
[C,h2] = contour(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20);
axis([0,0.5,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
title(['AoP(P, x), Wave Front number = ', num2str(wvae_no)] )
%% Step 2: Run prediction of first line
D = 6e-6;
a1a2a3a4 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
a1a2a3a4 = [-0.025573737362939, 0.02, 0.063408766383566, 0.067664806911860];
a = (a1a2a3a4(1)*log(D*1e6) + a1a2a3a4(2));
b = (a1a2a3a4(3)*log(D*1e6) + a1a2a3a4(4));
f_1 =  a*log(wvae_no) + b; % Wave 1
[ x_P, P ] = predict_depth_ex6( Aop, perts, [0:1e-3:1], 0.499, f_1, 1 );
idx_end = find(P<=1e-6,1);
plot(P(2:idx_end), x_P(2:idx_end), 'r', 'linewidth', 2)
mylegend{1} = 'Predicted Line 1';

%% Step 4: Follow the waves on Dupont including height + Steady state vector 

% wave_data = struct [position, time, magnatude]
[ wave_data ] = Follow_wave( ZFD, x, t, 0.5, wvae_no, [3,2] );
Z_SS = max(Z0D(1:length(position_x), floor(length(t)*3/4):end)')';

P_diff = 0.001;
P_at2_max = [];
P_at2 = [];
P_at2_min = [];

for ii = 1:length(wave_data.po)
        % Step 1: compare 
    x_indx_at = length(position_x)+1-ii;
    p_indx_at1 = find((Aop(x_indx_at, :)+perts + Z_SS(x_indx_at))>=wave_data.mag(ii),1);
    AoP_at1 = Aop(x_indx_at, p_indx_at1);
    % Step 2: Translate to other AoP value
%     vect_1 = Aop(end+1-ii, :) >= (1-P_diff)*Aop(end+1-ii, find(perts >= P(ii), 1));
%     vect_2 = Aop(end+1-ii, :) <= (1+P_diff)*Aop(end+1-ii, find(perts >= P(ii), 1));
    vect_1 = Aop(end+1-ii, :) >= (1-P_diff)*AoP_at1;
    vect_2 = Aop(end+1-ii, :) <= (1+P_diff)*AoP_at1;
    idx_perts = double(vect_1 == vect_2);
    grad_idx_pert = idx_perts(2:end)- idx_perts(1:end-1);
    beg_ones = find(grad_idx_pert>0);
    if length(beg_ones) >=  2
        idx_perts(1:beg_ones(2)) = 0;
    elseif length(beg_ones) == 1 || isempty(beg_ones)
        % Do nothing
    else
        % catch
        beg_ones
        ii
        error('begining of ones catch')
    end
    P_at2(ii) = mean(perts.*idx_perts);
    P_at2_max(ii) = max(perts.*idx_perts);
    P_at2_min(ii) = min(perts.*idx_perts);
  
end

figure(1); subplot(1,4,wvae_no)
plot(P_at2(3:end), wave_data.po(3:end), 'k', 'linewidth', 2)
plot(P_at2_max(3:end), wave_data.po(3:end), 'k:', 'linewidth', 2)
plot(P_at2_min(3:end), wave_data.po(3:end), 'k:', 'linewidth', 2)
mylegend{2} = 'Actual Height on Right side of hump';
% legend(mylegend)
end


