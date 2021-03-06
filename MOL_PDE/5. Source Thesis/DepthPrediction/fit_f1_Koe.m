

clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\9. Depth';
dir_load1 = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load2 = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages';

% Step one create omega1,theta1

cd(dir_load2)
load('Model_Koe.mat')
cd(dir_save)
load('Koe.mat')

D_wave_Depth_Height_t = zeros(length(D_wave_Depth), 5);
D_wave_Depth_Height_t(1:length(D_wave_Depth), 1:3) = D_wave_Depth;

Just_wave_1 = [];
NotWaveOne = [];
for ii = 1: length(D_wave_Depth_Height_t)
    if D_wave_Depth_Height_t(ii, 2) == 1
        Just_wave_1(end+1, 1:5) = D_wave_Depth_Height_t(ii, 1:5);
    else
        NotWaveOne(end+1, 1:5) = D_wave_Depth_Height_t(ii, 1:5);
    end
end

D_used = Just_wave_1(:, 1);
depth_achieved = Just_wave_1(:,3);

for ii = 1:length(depth_achieved)
    idx_d = find(depthV<=depth_achieved(ii), 1);
    f1_needed(ii) = f1(idx_d);
end

plot(D_used, f1_needed', 'bx')

P = polyfit(log(D_used), f1_needed',1);
theata_1 = P(1)
omega_1 = exp(P(2))

d_vect = 1e-5*[0.1:0.001:1];
hold on
plot(d_vect, log(omega_1.*d_vect.^theata_1), 'r')
xlabel('Diffusion [cm^2s^{-1}]')
ylabel('f_1')


%% Now second 2
for ii = 1:length(NotWaveOne)
    idx_d = find(depthV<=NotWaveOne(ii, 3), 1);
    NotWaveOne(ii, 6) = f1(idx_d);
end

for ii = 1:length(D_wave_Depth_Height_t)
    idx_d = find(depthV<=D_wave_Depth_Height_t(ii, 3), 1);
    D_wave_Depth_Height_t(ii, 6) = f1(idx_d);
end

wave_no_used = NotWaveOne(:, 2);
D_used = NotWaveOne(:, 1);
requiredf = NotWaveOne(:, 6);

P = polyfit(log(D_used), ((requiredf - log(omega_1*D_used.^theata_1))./log(wave_no_used)),1);
theata_2 = P(1)
omega_2 = exp(P(2))

figure(); hold on;
startc = 1; endc = 1;
for ii = 2:length(D_wave_Depth_Height_t)
    if D_wave_Depth_Height_t(ii, 2) > D_wave_Depth_Height_t(ii-1, 2)
        endc = endc+1;
    else
        if ii == 31 || ii == 51 || ii == 71 
            plot(D_wave_Depth_Height_t(startc:endc, 2), D_wave_Depth_Height_t(startc:endc, 6), 'x')
        end
        endc = endc+1;
        startc = ii;
    end
end

figure(1)
legend('f_1 required to reach depth', 'f_1 calculated given D and \iota')
grid on

figure(2)
iotas = 1:10;
for ii = D_wave_Depth_Height_t([30, 50,70],1)'
    f1calc = log(omega_1.*ii.^theata_1)+ log(iotas).*log(omega_2.*ii.^theata_2);
    plot(iotas, f1calc)
end
    
legend('Required f_1: D = 3 \times 10^{-6}', 'Required f_1: D = 5 \times 10^{-6}', 'Required f_1: D = 7 \times 10^{-6}', 'Calculated f_1: D = 3 \times 10^{-6}', 'Calculated f_1: D = 5 \times 10^{-6}', 'Calculated f_1: D = 7 \times 10^{-6}')
xlabel('Iota \iota'); ylabel('f_1')
grid on

return
cd(dir_save)
save(['Gold_Par'], 'omega_1', 'omega_2', 'theata_1', 'theata_2')
cd([dir_save, '\Gold'])

NumberOfFig = 2;
for ii = 1:NumberOfFig
    savefig(ii, [num2str(ii), 'Gold.fig'])
end

for i = 1:NumberOfFig
    figure(i)
    set(gcf,'PaperPositionMode','auto')
    print([num2str(i),'Gold'],'-dpng', '-r300')
end


cd(dir_parent)
