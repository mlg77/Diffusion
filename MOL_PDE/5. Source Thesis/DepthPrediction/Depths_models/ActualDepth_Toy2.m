% Record Acutal depths and heights collate and save
clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction\Depths_models';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\';


% D_vector = linspace(0,10,16)*1e-6;
D_vector = linspace(1,16,16)*1e-7;
% D_vector2 = 1.0e-05 *[0.067	0.13	0.27	0.3	0.47	0.53	0.67	0.73	0.87	0.93];
% D_vector = [D_vector1, D_vector2];

D_wave_Depth_Height_t = [];
count = 0;
for jj = 1:length(D_vector)%length(D_vector1) + length(D_vector2)
    display(['jj = ', num2str(jj)])
    D = D_vector(jj);
    % Depending on model, change ocation and load file
    cd([dir_save, 'Toy2'])
%     if jj <=length(D_vector1)
%         load(['Toy2_Data_', num2str(D), '.mat'])
%     else
%         counter = jj-11;
%         load(['Toy2_Data_no', num2str(counter), '.mat'])
%     end
    load(['Toy2_Data_', num2str(jj), '.mat'])
        
    rough_t_1 = [40, 80];
    % Record depth
    cd(dir_source)
    
    
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
    
%     if jj == 2 || jj== 3
%         num_waves = 2:11;
%     elseif jj == 4
%         num_waves = 1:8;
%     elseif jj == 5
%         num_waves = 1:7;
%     else 
%        num_waves = 1:10; 
%     end
    if jj == 1 
        num_waves = 3:9;
    elseif jj == 2 || jj ==4
        num_waves = 2:11;
        count
    elseif jj == 5 || jj == 6
        num_waves = 1:8;
    elseif jj == 8
        num_waves = 1:7;
    else 
       num_waves = 1:10; 
    end
%     num_waves = 1:10; 
    for kk = num_waves
        [ wave_data ] = Follow_wave( Z0D, x, t, 0.48, kk+1, rough_t_1 );
        if length(wave_data.po) <= 1
            % pass
        else
            w_depth = wave_data.po(end);
            w_t = wave_data.t(end);
            w_height = wave_data.mag(end);
            count = count+1;
            D_wave_Depth_Height_t(count, 1:5) = [D,kk, w_depth, w_height, w_t];
            
            plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)
            display(num2str(kk))
%             pause()
        end
    end
    

    clf('reset')
    
end

%% Edits
D_wave_Depth_Height_t(1:7, 2) = D_wave_Depth_Height_t(1:7, 2) -2;
D_wave_Depth_Height_t(8:17, 2) = D_wave_Depth_Height_t(8:17, 2) -1;
D_wave_Depth_Height_t(18:36, 2) = D_wave_Depth_Height_t(18:36, 2) -1;

return
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages')
save(['Model_Toy2'], 'D_wave_Depth_Height_t')


cd(dir_parent)