%% Aop Dealing
% Four functions:
%   1) Load and create AoP grid
%   2) Run the function multiple times recording the actual depth / load
%   3) Run the predicted depth for potential rates /load 
%   4) Fit the rate equation chosen 
%   Author: Michelle Goodman
%   Date: 6/5/17

clear; clc; close all
dirs.this_file = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop\ExampleAoP';
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
straight_d = 2;
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
        
         if straight_d == 1
            Pertibation = Pert_po_Aop(3)*Rate_v_depth(ii);
        elseif straight_d == 2
            Pertibation = (Pert_po_Aop(3)+ Pert_po_Aop(1))*Rate_v_depth(ii);
        elseif straight_d == 3
            Pertibation = (Pert_po_Aop(3)/2)*Rate_v_depth(ii);
        end
        
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

%% For Different Po Plot depth path For D = 6e-6

Po = [0.1:0.05:0.25];
colour_options = {'k', 'r', 'b', 'g', 'm'};
boldNo = [8:-2:1];
boldNo = ones(1, 5)*1.5;
    

for ii = 1:length(Po)
    % Loop through first 5 waves
    Rate_pt1 = a1_a2_b1_b2(1)*log(6)+ a1_a2_b1_b2(2);
    Rate_pt2 = a1_a2_b1_b2(3)*log(6)+ a1_a2_b1_b2(4);
    for jj = 1
        Rate = Rate_pt1*log(jj) + Rate_pt2;
        
        Pertibation = Po(ii);
        Pert_po_Aop = [];
        for kk = 1:length(position_x)
            Pertibation_idx = find( perts >= Pertibation, 1);
            if isempty(Pertibation_idx)
                break
            end
            Pert_po_Aop(kk, 1:3) = [Pertibation, position_x(end-kk+1), Aop(end-kk + 1,Pertibation_idx)];
            if straight_d == 1
                Pertibation = Pert_po_Aop(kk,3)*Rate;
            elseif straight_d == 2
                Pertibation = (Pert_po_Aop(kk,3)+ Pert_po_Aop(kk,1))*Rate;
            elseif straight_d == 3
                Pertibation = (Pert_po_Aop(kk, 3)/2)*Rate;
            end
        end
        plot(Pert_po_Aop(:,1), Pert_po_Aop(:,2), colour_options{ii}, 'linewidth', boldNo(ii))
    end
    legend_entries{ii} = ['Po: ', num2str(Po(ii))];
   
end
legend(legend_entries)




