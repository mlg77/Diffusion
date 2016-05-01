% Find the frequency over the unstable region of beta

clear; clc; close all

%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';


cd([AllDir.ParentDir, AllDir.InitalDataDir]);
load('Defult_data.mat');
cd([AllDir.ParentDir, AllDir.SourceDir])
for i = 1:length(mybeta)
    [ Z1, V1 ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta(i), 0);
    my_max(i) = max(Z1(10, 1001:end));
    my_min(i) = min(Z1(10, 1001:end));
    my_freq(i) = find_freq(Z1(10, 1001:end), t(1001:end));
end
bt_point_found = 1;
for k = 1:length(my_max)
    if abs(my_max(k) - my_min(k)) < 0.007 & bt_point_found
        bt_point = mybeta(k);
        x_bt_pt = my_max(k);
    elseif bt_point_found
        bt_point_found = 0;
    elseif abs(my_max(k) - my_min(k)) < 0.01
        top_point = mybeta(k);
        x_top_pt = my_max(k);
        break
    end
end

figure(1)
hold on
[ax h1 h2] = plotyy(mybeta, my_max, mybeta, my_freq);
plot(mybeta, my_min ,'g')
xlabel('Beta, \beta')
legend('max', 'min')
plot([bt_point, bt_point], [0, x_bt_pt], 'k','LineWidth',2)
plot([top_point, top_point], [0, x_top_pt],  'k','LineWidth',2)
axes(ax(1)); ylabel('Calcium Concentration [\muM]');
axes(ax(2)); ylabel('Period of Oscillations [s]');
hold off