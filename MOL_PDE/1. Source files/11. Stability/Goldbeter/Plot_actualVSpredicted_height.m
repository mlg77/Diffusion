%% Plot actual heights on AoP grid along side predicted heights
%

%% Load AoP grid
clc; close all
cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Goldbeter')
load('Sensitiveto1.mat')
cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\11. Stability\Goldbeter')

% Inital conditions
dx = 1e-3;  
x_Aop = 0:dx:0.5;  

% Adjust data 
figure(2)
hold on
plotted_Z = [];
for ii = 1:length(betas_coll)
    what_betas{ii} = num2str(betas_coll(ii));
    plotted_Z(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end

betas_coll = betas_coll*0.56;
plottedZ_0 = plotted_Z;
plottedZ_0(find(plotted_Z <= 1e-10)) = 0;

New_dbetadx = [betas_coll'];
        
lastpertcare = find(perts >=0.3, 1);
myColorMap = summer; % Make a copy of jet.


%% Plot The AoP grid

for kk = 1:length(x_Aop)
    reorderedZ(kk,:) = plottedZ_0(find(New_dbetadx(kk)<=betas_coll,1), :)-0.1;
end
[C,h1] = contourf(perts(1:lastpertcare), x_Aop, reorderedZ(:, 1:lastpertcare), 20); hold on;
[C,h2] = contour(perts(1:lastpertcare), x_Aop, reorderedZ(:, 1:lastpertcare), 20);
axis([0,0.3,0,0.5])

%% Plot predicted height
possible_D = 6e-6;
const = [-0.0305,0.0068,0.0858,0.033];
wavefrontnumber = 1;
a = (const(1)*log(possible_D/dx^2) + const(2));
b = (const(3)*log(possible_D/dx^2) + const(4));
Rate =  a*log(wavefrontnumber) + b;
[ Perts_dbdx, Plot_dbetadx, plotxer ] = ItterationDownBeta( perts, betas_coll, plotted_Z, New_dbetadx, Rate, 0.2 );

hold on;
plot(Perts_dbdx(3:end), plotxer(3:end), 'k', 'linewidth', 2);

xlabel('Pertibations'); ylabel('Position, x [cm]');
% Assign white (all 1's) to black (the first row in myColorMap).
myColorMap(1, :) = [1 1 1];
colormap(myColorMap); % Apply the colormap
colorbar
set(gca,'YDir','normal')
set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false); 
hasbehavior(h2, 'legend', false); 
title('Contour Plot of AoP grid of (P, x)')

%% Run actual Goldbeter fickian and zero diffusion
needtorun = 1;

t0 = 0;   t1 = 60; dt = 1e-3;
dx = 1e-3;  
x = 0:dx:1; 
tspan = [t0:dt: t1];
t = tspan;
if needtorun
mybeta = (x*0.56)'; 
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
display('Goldbeter')
            Diff_type = 1; D =0;
            display(['Diffusion = ', num2str(D)])
            [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
            Goldbeter.Z0D = y0D(:, 1:M)';
            Goldbeter.V0D = y0D(:, M+1:2*M)';
            Goldbeter.Y0D = y0D(:, 2*M+1:3*M)';
            
            Diff_type = 1; D = 6e-6;
            display(['Diffusion = ', num2str(D)])
            [t, yFD] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
            Goldbeter.ZFD = yFD(:, 1:M)';
            Goldbeter.VFD = yFD(:, M+1:2*M)';
            Goldbeter.YFD = yFD(:, 2*M+1:3*M)';
end
%% Use zero diffusion to find out what the base line is 
base_line = mean(Goldbeter.Z0D(1:501, round(length(t)*0.75):end)')';

%% Follow wave down diffusion line
[ wave_data ] = Follow_wave( Goldbeter.ZFD, x, t, 0.5, 2, 2 );
figure()
imagesc(t,x, Goldbeter.ZFD)
hold on; plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)

% Find what I can
AoP_plus_P = [];
for ii = 1:length(wave_data.po)
    AoP_plus_P(ii) = wave_data.mag(ii) - base_line(end-ii + 1);
end

% add a fake point that is zero 
AoP_plus_P(end+1) = 0;
wave_data.po(end+1) =  wave_data.po(end)-dx;
wave_data.mag(end+1) =  0;


figure(); 
plot(wave_data.po, AoP_plus_P)

% Loop through AoP_plus_P and place it on AoP grid
Aop_point = [];
for ii = length(AoP_plus_P):-1:1
    % starting at the last point 
    if ii == length(AoP_plus_P)
        % This point is already at zero and is slightly different to place
        dx = 1e-3;  
        x_AoP = 0:dx:0.5;  
        % perts(1:lastpertcare), x, reorderedZ(:, 1:lastpertcare)
        x_end_idx = find(x_AoP >= wave_data.po(ii),1);
        pert_idx_point = find(reorderedZ(x_end_idx, 1:lastpertcare)>=1e-4, 1);
        % this is the pertibation 
%         figure(2); 
%         plot(perts(pert_idx_point), wave_data.po(end), 'xr', 'linewidth', 2)
        
        Aop_point(ii) = perts(pert_idx_point);
    else
        % Now that the first point has been placed move one row up
        x_current_idx = find(x_AoP >= wave_data.po(ii),1);
        %% I am not convinced with this line!!
        pert_idx_point = find(reorderedZ(x_current_idx, :) +perts  >= AoP_plus_P(ii), 1);
        Aop_point(ii) = perts(pert_idx_point);
    end
end
figure(2);
plot(Aop_point, wave_data.po, 'r', 'linewidth', 2)


