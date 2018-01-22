

clear; clc; close all

dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\DepthPrediction';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\9. Depth';
dir_load1 = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load2 = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\8. HalfImages';

% Step one create omega1,theta1

cd(dir_load2)
load('Model_Toy2.mat')
cd(dir_save)
load('Toy2.mat')

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

% plot(D_used, f1_needed', 'bx')
plot(1./D_used, f1_needed', 'bx')

% P = polyfit(log(D_used), f1_needed',1);
P = polyfit(1./(D_used), f1_needed',1);
% theata_1 = P(1)
% omega_1 = exp(P(2))
a_1 = P(1)
b_1 = P(2)


d_vect =linspace(1,16,50)*1e-7;
hold on
% plot(d_vect, a_1./d_vect+ b_1, 'r')
plot(1./d_vect, a_1./d_vect+ b_1, 'r')
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

% P = polyfit(log(D_used), ((requiredf - a_1./D_used- b_1)./log(wave_no_used)),1);
% a_2 = P(1)
% b_2 = (P(2))

P = polyfit(log(D_used), ((requiredf - a_1./D_used- b_1)./log(wave_no_used)),1);
a_2 = P(1)
b_2 = exp(P(2))

theata_2 = a_2;
omega_2 = b_2;


figure(); 
startc = 1; endc = 1;
for ii = 2:length(D_wave_Depth_Height_t)
    if D_wave_Depth_Height_t(ii, 2) > D_wave_Depth_Height_t(ii-1, 2)
        endc = endc+1;
    else
        if ii == 27 || ii == 45 || ii == 70 %|| ii == 45
%             plot(D_wave_Depth_Height_t(startc:endc, 2), D_wave_Depth_Height_t(startc:endc, 6), 'x')
            semilogx(D_wave_Depth_Height_t(startc:endc, 2), D_wave_Depth_Height_t(startc:endc, 6), 'x')
            hold on;
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
for ii = D_wave_Depth_Height_t([18, 37,63],1)'
    f1calc = a_1/ii+ b_1+ log(iotas).*log(omega_2.*ii.^theata_2);
%     f1calc = a_1/ii+ b_1+ log(iotas).*(log(ii).*a_2+ b_2);
%     plot(iotas, f1calc)
    semilogx(iotas, f1calc)
end

axis([1,7, 0.18, 0.34])
% legend('Required f_1: D = 3 \times 10^{-6}', 'Required f_1: D = 5 \times 10^{-6}', 'Required f_1: D = 8 \times 10^{-6}', 'Calculated f_1: D = 3 \times 10^{-6}', 'Calculated f_1: D = 5 \times 10^{-6}', 'Calculated f_1: D = 8 \times 10^{-6}')
xlabel('Iota \iota'); ylabel('f_1')
grid on

return
cd(dir_save)
save(['Toy2_Par'], 'a_1', 'a_2', 'b_1', 'b_2')
cd([dir_save, '\Toy2'])

NumberOfFig = 2;
for ii = 1:NumberOfFig
    savefig(ii, [num2str(ii), 'Toy2.fig'])
end

for i = 1:NumberOfFig
    figure(i)
    set(gcf,'PaperPositionMode','auto')
    print([num2str(i),'Toy2'],'-dpng', '-r300')
end


cd(dir_parent)
