%% Error plots for the report

% 

clear; clc; close all
dirs.this_file = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
% dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability';
dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Dupont';

cd(dirs.save_file)
load('Actual_Depths')
cd(dirs.this_file)
    
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

    
% First Job find the predicted depths
for ii = 2:length(DepthData)
    a1a2a3a4 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
    a = (a1a2a3a4(1)*log(DepthData(ii, 1)/(1e-6)) + a1a2a3a4(2));
    b = (a1a2a3a4(3)*log(DepthData(ii, 1)/(1e-6)) + a1a2a3a4(4));
    f_1 =  a*log(DepthData(ii, 2)) + b;
    [ x_P, P ] = predict_depth_ex6( Aop, perts, position_x, 0.5, f_1, 1 );
    
    idx_end = find(P<=1e-6,1);
    DepthData(ii, 4) = x_P(idx_end);
    
end

figure(); hold on;
mylegend = {};
for ii = 2:length(DepthData)/10
    care_data = DepthData(ii*10-9:ii*10, 1:4);
    plot(care_data(:, 2), (care_data(:,3)-care_data(:,4))./ care_data(:,3)*100)
    mylegend{end + 1} = ['D = ', num2str(care_data(1)*1e6)];
    xlabel('Wave Front Number'); ylabel('Percentage Error, [%]')
end
legend(mylegend)

%% Error Bars

figure();

a1a2a3a4 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
a = (a1a2a3a4(1)*log(6) + a1a2a3a4(2));
b = (a1a2a3a4(3)*log(6) + a1a2a3a4(4));
f_1O =  a*log(1) + b;
    
Percentage_change = [1,5,10];
for jj = 1:length(Percentage_change)
    subplot(1,6,jj)
    myColorMap = summer; 
    myColorMap(1, :) = [1 1 1];
    [C,h1] = contourf(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20); hold on;
    [C,h2] = contour(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20);
    axis([0,0.5,0,0.5])
    xlabel('Pertibations'); ylabel('Position, x [cm]');
    colormap(myColorMap); colorbar
    set(gca,'YDir','normal'); set(gca,'layer','top');
    grid on
    hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false);
    a1a2a3a4 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
    type_plot = {'k:', 'k', 'k:'};
    for ii = -1:1
        f_1 = f_1O + f_1O*ii*Percentage_change(jj)/100;
        [ x_P, P ] = predict_depth_ex6( Aop, perts, position_x, 0.5, f_1, 1 );
        idx_end = find(P<=1e-6,1);
        plot(P(2:idx_end), x_P(2:idx_end), type_plot{ii+2}, 'Linewidth', 2)
    end
    title(['Percentage change in f_1 of ', num2str(Percentage_change(jj)),'%'])
end

%% Report plot

figure(); hold on;
mylegend = {};
symbolused = {'x-', 'o-', '^-', '*-', 's-'};
count = 0;
for ii = 3:4:length(DepthData)/10
    count = count + 1;
    care_data = DepthData(ii*10-9:ii*10, 1:4);
    plot(care_data(:, 2), (care_data(:,3)-care_data(:,4))./ care_data(:,3)*100, symbolused{count})
    mylegend{end + 1} = ['D = ', num2str(care_data(1)*1e6), '\times 10^{-6} cm^2s^{-1}'];
    xlabel('Wave Front Number'); ylabel('Percentage Error, [%]')
end
legend(mylegend)
grid on
