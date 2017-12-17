% Record Acutal depths and heights collate and save
clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\';

D_vector1 = linspace(0,10,16)*1e-6;
D_vector2 = linspace(0,10,11)*1e-6;

D_vector = [D_vector1, D_vector2];
D_vector = sort(D_vector);
D_vector = unique(D_vector);

count = 0;


for ii = 4:5% 1:5 % loop through models
    D_wave_Depth_Height_t = [];
    count = 0;
    ii
    for jj = 2:length(D_vector)
        D = D_vector(jj);
        % Depending on model, change ocation and load file
        if ii == 1
            cd([dir_save, 'Gold'])
            load(['Gold_Data_', num2str(D), '.mat'])
            rough_t_1 = [2, 2];
        elseif ii == 2
            cd([dir_save, 'Dup'])
            load(['Dup_Data_', num2str(D), '.mat'])
            rough_t_1 = [3, 2.5];
        elseif ii == 3
            cd([dir_save, 'Koe'])
            load(['Koe_Data_', num2str(D), '.mat'])
            rough_t_1 = [20, 30];
        elseif ii == 4
            cd([dir_save, 'FHN'])
            load(['FHN_Data_', num2str(D), '.mat'])
            rough_t_1 = [50, 50];
        elseif ii == 5
            cd([dir_save, 'Toy2'])
            load(['Toy2_Data_', num2str(D), '.mat'])
            rough_t_1 = [40, 80];
        end
        % Record depth 
        cd(dir_source)
        
        if ii == 4
            num_waves = [];
        elseif jj == 6
            num_waves = 1:10;
        else 
            num_waves = 1;
        end
        
        for kk = num_waves
            [ wave_data ] = Follow_wave( Z0D, x, t, 0.5, kk, rough_t_1 );
            if length(wave_data.po) < 1
                % pass
            else
                w_depth = wave_data.po(end);
                w_t = wave_data.t(end);
                w_height = wave_data.mag(end);
                count = count+1;
                D_wave_Depth_Height_t(count, 1:5) = [D,kk, w_depth, w_height, w_t];
            end
        end 
    end
    
    
    cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages')
    save(['Model', num2str(ii)], 'D_wave_Depth_Height_t')
end

cd(dir_parent)