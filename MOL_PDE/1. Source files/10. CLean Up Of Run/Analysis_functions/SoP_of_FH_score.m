%% Find the scores for Goldbeter
% See second work book
% Author: Michelle Goodman
% Date 2nd March 2017

notskip = 0;
if notskip
clear; clc; close all
%% First find the zero diffusion case for all beta making sure to reach
% steady state solutions and oscillations

display('Stage 1')
% Run Parameters
t0 = 0;   t1 = 100; dt = 0.01;      % Time array
tspan = [t0:dt: t1];
N = length(tspan);
dx = 1e-3;                          % Spatial array
x = 0:dx:1; 
M = length(x); 
mybeta = x';                        % Beta array
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;    % Inital Conditions
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
Diff_type = 1; D =0;                % Diffusion 
mtol = 1e-6;                        % Solver options
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Z0D = y0D(:, 1:M)';                 % Save Data
V0D = y0D(:, M+1:2*M)';
Y0D = y0D(:, 2*M+1:3*M)';
end


%% Need to decide which score to calculate
display('Stage 2')
tol_change = 0.05 * (max(max(Z0D)) - min(min(Z0D))); %1% of total change 

idx_x_ss = [];                      % Initalise index 
FH_score = [];
consider_outliers = [];
for ii = 1:M
    % Consider last 25% of solution
    Z_consider = Z0D(ii, floor(N*3/4):end);
    % Is it oscillatory?
    is_osc = (max(Z_consider) - min(Z_consider))> tol_change;
    
    if is_osc
        % Find the FH-score
        [PKS,LOCS]= findpeaks(Z_consider);
        if length(LOCS) <= 3
            consider_outliers(end+1) = ii;
        else
            tou_max = LOCS(end-1);
            Period_os = LOCS(end) - LOCS(end-1);
            Epsilon_t = 0:0.5*Period_os;
            change_change = Z_consider(tou_max + Epsilon_t) - Z_consider(tou_max - Epsilon_t);
            FH_score(end+1,1:2) = [ii, max(change_change)];
        end
    else
        % Save array of vectors to find SoP-score later
        idx_x_ss(end+1) = ii;
    end
end


figure(); hold on
plot(x(idx_x_ss), 'bx')
plot( x(FH_score(:,1)) , 'rx')
% plot( x(consider_outliers) , 'gx')
legend('Steady state', 'Oscilatory') %, 'Outliers')

%% Now for every idx_x_ss find the SoP-score for all FH_score 
display('Stage 3')

t02 = 0;   t12 = 50; dt2 = 0.01;      % Time array
tspan2 = [t02:dt2: t12];
N2 = length(tspan2);
x2 = 1;                           % Spatial array

Grid_SoP = zeros(length(FH_score), length(idx_x_ss));
for ii = 1:length(idx_x_ss)
    mybeta2 = mybeta(idx_x_ss);   
    for jj = 1:length(FH_score(:,2))
        % Run Parameters
        y02 = [Z0D(ii,end)+ FH_score(jj,2), V0D(ii,end), Y0D(ii,end)];   % Inital Conditions
        [t2, y0D2] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta2,Diff_type, D), tspan2, y02, odeoptions);
        Z_array = y0D(:, 1)';                 % Save Data
        V_array = y0D(:, 2)';
        Y_array = y0D(:, 3)';
        
        Grid_SoP(jj, ii) = max(Z_array) - (Z0D(ii,end)+ FH_score(jj,2));
    end
end

figure();
surf( x(idx_x_ss)  ,  x(FH_score(:,1)) , Grid_SoP)
xlabel('Non Oscillatory x positions')
ylabel('Oscillatory x positions')
title('Stability of Pertibation')

figure(); subplot(1,2,1); 
pt_no_oss = find(x(idx_x_ss)>0.5,1); newx = x(idx_x_ss);
surf( newx(1:pt_no_oss-1)  ,  x(FH_score(:,1)) , new_Grid(:, 1:pt_no_oss-1))
shading interp
xlabel('Non Oscillatory x positions')
ylabel('Oscillatory x positions')
title('Stability of Pertibation')
subplot(1,2,2); 
surf( newx(pt_no_oss:end)  ,  x(FH_score(:,1)) , new_Grid(:, pt_no_oss:end))
shading interp
xlabel('Non Oscillatory x positions')
ylabel('Oscillatory x positions')
title('Stability of Pertibation')
