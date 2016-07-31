% ODE45s solver 
% Author: Michelle Goodman
% Date: 5/4/16

clear; clc; close all; 
tic
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\2. ToyModel_Compatable';
AllDir.SaveDir = '4. Output files\ODE45_solver\18moReport\Stage2';
%% Span and Inital Conditions
t0 = 0;   t1 = 300; dt = 0.1;
tspan = [t0:dt: t1];
tspan = [t0, t1];
dx = 1e-3;  
x = 0:dx:1;    M = length(x); 
% mybeta = (4*0.5*(1+tanh((x-0.5)/0.5)))';
mybeta = x';

mybeta = [-1:-1/(M-1):-2]'; % Works for g
% mybeta = -[0.5:1/(M-1):1.5]'; % Works for e
% mybeta = [0:-0.4/(M-1):-0.4]'; % Works for f
% mybeta = [0.4:-0.4/(M-1):0]'; % Works for d
% mybeta = [-2:-1/(M-1):-3]';
% mybeta = [0 :0.25/(M-1):0.25]';
%% Beta 0, linear, 0
% mybeta = (x-0.2)';
% mybeta(1:301) = 0; mybeta(801:end) = 0;

%% Beta fix?
% start_fixed_beta = find(x== 0.162);
% fixed_beta = mybeta(start_fixed_beta);
% mybeta(find(x== 0.156):start_fixed_beta) = fixed_beta;

Z_0 = -2; V_0 = -0.1; 
% Z_0 = -0.47; V_0 = -0.1; 
y0 = [x*0+Z_0, x*0+V_0];
% y0 = [mybeta, (-mybeta.^3./3 - mybeta.^2./2)./mybeta ];

%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion 
Diff_type = 1;

%% Amount of Diffusion
D =  1e-6; %  0;% 
display(['Diffusion = ', num2str(D)])
%%
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, y] = ode45(@(t,y) odefun_Toy(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);

Z = y(:, 1:M)';
V = y(:, M+1:2*M)';



bt_point = 0.5;  top_pt = 0.5; top_point = 0; bt_pt = 0;
t_end = t(end);
figure(1)
    subplot(1,2,2)
        plot(mybeta,x)
        ylabel('Position, x')
        xlabel('beta, [-]')
        hold on
%         plot([0, 0, 0], [0, 0.2,0.2], 'k','LineWidth',2)
        plot([-0.2,-0.2,0], [0, 0.5,0.5],  'k','LineWidth',2)
    subplot(1,2,1)
% figure()
        imagesc(t,x,Z)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title(['[Ca^2^+], Calcium Concentration in the Cytosol ',num2str(D),' diffusion, [\muM]'])
        colormap jet
        hold on
        plot([0,t_end], [top_pt, top_pt], 'k','LineWidth',2)
%         plot([0,t_end], [bt_pt, bt_pt],  'k','LineWidth',2)
display(['Simulation complete: ', num2str(toc), ' seconds'])

%% Find Fluxes
% % break
L_Z=[]; L_V=[]; v_2=[]; v_3=[]; d2Zdx2 = [];
for j = 1:length(t) % Loop through each time to find L, v2 and v3
    [ dydt , L_Zt, L_Vt, d2Zdx2t] = odefun_Toy( j, y(j,:)' , mybeta, 1, D);
    L_Z(:, j) = L_Zt;
    L_V(:, j) = L_Vt;
    d2Zdx2(:, j) = d2Zdx2t; 
end
display(['Fluxes Found: ', num2str(toc), ' seconds'])
% cd([AllDir.ParentDir ,AllDir.SaveDir])
% save('SD_data_ode')
% cd([AllDir.ParentDir, AllDir.SourceDir])

%% Plot at different x values
xval= [0.1,0.4, 0.6, 0.6];figure(2)
for i = 1:length(xval)
    subplot(2,4,i)
    plot(t, Z(xval(i)*1000+1,:))
    title(['x = ', num2str(xval(i))])

    %% Is symetrical??    
    checkZ = xval(i)*1000+1;
    [pks, loc] = findpeaks(-Z(checkZ,:));
    % Use last peek
    pknu = length(loc)-1;
    if pknu>2
        wavef = loc(pknu):loc(pknu+1);
        waveb = loc(pknu-1):loc(pknu);

        twavef = (t(wavef)-t(wavef(1)))/(t(wavef(end)) - t(wavef(1)));
        twaveb = (t(waveb)-t(waveb(1)))/(t(waveb(end)) - t(waveb(1)));
        twaveb = abs(twaveb-1);
        [a,b] = min(Z(checkZ, wavef)); [a,b2] = min(Z(checkZ, waveb));
        symetricalWave(i) = abs(twavef(b)-twaveb(b2))/2;
    end
end

symetricalWave
subplot(2,1,2)
hold on
plot(twavef, Z(checkZ, wavef), 'b')
plot(twaveb, Z(checkZ, waveb), 'r')
title('Is symetrical?? Do they overlap?')
legend('Forward', 'Backward')


figure(99)
hold on
tlag = 0.2;
plot(twavef, Z(checkZ, wavef),'r', 'linewidth', 2) % Current position
plot(twavef+tlag, Z(checkZ, wavef), 'b:', 'linewidth', 2) % below position
plot(twavef-tlag,Z(checkZ, wavef), 'k:', 'linewidth', 2)% above position
% [a,b] = max(Z(checkZ, wavef)); % max a and position b
% pomax_u = find(twavef(b)-tlag <= twavef,1)-1; % the wave above position max
% pomax_d = find(twavef(b)+tlag <= twavef,1); % the wave below position max
% plot([twavef(pomax_u), twavef(pomax_u)], [a, Z(checkZ, pomax_u+wavef(1)-1)], 'k', 'linewidth', 2)
% plot([twavef(pomax_d), twavef(pomax_d)], [a, Z(checkZ, pomax_d+wavef(1)-1)], 'b', 'linewidth', 2)
% changeh1 = a- Z(checkZ, pomax_u+wavef(1)-1);
% changeh2 = a- Z(checkZ, pomax_d+wavef(1)-1);
% plot([twavef(b), twavef(b)], [a, a- changeh1], 'r', 'linewidth', 2)

figure(100)
plot(twavef, d2Zdx2(checkZ, wavef),'k', 'linewidth', 2) % Current position