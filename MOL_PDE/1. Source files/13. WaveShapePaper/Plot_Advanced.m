%% Plot Second wave shapes pictorial and create FH-score


%% File Location
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files\13. WaveShapePaper\';
AllDir.SaveDir = '4. Output files\WaveShapePaper';

load_or_not = 0;
if load_or_not == 1
    cd([AllDir.ParentDir , AllDir.SaveDir ])
    load('All_run_data')
    cd([AllDir.ParentDir , AllDir.SourceDir ])

end
close all


for ii = 1:5 %models
    if ii == 1
        t = Dupont.t;
        x = Dupont.x;
        Z0D = Dupont.Z0D;
        x_idx = 700;
    elseif ii == 2
        t = Ernmentrout.t;
        x = Ernmentrout.x;
        Z0D = Ernmentrout.Z0D;
        x_idx = 580;
    elseif ii == 3
        t = FitzHugh.t;
        x = FitzHugh.x;
        Z0D = FitzHugh.Z0D;
        x_idx = 521;
    elseif ii == 4
        t = Toy1.t;
        x = Toy1.x;
        Z0D = Toy1.Z0D;
        x_idx = 521;
    elseif ii == 5
        t = Toy2.t;
        x = Toy2.x;
        Z0D = Toy2.Z0D;
        x_idx = 521;
    end
   
    % Step 1: Find one wave
    [PKS,LOCS] = findpeaks(-1*Z0D(x_idx, :));
    one_wave = Z0D(x_idx, LOCS(end-2): LOCS(end-1));
    tims_cycle = t(LOCS(end-2): LOCS(end-1));
    [Ymax,Imax] = max(one_wave);
    Ymin = min(one_wave);
    T_period = tims_cycle(end) - tims_cycle(1);
    
    figure(ii)
    plot(tims_cycle - 0.07*T_period, one_wave, 'r-.', 'linewidth', 3); hold on
    plot(tims_cycle + 0.07*T_period, one_wave, 'b:', 'linewidth', 3); hold on
    plot(tims_cycle, one_wave, 'k-', 'linewidth', 3); hold on
    
    two_wave = [one_wave, one_wave];
    fh_vector2 = [];
    for jj = 1:floor(length(tims_cycle)/2)
        fh_vector = two_wave(Imax+jj) - two_wave(Imax-jj);
        fh_vector2(jj) = (fh_vector)/(Ymax - Ymin);       
    end
    
    if ii == 4
       fh_vector2 = [0,0] ;
    end
    
    perP = linspace(0,50,length(fh_vector2));
    
    idx_pos = find(fh_vector2>=0);
    idx_neg = find(fh_vector2<0);
    
    
    figure(ii + 5)
%     plot(perP(idx_pos), fh_vector2(idx_pos),'b', 'linewidth', 2); hold on
%     plot(perP(idx_neg), -1*fh_vector2(idx_neg),'r', 'linewidth', 2); hold on
    plot(perP, fh_vector2,'b', 'linewidth', 2); hold on
    
    xlabel('Percentage Period [%]')
    ylabel('FH(dt) [-]')
    grid on
    
    [max_abs_fh, idx] = max(abs(fh_vector2));
    FH_score(ii) = fh_vector2(idx);
    
end

FH_score
Ifsave = 0;
if Ifsave == 1
    cd('C:\Users\mlg77\Local Documents\Git\MG_PhD_Thesis\5. Toy Model Paper\NewFormat\fig\Results')
    for ii = 1:10
        figure(ii)
        title('')
        set(gcf,'PaperPositionMode','auto')
        print(['second_results_', num2str(ii)],'-dpng', '-r300')
    end
end



