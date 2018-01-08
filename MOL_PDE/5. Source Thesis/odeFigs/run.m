%% Generate ODE figs for each of the 5 models
clear; clc; close all
% Dirs
dir.models = {'2. Goldbeter', '1. Dupont', '3. Fitz', '4. Ernmentrout', '5. Koe'};
dir.home = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\odeFigs';
dir.loads = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations';
dir.save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\1. ODE_Bifurcations';

for ii = 4:5% 1:length(dir.models)
    cd([dir.loads, '\', dir.models{ii}])
    load('DataBi.mat');
    if ii == 1
        beta_chosen = find(mybeta >= 0.4, 1);
        figure(); hold on
        plot(t+10, Z(beta_chosen, :), 'b')
        plot(t+10, Y(beta_chosen, :), 'r')
        axis([t(end)-10, t(end)-6, 0, 2])
        xlabel('Time, [s]'); ylabel('Concentration, [\mu Ms^{-1}]')
        legend('Z', 'Y')
    elseif ii == 2
        beta_chosen = find(mybeta >= 0.45, 1);
        figure(); hold on
        plot(t+10, Z(beta_chosen, :), 'b')
        plot(t+10, Y(beta_chosen, :), 'r')
        axis([t(end)-10, t(end)-6, 0, 3.5])
        xlabel('Time, [s]'); ylabel('Concentration, [\mu Ms^{-1}]')
        legend('Z', 'Y')
    elseif ii == 3
        beta_chosen = find(mybeta >= 0.4, 1);
        figure(); hold on
        plot(t+100, Z(beta_chosen, :), 'b')
        plot(t+100, Y(beta_chosen, :), 'r')
        axis([t(end)-100, t(end), -2, 2])
        xlabel('Time, [s]'); ylabel('W vs U')
        legend('W', 'U')

    elseif ii == 4
        beta_chosen = find(mybeta >= 0.4, 1);
        figure(); hold on
        plot(t+5, Z(beta_chosen, :)/1000, 'b')
        axis([t(end)-5, t(end), 0, 0.4])
        xlabel('Time, [s]'); ylabel('Concentration, [\mu Ms^{-1}]')
        
        figure();
        plot(t+5, V(beta_chosen, :), 'b')
        axis([t(end)-5, t(end), -70, 0])
        xlabel('Time, [s]'); ylabel('Membrane Potential, [mV]')

        figure(); 
        plot(t+5, N0(beta_chosen, :), 'b')
        axis([t(end)-5, t(end), 0, 0.35])
        xlabel('Time, [s]'); ylabel('Open Probability, [-]')

    elseif ii == 5
        % to do
        
        beta_chosen = find(mybeta >= 0.7, 1);
        figure(); hold on
        plot(t+50, Z(beta_chosen, :), 'b')
        plot(t+50, Y(beta_chosen, :), 'r')
        axis([t(end)-50, t(end), 0, 1.2])
        xlabel('Time, [s]'); ylabel('Concentration, [\mu M s^{-1}]')
        legend('Z', 'Y')
        
        figure(); 
        plot(t+50, V(beta_chosen, :), 'b')
        axis([t(end)-50, t(end), -60, -40])
        xlabel('Time, [s]'); ylabel('Membrane Potential, [mV]')
        
        figure(); 
        plot(t+50, N0(beta_chosen, :), 'b')
        axis([t(end)-50, t(end), 0, 0.4])
        xlabel('Time, [s]'); ylabel('Open Probability, [-]')
    end
    
end

cd(dir.save)

for i = 1:6%9
    figure(i); box off;
    set(gcf,'PaperPositionMode','auto')
    print(['ODEfig_', num2str(i+3)],'-dpng', '-r300')
end


cd(dir.home)

