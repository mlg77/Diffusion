%% Aop Dealing
% Four functions same as Main
%   1) Load and create AoP grid
%   2) Run the function multiple times recording the actual depth / load
%   3) Run the predicted depth for potential rates /load 
%   4) Fit the rate equation chosen 
% but also An two extra step
%   5) Take a1,a2,b1,b2 and plot predicted depth for each actual and find
%   errors plot on AoP
%   6) Similar to step 2 run actual and record actual heights to cross plot
%   on AoP
%   Author: Michelle Goodman
%   Date: 6/5/17

%%.
%% !!!!!!! WARNING :   CURRENTLY NOT WORKING!!!!!!!! 
%%

clear; clc; close all
dirs.this_file = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Dupont';
%% Step 1 Load data and convert to AoP
cd(dirs.save_file)
load('sen_perts_data_full')
cd(dirs.this_file)

position_x = 0:1e-3:0.5;
Aop = [];
for ii = 1:length(position_x)
    Aop(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end
betas_coll = position_x*0.792;
Aop(find(Aop <= 1e-10)) = 0;
lastpertcare = find(perts >=0.3, 1);
myColorMap = summer; 
myColorMap(1, :) = [1 1 1];

%% Step 2 
% Run 5 different diffusion values and record the first 10 points plot each
% one just to make sure. Save this data so that only need to run once and
% load it each other time
% and Step 6 Plot actual heights on AoP graph!!
pre_run = 0;
if pre_run == 0
    ActualHeights = [];
    DepthData = [];
    for ii = [2,4,6,8,10] % Ten waves come out
        [ D_WvaeNo_Depth, Heights ] = Dupont_run_forD_Heights( ii*1e-6 );
        ActualHeights = [ActualHeights, Heights];
        DepthData = [DepthData; D_WvaeNo_Depth];
    end
    cd(dirs.save_file)
    % Note number two is deff start at zero
    save('Actual_Depth_Heights2', 'ActualHeights', 'DepthData')
    cd(dirs.this_file)
else
    cd(dirs.save_file)
    load('Actual_Depth_Heights2')
    load('Actual_Depth_Heights')
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
        straight_d = 2;
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

%% Fit a1, a2, b1, b2
% Force b1, b2 first
fit_a1a2b1b2 = 0;
if fit_a1a2b1b2
    % Find the second two first then the first two
    % secondplot(:, 1) is D secondplot(:, 4) is Rate
    A2 = [log(secondplot(:, 1)/1e-6), secondplot(:, 1)*0+1];
    b2 = secondplot(:, 4);
    b1_b2 = A2\b2;
    
    % now have b1 and b2 find the other two
    A1 = [log(DepthData(:,1)/1e-6).*log(DepthData(:,2)), log(DepthData(:,2))];
    b1 = DepthData(:, 4) - b1_b2(1).*DepthData(:,1)/1e-6 - b1_b2(2);
    a1_a2 = A1\b1;
    
    a1_a2_b1_b2 = [a1_a2; b1_b2]
    
    theata_1_2_omega_1_2 = [a1_a2_b1_b2(1), a1_a2_b1_b2(3), a1_a2_b1_b2(2), a1_a2_b1_b2(4)]
    
    % Old method find all at once
%     A = [log(DepthData(:,1)/1e-6).*log(DepthData(:,2)), log(DepthData(:,2)), log(DepthData(:,1)/1e-6), DepthData(:,1)*0+1];
%     b = DepthData(:, 4);
%     a1_a2_b1_b2 = A\b
else
    a1_a2_b1_b2 = [-0.1857, 0.0260, 0.0881,0.0657];
end


%% Step 5 Plot predicted depths based on a1a2b1b2 for first 5 waves on 
% each Diffusion
D_values = [2,4,6,8,10];
colour_options = {'b', 'r', 'k', 'g', 'm'};
for ii = 1:5
    % Plot The contour plot
    figure(ii)
    [C,h1] = contourf(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20); hold on;
    [C,h2] = contour(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20);
    axis([0,0.3,0,0.5])
    xlabel('Pertibations'); ylabel('Position, x [cm]');
    colormap(myColorMap); colorbar
    set(gca,'YDir','normal'); set(gca,'layer','top');
    grid on
    hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
    title(['Contour Plot of AoP grid of (P, x). D = ', num2str(D_values(ii))])

    % Loop through first 5 waves
    Rate_pt1 = a1_a2_b1_b2(1)*log(D_values(ii))+ a1_a2_b1_b2(2);
    Rate_pt2 = a1_a2_b1_b2(3)*log(D_values(ii))+ a1_a2_b1_b2(4);
    for jj = 1:5
        Rate = Rate_pt1*log(jj) + Rate_pt2;
        
        Pertibation = 0.2;
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
        legend_entries{jj} = ['Wave Number: ', num2str(jj)];
        plot(Pert_po_Aop(:,1), Pert_po_Aop(:,2), colour_options{jj})
    end
    legend(legend_entries)
end



% ii loop through Diffusions
for ii = 1:5
    % Starting Point in actual heights
    stpt = (ii-1)*10+1;
    figure(ii)
%     set(gcf, 'Position', get(0, 'Screensize'));
    % jj loop through wave numbers
    for jj = 1:5
        % Now fit onto the height of the AoP Grid for each position
        Heights_co = ActualHeights(:,stpt + jj -1);
        % Step one find the end point,
        zero_x_idx = find(Heights_co <= 1e-4, 1)-1;
        
        Heights_co = Heights_co + 0.1;
        
        Pert_wave_st = find(Aop(end - zero_x_idx + 1, :)>= 1e-4, 1);
        % Note: First point of heights is at x=0.5 vs
        %       First point of AoP is at x=0
        %       Thus RHS_eq starts at x=0
        RHS_eq = flipud(Heights_co);
        % Initalise plotting
        Po_Pert_Aop = [];
        Po_Pert_Aop = [[position_x(end-zero_x_idx);position_x(end-zero_x_idx-1)], [0; perts(Pert_wave_st)], [0; Aop(end - zero_x_idx, Pert_wave_st)]];
        Po_Pert_Aop = [Po_Pert_Aop; position_x(end-zero_x_idx + 1:end)', zeros(zero_x_idx,2)];
        % starting at end point of wave working way up to x = 0.5
        for kk = 1:zero_x_idx
            idx_perts = find(max_Z(end- zero_x_idx + kk, :) >= RHS_eq(end- zero_x_idx + kk),1);
            Po_Pert_Aop(kk+2, 2:3) = [perts(idx_perts(end)), Aop(end - zero_x_idx + kk, idx_perts(end))]; 
        end
        plot(Po_Pert_Aop(:, 2), Po_Pert_Aop(:, 1), [colour_options{jj}, 'x--'])
    end
end
    
figure();
count = 0;    
for ii = 1:50
    if rem(ii-1,10) == 0;
        count = count + 1;
        subplot(2,3,count) 
    end
    plot(fliplr(position_x), ActualHeights(:, ii)); 
    hold on;% axis([0.3,0.5,0,1.6]); 
    set(gca,'XDir','reverse');
    xlabel('Position'); ylabel('Concentration')
    grid on
end
suptitle('Actual Heights over position')


%% Plot just wave one
figure();
[C,h1] = contourf(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20); hold on;
[C,h2] = contour(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20);
axis([0,0.3,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
title(['Contour Plot of AoP grid of (P, x). Wave number 1'])

D_values = [2,4,6,8,10];
colour_options = {'b', 'r', 'k', 'g', 'm'};
for ii = 1:5
    % Loop through first 5 waves
    Rate_pt1 = a1_a2_b1_b2(1)*log(D_values(ii))+ a1_a2_b1_b2(2);
    Rate_pt2 = a1_a2_b1_b2(3)*log(D_values(ii))+ a1_a2_b1_b2(4);
    for jj = 1
        Rate = Rate_pt1*log(jj) + Rate_pt2;
        
        Pertibation = 0.2;
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
        plot(Pert_po_Aop(:,1), Pert_po_Aop(:,2), colour_options{ii})
    end
    legend_entries{ii} = ['Diffusion: ', num2str(D_values(ii))];
end
legend(legend_entries)


% ii loop through Diffusions
for ii = 1:5
    % Starting Point in actual heights
    stpt = (ii-1)*10+1;
%     set(gcf, 'Position', get(0, 'Screensize'));
    % jj loop through wave numbers
    for jj = 1
        % Now fit onto the height of the AoP Grid for each position
        Heights_co = ActualHeights(:,stpt + jj -1);
        % Step one find the end point,
        zero_x_idx = find(Heights_co <= 1e-4, 1)-1;
        
        Heights_co = Heights_co + 0.1;
        
        Pert_wave_st = find(Aop(end - zero_x_idx + 1, :)>= 1e-4, 1);
        % Note: First point of heights is at x=0.5 vs
        %       First point of AoP is at x=0
        %       Thus RHS_eq starts at x=0
        RHS_eq = flipud(Heights_co);
        % Initalise plotting
        Po_Pert_Aop = [];
        Po_Pert_Aop = [[position_x(end-zero_x_idx);position_x(end-zero_x_idx-1)], [0; perts(Pert_wave_st)], [0; Aop(end - zero_x_idx, Pert_wave_st)]];
        Po_Pert_Aop = [Po_Pert_Aop; position_x(end-zero_x_idx + 1:end)', zeros(zero_x_idx,2)];
        % starting at end point of wave working way up to x = 0.5
        for kk = 1:zero_x_idx
            idx_perts = find(max_Z(end- zero_x_idx + kk, :) >= RHS_eq(end- zero_x_idx + kk),1);
            Po_Pert_Aop(kk+2, 2:3) = [perts(idx_perts(end)), Aop(end - zero_x_idx + kk, idx_perts(end))]; 
        end
        plot(Po_Pert_Aop(:, 2), Po_Pert_Aop(:, 1), [colour_options{ii}, 'x--'])
    end
end