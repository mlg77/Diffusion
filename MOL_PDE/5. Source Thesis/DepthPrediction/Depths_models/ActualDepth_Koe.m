% Record Acutal depths and heights collate and save
clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages\';

D_vector1 = linspace(0,10,11)*1e-6;
% D_vector2 = linspace(0,10,11)*1e-6;

D_vector2 = 1.0e-05 *[0.067	0.13	0.27	0.3	0.47	0.53	0.67	0.73	0.87	0.93];

D_vector = [D_vector1, D_vector2];
D_vector = sort(D_vector);
D_vector = unique(D_vector);

count = 0;


D_wave_Depth = [];

for ii = 2:length(D_vector1)
    for kk = 1:10
        count = count+1;
        D_wave_Depth(count, 1:3) = [D_vector1(ii),kk, 0];
        
        if ii == 2 && kk == 1;        D_wave_Depth(count, 3) = 0.5;
        elseif ii == 2 && kk == 2;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 3 && kk == 1;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 4 && kk == 1;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 9 && kk == 10;
            D_wave_Depth(count, 3) = 0.086;
        elseif ii == 10 && kk == 10;
            D_wave_Depth(count, 3) = 0.098;
        elseif ii == 11 && kk == 10;
            D_wave_Depth(count, 3) = 0.075;
        end
    end
end



for ii = 1:length(D_vector2)
    for kk = 1:10
        count = count+1;
        D_wave_Depth(count, 1:3) = [D_vector2(ii),kk, 0];
        
        if ii == 1 && kk == 1;        D_wave_Depth(count, 3) = 0.5;
        elseif ii == 1 && kk == 2;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 2 && kk == 1;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 2 && kk == 2;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 3 && kk == 1;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 4 && kk == 1;    D_wave_Depth(count, 3) = 0.5;
        elseif ii == 9 && kk == 10;
            D_wave_Depth(count, 3) = 0.094;
        elseif ii == 10 && kk == 10;
            D_wave_Depth(count, 3) = 0.093;
        end
    end
end



% load(['Koe_Data_', num2str(D), '.mat'])
% rough_t_1 = [20, 30];

return
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages')
save(['Model_Koe'], 'D_wave_Depth')


cd(dir_parent)