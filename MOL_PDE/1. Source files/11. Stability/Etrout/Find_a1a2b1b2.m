%% Find a1, a2, b1, b2 by running 4 different types of diffusion and 
%   finding the depths of penetration of first 10 waves
%   Author: Michelle  Goodman
%   Date: 1/4/17

clear; clc; close all
% Inital Conditions
t0 = 0;   t1 = 100; dt = 0.01;
dx = 1e-3;  
x = 0:dx:1;    
Z_0 = 0.5; V_0 = -40; N_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+N_0];
Diff_type = 1; D =0;% 6e-6;%  0;%
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Scalor = 0.57;
mybeta = (x*Scalor)';

%% First find actual Depths
possible_wavenumber = [1];
possible_D = [6,8]*1e-6;

DepthResults = [];
firstwave = [];
count = 0;
for kk = 1:length(possible_D)
    display(['Ernmentrout', num2str(kk)])
    Dupont.On = 1;
    Diff_type = 1; D =possible_D(kk);
    [t, yFD] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    ZFD = yFD(:, 1:M)';
    VFD = yFD(:, M+1:2*M)';
    figure(); imagesc(t, x, ZFD)
    figure(); imagesc(t, x, VFD)
    if D ~= 0
        for jj = 1:9
            [ wave_data ] = Follow_wave( VFD, x, t, 0.54, jj, [1, 1] );

            count = count + 1;
            DepthWave(count, :) = [D/dx^2, jj, wave_data.po(end)];
            hold on;
            plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)

            if jj == 1
                firstwave(end+1, :) = [D/dx^2, wave_data.po(end)];
            end
        end
    end

end

%% Next Find what rates give what depths
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Etrout')
load('sen_perts_data.mat')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Etrout')

plotted_V = [];
for ii = 1:length(betas_coll)
    plotted_V(ii, :) = max_V(ii,:)-BaseV(ii,:)-perts;
end

rate_depth = [];
for ii = 0:0.001:0.2530
    Rate =  ii;
    [ Perts_dbdx, Plot_dbetadx, plotxer ] = ItterationDownBeta( perts, betas_coll, plotted_V, betas_coll, betas_coll, Rate, 0.2 );
    rate_depth(end+1, :) = [ii, plotxer(end)];
end

%% Take the depths found and find the rate needed
for ii = 1:length(DepthWave)
    depth_found = DepthWave(ii, 3);
    rate_needed = rate_depth(find(rate_depth(:,2)<= depth_found, 1), 1);
    if isempty(rate_needed)
        rate_needed = rate_depth(end, 1);
    end
    DepthWave(ii, 4) = rate_needed;
end


%% Finally find a and b

% Equation in the form (alog(wave number) + b) 
% does not equal depth but Rate!!!!
% where a = a_1 log(D/dx^2) + a_2 
% and   b = b_1 log(D/dx^2) + b_2
% DepthWave = D/dx^2, jj, wave_data.po(end), rate_needed
% first only find 
first_wave_indx = 1:9:36;

b1 = DepthWave(first_wave_indx,4);
A1 = [log(DepthWave(first_wave_indx,1)), DepthWave(first_wave_indx,4)*0+1];
b1b2 = A1\b1;

b2 = DepthWave(:,4)- b1b2(2) - b1b2(1)*log(DepthWave(:,1));
A2 = [log(DepthWave(:,1)).*log(DepthWave(:,2)), log(DepthWave(:,2))];
a1a2 = A2\b2;

a1a2b1b2 = [a1a2', b1b2']

figure()
suptitle('b1, b2')
subplot(1,2,2); hold on;
plot(log(DepthWave(first_wave_indx, 1)), DepthWave(first_wave_indx, 4), 'bx', 'linewidth', 2)
f1 = a1a2b1b2(3)*log(DepthWave(first_wave_indx, 1)) + a1a2b1b2(4);
plot(log(DepthWave(first_wave_indx, 1)), f1, 'b:')
xlabel('log(D/dx)'); ylabel('Rate')

subplot(1,2,1); hold on;
plot(DepthWave(first_wave_indx, 1), DepthWave(first_wave_indx, 4))
plot(DepthWave(first_wave_indx, 1), a1a2b1b2(3)*log(DepthWave(first_wave_indx, 1))+a1a2b1b2(4), 'b:' )
xlabel('D/dx'); ylabel('Rate')



figure()
suptitle('a1, a2')
colourposs = {'b', 'r', 'k', 'g'};

for ii = 1:4
    data_d = DepthWave(first_wave_indx(ii):first_wave_indx(ii)+8, :);
    
    subplot(1,2,2); hold on;
    plot(log(data_d(:,2)), data_d(:,4), [colourposs{ii}, 'x'], 'linewidth', 2)
    
    a = a1a2b1b2(1)*log(data_d(:,1)) + a1a2b1b2(2);
    b = a1a2b1b2(3)*log(data_d(:,1)) + a1a2b1b2(4);
    f1 = a.*log(data_d(:,2)) + b;
    plot(log(data_d(:,2)), f1, 'b:')
    
    subplot(1,2,1); hold on;
    plot(data_d(:,2), data_d(:,4), [colourposs{ii}, 'x'], 'linewidth', 2)
    plot(data_d(:,2), f1, [colourposs{ii}, ':'] )
end

subplot(1,2,1); 
xlabel('Wave Number'); ylabel('Rate'); 
grid on;

subplot(1,2,1); 
xlabel('log(Wave Number)'); ylabel('Rate'); 
grid on;
