%% After running Goldbeter or similar Try and find the min/max bifurcation 
%   diagram
%   In this case beta must equal x
%   Date: 4/4/17
%   Author: Michelle Goodman

%   DOESNT WORK!!!

close all

% First define data needed
x  = Goldbeter.x;
t  = Goldbeter.t;
Z0D  = Goldbeter.Z0D;
ZFD  = Goldbeter.ZFD;
Y0D = Goldbeter.Y0D;
YFD = Goldbeter.YFD;

%% Next Find normal bifurcation Diagram
start_per = floor(0.2*length(t));
Max_line_normalZ = max(Z0D(:, start_per:end)')';
Min_line_normalZ = min(Z0D(:, start_per:end)')';
Max_line_normalY = max(Y0D(:, start_per:end)')';
Min_line_normalY = min(Y0D(:, start_per:end)')';

figure(2); subplot(1,2,1); hold on;
plot(x, Max_line_normalZ, 'b', 'linewidth', 2)
plot(x, Min_line_normalZ, 'b', 'linewidth', 2)
xlabel('Beta'); ylabel('Concentration')
title('Cytosolic concentration')

subplot(1,2,2); hold on;
plot(x, Max_line_normalY, 'b', 'linewidth', 2)
plot(x, Min_line_normalY, 'b', 'linewidth', 2)
xlabel('Beta'); ylabel('Concentration')
title('Intracellular store concentration')


%% Find max line of Fickian Diffusion
start_per = floor(0.05*length(t));
Max_line_DZ = max(ZFD(:, start_per:end)')';
Min_line_DZ = min(ZFD(:, start_per:end)')';
Max_line_DY = max(YFD(:, start_per:end)')';
Min_line_DY = min(YFD(:, start_per:end)')';

subplot(1,2,1);
plot(x, Max_line_DZ, 'r:', 'linewidth', 2)
plot(x, Min_line_DZ, 'r:', 'linewidth', 2)

subplot(1,2,2);
plot(x, Max_line_DY, 'r:', 'linewidth', 2)
plot(x, Min_line_DY, 'r:', 'linewidth', 2)


%% Find inner max/min
figure(); xlabel('Z'); ylabel('Y')
for ii = 1:20:length(x)
    Z_temp = ZFD(ii, start_per:end);
    Y_temp = YFD(ii, start_per:end);
    [PKS,LOCS]= findpeaks(Z_temp);
    [min_vas,idx_locs] = min(PKS);
    
    
    hold off;
%     plot(ZFD(ii, start_per:end), YFD(ii, start_per:end))
%     hold on;
%     plot(Z_temp(LOCS(idx_locs)), Y_temp(LOCS(idx_locs)), 'kx' )
    movavg(Z_temp,50,50,0)
    pause();
end
    
