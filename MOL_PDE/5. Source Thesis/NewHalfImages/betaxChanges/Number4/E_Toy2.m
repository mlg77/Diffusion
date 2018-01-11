%% Depth E Plot first four waves

clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\NewHalfImages\betaxChanges\Number4';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\10. EDepth Plot\Toy2';

dir_FD = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\betaChanges\Toy2';
dir_E = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_pars = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\9. Depth';
dir_itter = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction\Depths_models';
dir_height = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\Height';


ii = 4;

cd(dir_FD)
load(['Toy2_', num2str(ii)])
mybetanew = mybeta;

bis_idx(2) = find(mybeta>= mybeta(501), 1)-1;
bis_idx(1) = find(mybeta(bis_idx(2)+10:end)<= mybeta(501), 1)+ bis_idx(2)+9;

cd([dir_E])
load('Toy2_E')

% Need to reorder E first
cd(dir_parent)
[ tempE ] = ReorderE( E, mybeta, mybetanew(1:500));

figure(ii); hold on;
imagesc(P,x(1:500), tempE)
set(gca,'YDir','normal')
xlabel('Perturbations, P')
ylabel('Position, x')
colormap jet
myColorMap = summer;
myColorMap(1, :) = [1 1 1];
colormap(myColorMap); colorbar


cd(dir_pars)
load('Toy2_Par')

rough_t_1 = [40, 80]; % Toy2
colours_match = {'r', 'c', 'm'};
myerror = [];


cd(dir_source)
for kk = 1:3
    f1 = a_1/D + b_1 + (log(omega_2*D^theata_2).*log(kk));
    
    [ pathdata ] = ItterationDownBeta2( P,  mybetanew(1:500), tempE, mybetanew(1:500), f1, 0.5 );
    
    figure(ii)
    plot(pathdata.P, pathdata.x, colours_match{kk})
    plot([0,pathdata.P(end)], pathdata.x(end)*[1,1], colours_match{kk})
    
    % Bot half
    [ pathdata ] = ItterationDownBeta2( P,  mybetanew(1:bis_idx(2)), tempE(1:bis_idx(2), :), mybetanew(1:bis_idx(2)), f1, 0.5 );
    pathdata.x = pathdata.x - (0.5-x(bis_idx(2)));
    figure(ii)
    plot(pathdata.P, pathdata.x, colours_match{kk})
    plot([0,pathdata.P(end)], pathdata.x(end)*[1,1], colours_match{kk})
    
    % reverse part
    r_mybetanew = fliplr(flipud(mybetanew(bis_idx(1):500)));
    r_tempE = flipud(tempE(bis_idx(1):500, :));
    [ pathdata ] = ItterationDownBeta2( P, r_mybetanew ,r_tempE , r_mybetanew, f1, 0.5 );
    tempx = pathdata.x;
    pathdata.x = nan(size(tempx));
    for jj = 1:length(tempx)
        pathdata.x(jj) = x(bis_idx(1))+ (tempx(1) - tempx(jj));
    end
    figure(ii)
    plot(pathdata.P, pathdata.x, colours_match{kk})
    plot([0,pathdata.P(end)], pathdata.x(end)*[1,1], colours_match{kk})
    
    
end


figure(ii)
axis([0,P(end),0,1])
rectangle('Position',[0,0.5,P(end),0.5],'FaceColor',[0.6627 0.6627 0.6627])
rectangle('Position',[0,x(bis_idx(2)),P(end),x(bis_idx(1)) - x(bis_idx(2))],'FaceColor',[0.6627 0.6627 0.6627])

figure(99)
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
		hold on
        colorbar
        
        plot([0,800], 0.5*[1,1], 'k', 'linewidth', 2)
        plot([0,800], x(bis_idx(2))*[1,1], 'k', 'linewidth', 2)
        plot([0,800], x(bis_idx(1))*[1,1], 'k', 'linewidth', 2)


cd(dir_parent)
return

cd(dir_save)
    figure(ii)
    savefig(ii, ['Toy2_E_', num2str(ii), '.fig'])
    cd([dir_save, '\Images'])
    set(gcf,'PaperPositionMode','auto')
    print(['Toy2_E_', num2str(ii)],'-dpng', '-r300')

cd(dir_parent)