close all
D_Array = [0, 5e-6];

count = 0;
cd([dir_save]) 
for ii = [1,5,12,19]% 1:length(myXi_vector)
    myXi = myXi_vector(ii);
    mybeta = (x*0.7+0.1)';
    for jj = 1
        D = D_Array(jj);
        load(['Data_', num2str(ii), '_', num2str(jj)])
        if jj ==1
            per_end = 0.5;
            BifuMax = max(Z(:, floor(N*per_end):end)')';
            BifuMin = min(Z(:, floor(N*per_end):end)')';
        
            cd(['C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Analysis_functions']);
            [ pointsfound ] = Bifurcation_pointsToy( x,t,Z );
            [ TVector ] = FindPeriodVector( Z ,dt) ;
            cd([dir_save]) 

                        
            count = count+1;
            figure(count); hold on
            idx_wave = pointsfound(1)+31;
            Zp = Z(idx_wave, floor(length(t)/2):end);
            tp = t(floor(length(t)/2):end);
            [Troughs,LOCS] = findpeaks(-Zp);
            Zp = Zp(LOCS(2):LOCS(3)); 
            tp = tp(LOCS(2):LOCS(3));
            periodT = tp(end)-tp(1);
            
            Zp_norm = (Zp-min(Zp))/(max(Zp)- min(Zp));
            [Y, t_max_idx] = max(Zp);
            tou_idx = find(Zp_norm(t_max_idx:end) <0.5,1)+t_max_idx;
            tp_norm = (tp - min(tp)) / (max(tp) - min(tp));
            
            area(tp_norm(2*t_max_idx - tou_idx:t_max_idx), Zp_norm(2*t_max_idx - tou_idx:t_max_idx))
            area(tp_norm(t_max_idx:tou_idx), Zp_norm(t_max_idx:tou_idx))
            plot(tp_norm, Zp_norm, 'k', 'linewidth', 3)
            plot([0,tp_norm(tou_idx)], [0.5,Zp_norm(tou_idx)], 'k:')
            

        end
    end
end
return
for ii = 1:4
    figure(ii)
    cd(['C:\Temp\Diffusion\MOL_PDE\4. Output files\5. ToyModel 3\Figs\Report']) 
    savefig(ii, [num2str(ii), 'Example.fig'])
    cd(['C:\Temp\Diffusion\MOL_PDE\4. Output files\5. ToyModel 3\Figs\Report\Images']) 
    set(gcf,'PaperPositionMode','auto')
    print([num2str(ii), 'Example'],'-dpng', '-r300')
end