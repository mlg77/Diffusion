% Predict D from st wave 1
clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction\D Prediction';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\11. Height';
dir_load_fv = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\9. Depth';


cd(dir_load_fv)
load('Gold.mat') % f1 vs depth achieved
load('Gold_Par.mat') % load f1 pars


rough_t_1 = [3,2.5];
for ii = 1:100
    cd(dir_load)
    load(['Gold_', num2str(ii), '.mat'])
%     figure(ii);
%     imagesc(t,flipud(x),Z0D)
%     set(gca,'YDir','normal')
%     xlabel('Time, [s]')
%     ylabel('Position, x')
%     colormap jet
%     colorbar
%     hold on
%     plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
    
    % Step one follow wave to end
    cd(dir_source)
    [ wave_data ] = Follow_wave( Z0D, x, t, 0.5, 1, rough_t_1 );
    depthactual = wave_data.po(end);
    
%     plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)
    
    % Convert that to a f1 value
    idx = find(depthV<=depthactual, 1);
    f1_needed = f1(idx);
    
    D_predicted(ii) = ((1/omega_1)*exp(f1_needed))^(1/theata_1);
    Dlist(ii) = D;
    myerror(ii) = (D - D_predicted(ii))/D * 100;
    
    data_table(ii, 1:6) =[ii, D, depthactual, f1_needed, D_predicted(ii), myerror(ii)] ; 
    
end

[D_predicted; Dlist];

figure();
h = histogram(myerror*(10e-6)/(1e-6));
xlabel('Percentage Error')
ylabel('Occurance')
h.NumBins = 15;

% hold on
% y = min(myerror):(max(myerror)-min(myerror))/100:max(myerror);
% mu = mean(myerror);
% sigma = std(myerror);
% f = exp(-(y-mu).^2./(2*sigma^2))./(sigma*sqrt(2*pi));
% plot(y,f*200,'LineWidth',1.5)
%     
    