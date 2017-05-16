% Create a grid for goldbeter
clear; clc; close all
%% Inital Conditions to run once
t0 = 0;   t1 = 100; dt = 0.005;
dx = 5e-3; 


x = [0:dx:0.7];    
% x = 0.3;    
M = length(x);
mybeta = x'; % Used for half bi at 0.5
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
Diff_type = 1; D =0;% 6e-6;%  0;%
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Diff_type = 1; D =0;

%% Run once
display('Running Goldbeter ...')
[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Z0D = y0D(:, 1:M)';
V0D = y0D(:, M+1:2*M)';
Y0D = y0D(:, 2*M+1:3*M)';

display('Calculate Scores ...')
Perts = 0:0.02:1.5;
Oss_FH_Pmin_SoP = zeros(length(x), 3+ length(Perts));
idx_ossVector = [];
idx_ssVector = [];
disp_not = 0;
for ii = 1:length(x)
    if abs(max(Z0D(ii, floor(length(tspan)/2):end)) - min(Z0D(ii, floor(length(tspan)/2):end))) > 0.1*abs(max(max(Z0D)))
        if disp_not == 0
            disp_not = 1;
            display('osc region')
        end
        [ FH_score ] = FH_scoreCalc( Z0D(ii, :) );
        Oss_FH_Pmin_SoP(ii, 1:2) = [1, FH_score];
        idx_ossVector(end+1) = ii;
    else
        display(num2str(x(ii)))
        [ SoP_scoreVector ] = SoP_scoreCalc( 'G', x(ii), Perts );
        indx = find(SoP_scoreVector > 0.01 , 1);
        if isempty(indx)
            Pmin = 1e10;
        else
            Pmin = Perts(indx);
        end
        
        Oss_FH_Pmin_SoP(ii, :) = [0, 0, Pmin, SoP_scoreVector'];
        idx_ssVector(end+1) = ii;
        
    end
end

% %% Create Grid
% display('Creating Grid ...')
% Grid_oss_otherx = zeros(length(idx_ossVector), length(idx_ssVector));
% 
% for ii = 1:length(idx_ossVector)
%     idx_oss = idx_ossVector(ii);
%     FH_score_oss = Oss_FH_Pmin_SoP(idx_oss, 2);
%     idx_pert = find(FH_score_oss >= Perts, 1);
%     for jj = 1:length(idx_ssVector)
%         idx_ss = idx_ssVector(jj);
%         Grid_oss_otherx(ii, jj) = Oss_FH_Pmin_SoP(idx_ss, idx_pert+3 );
%     end
% 
% end
% 
% imagesc(x(idx_ssVector), x(idx_ossVector), Grid_oss_otherx)


