%% Depth E Plot first four waves

clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages\betaxChanges';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\10. EDepth Plot\Dup';

dir_FD = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\betaChanges\Dup';
dir_E = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_pars = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\9. Depth';
dir_itter = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction\Depths_models';
dir_height = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\Height';

%% Plot FD image
for ii = 1:3
    cd(dir_FD)
    load(['Dup_', num2str(ii)])
    mybetanew = mybeta;
    figure(ii); hold on;
    imagesc(t,flipud(x),Z0D)
    set(gca,'YDir','normal')
    xlabel('Time, [s]')
    ylabel('Position, x')
    colormap jet
    colorbar
    hold on
    plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)


    %% Plot 
    cd(dir_E)
    % load('Goldbeter_E')
    load('Dupont_E')
    % load('Toy2_E')
    
    % Need to reorder E first
    cd(dir_parent)
    [ tempE ] = ReorderE( E, mybeta, mybetanew(1:500) );
    
    
    
    figure(ii+10); hold on;
    imagesc(P,x(1:500), tempE)
    set(gca,'YDir','normal')
    xlabel('Perturbations, P')
    ylabel('Position, x')
    colormap jet
    myColorMap = summer;
    myColorMap(1, :) = [1 1 1];
    colormap(myColorMap); colorbar


    cd(dir_pars)
    % load('Gold_Par')
    load('Dupont_Par');
    % load('Toy2_Par')

    % rough_t_1 = [2, 2]; % Gold
    rough_t_1 = [3, 2.5]; % Dup
    % rough_t_1 = [40, 80]; % Toy2
    colours_match = {'r', 'c', 'm'};
    myerror = [];
    for kk = 1:3

        f1 = log(omega_1*D^theata_1) + (log(omega_2*D^theata_2)*log(kk));

        cd(dir_source)
        [ wave_data ] = Follow_wave( Z0D, x, t, 0.5, kk, rough_t_1 );

%         [ pathdata ] = ItterationDownBeta2( P, mybeta, E, mybetanew(1:500), f1, 0.2 );
        [ pathdata ] = ItterationDownBeta2( P,  mybetanew(1:500), tempE, mybetanew(1:500), f1, 0.2 );
        
        cd(dir_height)
        [ pathdata.C ] = TranslateToHeight( pathdata.E, pathdata.P, 1, mybetanew);
        
        figure(ii*10+10 + kk); hold on;
        plot(wave_data.po, wave_data.mag)
        plot(pathdata.x, pathdata.C)
        legend('Actual', 'Prediction')
        set(gca,'XDir','reverse')
        xlabel('Position, x'); ylabel('Concentration')        
        
        figure(ii)
        plot([t(1), t(end)], wave_data.po(end)*[1,1], colours_match{kk})

        figure(ii+10)
        plot(pathdata.P, pathdata.x, colours_match{kk})
        plot([0,pathdata.P(end)], pathdata.x(end)*[1,1], colours_match{kk})

        myerror(kk) = wave_data.po(end) - pathdata.x(end);

    end

    figure(ii)
    axis([t(1), t(end), 0, 1])
    figure(ii+10)
    axis([0,0.5,0,1])
    rectangle('Position',[0,0.5,0.5,0.5],'FaceColor',[0.6627 0.6627 0.6627])

    error_percent(1:3, ii) = 100*myerror';
    

end
error_percent

return


num_figs = 1:3;
for ii = num_figs
    cd(dir_save)
    figure(ii)
    savefig(ii, ['Dup_st_', num2str(ii), '.fig'])
    cd([dir_save, '\Images'])
    set(gcf,'PaperPositionMode','auto')
    print(['Dup_st_', num2str(ii)],'-dpng', '-r300')
    cd(dir_save)
    
    figure(ii + 10)
    savefig(ii+10, ['Dup_E_', num2str(ii), '.fig'])
    cd([dir_save, '\Images'])
    set(gcf,'PaperPositionMode','auto')
    print(['Dup_E_', num2str(ii)],'-dpng', '-r300')
    
end

cd(dir_parent)