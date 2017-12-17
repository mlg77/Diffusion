% Record Acutal depths and heights collate and save
clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction\Depths_models';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\';


D_vector1 = linspace(0,10,11)*1e-6;
D_vector2 = 1.0e-05 *[0.067	0.13	0.27	0.3	0.47	0.53	0.67	0.73	0.87	0.93];
D_vector = [D_vector1, D_vector2];

D_wave_Depth_Height_t = [];
count = 0;
for jj = 2:length(D_vector1) + length(D_vector2)-1
    display(['jj = ', num2str(jj)])
    D = D_vector(jj);
    % Depending on model, change ocation and load file
    cd([dir_save, 'Dup'])
    if jj <=length(D_vector1)
        load(['Dup_Data_', num2str(D), '.mat'])
    else
        counter = jj-11;
        load(['Dup_Data_no', num2str(counter), '.mat'])
    end
        
    rough_t_1 = [3,2.5];
    % Record depth
    cd(dir_source)
    
    
    imagesc(t,flipud(x),Z0D)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
    
%     if jj == 4 
%         num_waves = -1:9;
%     elseif jj == 12
%         num_waves = 4:12;
%         count = count+1;
%         D_wave_Depth_Height_t(count, 1:5) = [D,1, 0.5, 0, nan];
%     else
%         num_waves = 1:10;
%     end
    num_waves = 1:10;
    for kk = num_waves
        [ wave_data ] = Follow_wave( Z0D, x, t, 0.5, kk, rough_t_1 );
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
            pause()
        end
    end
    

    clf('reset')
    
end

%% Edits
% D_wave_Depth_Height_t(1:10, 2) = D_wave_Depth_Height_t(1:10, 2) -1;
% D_wave_Depth_Height_t(102:110, 2) = D_wave_Depth_Height_t(102:110, 2) -2;
% D_wave_Depth_Height_t(111:119, 2) = D_wave_Depth_Height_t(111:119, 2) -1;

return
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages')
save(['Model_Dup'], 'D_wave_Depth_Height_t')


cd(dir_parent)