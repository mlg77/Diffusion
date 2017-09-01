%% Aop Dealing
% Four functions:
%   1) Load and create AoP grid
%   2) Run the function multiple times recording the actual depth / load
%   3) Run the predicted depth for potential rates /load 
%   4) Fit the rate equation chosen 
%   Author: Michelle Goodman
%   Date: 6/5/17

clear; clc; close all
dirs.this_file = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
% dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability';
dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Archive_PreThesis\Stability\Dupont';
%% Step 1 Load data and convert to AoP, Plot
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

%% Step 2 
% Run 5 different diffusion values and record the first 10 points plot each
% one just to make sure. Save this data so that only need to run once and
% load it each other time
pre_run = 1;
if pre_run == 0
    DepthData = [];
    for ii = 1:0.5:10%[1,2,4,6,8,10]
        D_WvaeNo_Depth = Dupont_run_forD( ii*1e-6);
        DepthData = [DepthData; D_WvaeNo_Depth];
    end
    cd(dirs.save_file)
    save('Actual_Depths', 'DepthData')
    cd(dirs.this_file)
else
    cd(dirs.save_file)
    load('Actual_Depths')
    cd(dirs.this_file)
end

%% Step 3 create a rate vs predicted depth data
% Now choose the itterative process
% P(beta_{b-2}) = (AoP( P(beta_{b-1}), beta_{b-2}))*Rate
% or
% P(beta_{b-2}) = (AoP( P(beta_{b-1}), beta_{b-2})+ P(beta_{b-1}))*Rate

Rate_v_depth = [0:0.0005:0.5]';
for ii = 1:length(Rate_v_depth)
    Pertibation = 0.2;
    Pert_po_Aop = [];
    for jj = 1:length(position_x)
        Pertibation_idx = find( perts >= Pertibation, 1);
        if isempty(Pertibation_idx)
            break
        end
        Pert_po_Aop(1:3) = [Pertibation, position_x(end-jj+1), Aop(end-jj + 1,Pertibation_idx)];
%         Pertibation = Pert_po_Aop(3)*Rate_v_depth(ii);
        Pertibation = (Pert_po_Aop(3)+ Pert_po_Aop(1))*Rate_v_depth(ii);
        if Pert_po_Aop(3) <= 1e-4
            % Found depth 
            break
        end
    end
    if isempty(Pertibation_idx)
            break
    end
    Rate_v_depth(ii, 2) = Pert_po_Aop(2)+1e-3;
end
figure(); plot(Rate_v_depth(:,1), Rate_v_depth(:,2))
xlabel('Rate'); ylabel('Depth reached')

%% Step 4 Given Steps 2 and 3 we know the rate needed to reach the specific 
% depth and the actual depth required fit the trend to find a1, a2, a3, a4

for ii = 1:length(DepthData)
    idx_depth = find(Rate_v_depth(:, 2) <= DepthData(ii, 3),1);
    DepthData(ii, 4) = Rate_v_depth(idx_depth, 1);
end
% DepthData is now [Diffusion, wave number, depth, raterequired]

%% Taking a step back I want to plot the Depth data to look at the relationships
figure(3); 

for ii = 1: length(DepthData)/10
    start_idx = (ii-1)*10 +1;
    
    subplot(2,2,1); hold on
    plot(DepthData(start_idx:start_idx+9,2), DepthData(start_idx:start_idx+9, 4), 'x-')
    
    subplot(2,2,3); hold on
    plot(log(DepthData(start_idx:start_idx+9,2)), DepthData(start_idx:start_idx+9, 4), 'x-')
        
    legend_plot{ii} = ['D = ', num2str(DepthData(start_idx, 1)*1e6)];
    secondplot(ii, 1:4) = DepthData(start_idx, :);
end
subplot(2,2,1);
legend(legend_plot)
title('All Data'); grid on
xlabel('Wave Front #'); ylabel('Rate Required')

subplot(2,2,3);
legend(legend_plot); grid on
xlabel('log(Wave Front #)'); ylabel('Rate Required')
    
subplot(2,2,2)
plot(secondplot(:,1), secondplot(:,4), 'x-')
title('Only wave front #1'); grid on
xlabel('Diffusion'); ylabel('Rate Required'); 

subplot(2,2,4)
plot(log(secondplot(:,1)), secondplot(:,4), 'x-')
xlabel('log(Diffusion)'); ylabel('Rate Required'); 
grid on

%% Fit a1, a2, b1, b2
fit_a1a2b1b2 = 1;
if fit_a1a2b1b2 == 1
    % Find the second two first then the first two
    % secondplot(:, 1) is D secondplot(:, 4) is Rate
    A2 = [log(secondplot(:, 1)/1e-6), secondplot(:, 1)*0+1];
    b2 = secondplot(:, 4);
    b1_b2 = A2\b2;
    
    % now have b1 and b2 find the other two
    A1 = [log(DepthData(:,1)/1e-6).*log(DepthData(:,2)), log(DepthData(:,2))];
    b1 = DepthData(:, 4) - b1_b2(1).*log(DepthData(:,1)/1e-6) - b1_b2(2);
    a1_a2 = A1\b1;
    
    a1_a2_b1_b2 = [a1_a2; b1_b2]
    
    theata_1_2_omega_1_2 = [a1_a2_b1_b2(1), a1_a2_b1_b2(3), a1_a2_b1_b2(2), a1_a2_b1_b2(4)]
    
    % Old method find all at once
%     A = [log(DepthData(:,1)/1e-6).*log(DepthData(:,2)), log(DepthData(:,2)), log(DepthData(:,1)/1e-6), DepthData(:,1)*0+1];
%     b = DepthData(:, 4);
%     a1_a2_b1_b2 = A\b
end

%% Plot predicted lines
figure(3)
subplot(2,2,2); hold on
Dv = 1:0.5:10;
R = a1_a2_b1_b2(3)*log(Dv) + a1_a2_b1_b2(4);
plot(Dv*1e-6, R, 'r')
subplot(2,2,4); hold on
Dv = 1:0.5:10;
R = a1_a2_b1_b2(3)*log(Dv) + a1_a2_b1_b2(4);
plot(log(Dv*1e-6), R, 'r')


%% Plot 4 diffusion constants for wvae number plots for report
report_plots = 1;
legend_plot2 = {};
if report_plots
    symbolsUsed = {'x-', 'o-', '^-', '*-'};
    figure(); hold on
    count = 0;
    for ii = [1,3,7,15]
        start_idx = (ii-1)*10 +1;
        count = count+1;
        plot(DepthData(start_idx:start_idx+9,2), DepthData(start_idx:start_idx+9, 4), symbolsUsed{count}, 'linewidth', 2)
        
        legend_plot2{end+1} = ['D = ', num2str(DepthData(start_idx, 1)*1e6), '\times 10^{-6}', 'cm^2s^{-1}']; 
    end
    legend(legend_plot2)
    grid on
    xlabel('Wave Front Number'); ylabel('f_1 Required')
    
    figure(); hold on
    plot(secondplot(:,1)/(1e-6), secondplot(:,4), 'x-' , 'linewidth', 2)
    grid on
    xlabel('Diffusion (\times 10^{-6})'); ylabel('f_1 Required'); 
    plot(Dv, R, 'r' , 'linewidth', 2)
    legend('f_1 required to achieve depth solving PDE', 'Natural log Line of best fit line ')
end

%% overlay
% 
% figure(4)
% for ii = [1,2,4,8]
%     wveno = 1:10;
%     a2 = a1_a2_b1_b2(3)*log(ii) + a1_a2_b1_b2(4);
%     a1 = a1_a2_b1_b2(1)*log(ii) + a1_a2_b1_b2(2);
%     R = a1*log(wveno) + a2;
%     plot(wveno, R, ':r')
%     
% end