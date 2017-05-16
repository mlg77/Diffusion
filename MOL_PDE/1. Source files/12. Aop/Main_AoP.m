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
dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability';
%% Step 1 Load data and convert to AoP, Plot
cd(dirs.save_file)
load('Aop_Gold')
cd(dirs.this_file)

position_x = 0:1e-3:0.5;
Aop = [];
for ii = 1:length(position_x)
    Aop(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end
betas_coll = position_x*0.56;
Aop(find(Aop <= 1e-10)) = 0;
lastpertcare = find(perts >=0.3, 1);
myColorMap = summer; 
myColorMap(1, :) = [1 1 1];

% Plot
figure(1)
[C,h1] = contourf(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20); hold on;
[C,h2] = contour(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20);
axis([0,0.3,0,0.5])
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
    for ii = [2,4,6,8,10]
        D_WvaeNo_Depth = Goldbeter_run_forD( ii*1e-6 );
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

Rate_v_depth = [0:0.001:1]';
for ii = 1:length(Rate_v_depth)
    Pertibation = 0.2;
    Pert_po_Aop = [];
    for jj = 1:length(position_x)
        Pertibation_idx = find( perts >= Pertibation, 1);
        if isempty(Pertibation_idx)
            break
        end
        Pert_po_Aop(1:3) = [Pertibation, position_x(end-jj+1), Aop(end-jj + 1,Pertibation_idx)];
        Pertibation = Pert_po_Aop(3)*Rate_v_depth(ii);
%         Pertibation = (Pert_po_Aop(3)+ Pert_po_Aop(1))*Rate_v_depth(ii);
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

% Fit a1, a2, b1, b2
fit_a1a2b1b2 = 1;
if fit_a1a2b1b2
    A = [log(DepthData(:,1)/1e-6).*log(DepthData(:,2)), log(DepthData(:,2)), log(DepthData(:,1)/1e-6), DepthData(:,1)*0+1];
    b = DepthData(:, 4);
    a1_a2_b1_b2 = A\b
end

%% Taking a step back I want to plot the Depth data to look at the relationships
figure(3); 

for ii = 1: 5
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

