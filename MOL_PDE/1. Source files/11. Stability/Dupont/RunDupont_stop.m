% Run Goldeter
clear; clc; close all

cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Dupont')
load('sen_perts_data.mat')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Dupont')



%% If chosen plot the prediction end depth on the space time profile
Plot_predict = 1;

%% Cycle stuff
Scalor = 0.78;
betas_coll = betas_coll*Scalor;
dx = 1e-3;
x = 0:dx:1;
dBetadxTypes(:, 1) = x*Scalor;
    new_beta = 23.8*x.^3 -18.33*x.^2 +4.21*x;
    new_beta(501:end) = x(501:end);
    new_beta = new_beta*Scalor;
dBetadxTypes(:, 2) = new_beta(:);
    new_beta = 3/5*x + 0.2;
    new_beta = (new_beta*Scalor)';
dBetadxTypes(:, 3) = new_beta(:);
    new_beta = (x*Scalor)';
    new_beta(451:455) = 0;
dBetadxTypes(:, 4) = new_beta(:);

x_half = 0:dx:0.5;
dBetadxTypes_half = dBetadxTypes(1:length(x_half), :);

possible_D = [2,4,6,8]*1e-6;
possible_D = [6]*1e-6;
count = 0;
%%  Run Predictions
plotted_Z = [];
for ii = 1:length(betas_coll)
    plotted_Z(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end

possible_wavenumber = [1:3];
possible_D = [2,4,6,8]*1e-6;
% possible_D = 6e-6
% [Equation, Diffusion, wave front number, Depth]
DepthResults = [];
count = 0;
for jj = 1:4
    New_dbetadx = dBetadxTypes_half(:,jj);
    code_leg = {'k:', 'b', 'r', 'm'};
    for kk = 1:length(possible_D)
        for ii = 1:length(possible_wavenumber)
%             const = [-0.0305,0.0068,0.0858,0.033]; % This is goldbeter
            const = [-0.0398   -0.0064    0.0931    0.0576];

            wavefrontnumber = possible_wavenumber(ii);
            a = (const(1)*log(possible_D(kk)/dx^2) + const(2));
            b = (const(3)*log(possible_D(kk)/dx^2) + const(4));
            Rate =  a*log(wavefrontnumber) + b;
            [ Perts_dbdx, Plot_dbetadx, plotxer ] = ItterationDownBeta( perts, betas_coll, plotted_Z, New_dbetadx,x_half, Rate, 0.2 );
            count = count+1;
            % [Equation, Diffusion, wave front number, Depth]
            DepthResults(count, 1:4) = [jj, possible_D(kk)/1e-6, possible_wavenumber(ii), plotxer(end)];
        end
    end
end

%% Inital Conditions
t0 = 0;   t1 = 50; dt = 0.01;
dx = 1e-3;  
x = 0:dx:1;    
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
Diff_type = 1; D =0;% 6e-6;%  0;%
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

%% Run Actual Diffusion
count = 0;
for ii =  1:4 
	mybeta = dBetadxTypes(:,ii);
    for kk = 1:length(possible_D)
        display(['Dupont', num2str(ii), '.', num2str(kk)])
        Dupont.On = 1;
        Diff_type = 1; D =possible_D(kk);
        [t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        ZFD = yFD(:, 1:M)';
        figure(); imagesc(t, x, ZFD)
        for jj = 1:length(possible_wavenumber)
            [ wave_data ] = Follow_wave( ZFD, x, t, 0.54, jj, [1.5, 1] );

            count = count + 1;
            DepthResults(count, 5) = wave_data.po(end);
            DepthResults(count, 6) = abs(DepthResults(count, 5) - DepthResults(count, 4))*100;
            hold on;
            
            if not(Plot_predict)
                plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)
            else
                plot([t(1), t(end)], DepthResults(count, 4)*[1,1], 'r')
            end
        end
    end
end

if Plot_predict
   for ii = 1:4
       figure(ii)
       ylabel('Position, x')
       xlabel('beta, [-]')
       set(gca,'YDir','normal')
       colormap jet
       colorbar
       plot([t(1), t(end)], [0.5,0.5], 'k', 'linewidth', 2)
   end
end