clear; clc; close all

%% Inital Conditions to eaisly change
t0 = 0;   t1 = 1500; dt = 0.01;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
x = 0:dx:1;   
mybeta = x';

%% Inital Conditions dont change
Diff_type = 1; D =0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

%% Run Simulation

    Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
	y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
    display(['Koe '])
    tic
    [t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    runtime = toc;
    Sol.Z = y0D(:, 1:M)';
    Sol.Y = y0D(:, M+1:2*M)';
    Sol.V = y0D(:, 2*M+1:3*M)';
    Sol.N0 = y0D(:, 3*M+1:4*M)';
    Sol.I = y0D(:, 4*M+1:5*M)';
    
    per_end = 0.5;
    
    BifuMax.Z = max(Sol.Z(:, floor(N*per_end):end)')';
    BifuMax.V = max(Sol.V(:, floor(N*per_end):end)')';
    BifuMax.N0 = max(Sol.N0(:, floor(N*per_end):end)')';
    BifuMax.Y = max(Sol.Y(:, floor(N*per_end):end)')';
    BifuMax.I = max(Sol.I(:, floor(N*per_end):end)')';
    
    BifuMin.Z = min(Sol.Z(:, floor(N*per_end):end)')';
    BifuMin.V = min(Sol.V(:, floor(N*per_end):end)')';
    BifuMin.N0 = min(Sol.N0(:, floor(N*per_end):end)')';
    BifuMin.Y = min(Sol.Y(:, floor(N*per_end):end)')';
    BifuMin.I = min(Sol.I(:, floor(N*per_end):end)')';
    
    cd(['C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run\Analysis_functions']);
    [ pointsfound ] = Bifurcation_points( x,t,Sol.Z );
    [ TVector ] = FindPeriodVector( Sol.Z ,dt) ;
    

%% Make Plots
The6_xpoints = [0.1,0.2,0.4,0.6,0.8,0.9];
The6_points = floor(The6_xpoints.*M)+1;

for ii = 1:6
    figure(ii)
    plot(t, Sol.Z(The6_points(ii), :))
    xlabel('Time [s]')
    ylabel('Concentration ')
    title(['mybeta = ' , num2str(mybeta(The6_points(ii)))])
    
    figure(7); hold on
    plot(t, Sol.Z(The6_points(ii), :))
    myleg{ii} = ['mybeta = ' , num2str(mybeta(The6_points(ii)))];
end

xlabel('Time [s]')
ylabel('Concentration ')
title(['All in one'])
legend(myleg)

figure(8)
hold on;
plot(mybeta, BifuMax.Z, 'b')
plot(mybeta, BifuMin.Z, 'b')
xlabel('Beta, \beta')
ylabel('Concentration [\mu M]')

for ii = 1:length(mybeta)
    xdft = fft(Sol.Z(ii, floor(length(t)/2):end)); idx = max(abs(xdft));
    T(ii) = length(Sol.Z(ii, floor(length(t)/2):end))*(t(2)-t(1))/(idx-1);
end
TVector = T;
TVector(1:170) = 0;
TVector(854:end) = 0;

figure(9)
plot(mybeta, TVector)
xlabel('Beta, \beta')
ylabel('Period [s]')

figure(10)
[hAx,hLine1,hLine2]  = plotyy([mybeta; nan; mybeta], [BifuMax.Z;nan; BifuMin.Z], mybeta, TVector);
xlabel('Beta, \beta')
ylabel(hAx(1),'Concentration [\mu M]') % left y-axis 
ylabel(hAx(2),'Period [s]') % right y-axis

figure(11)
hold on;
plot(mybeta, BifuMax.Y, 'b')
plot(mybeta, BifuMin.Y, 'b')
xlabel('Beta, \beta')
ylabel('Concentration [\mu M]')

figure(12)
hold on;
plot(mybeta, BifuMax.V, 'b')
plot(mybeta, BifuMin.V, 'b')
xlabel('Beta, \beta')
ylabel('Concentration [mV]')

figure(13)
hold on;
plot(mybeta, BifuMax.N0, 'b')
plot(mybeta, BifuMin.N0, 'b')
xlabel('Beta, \beta')
ylabel('Probability [-]')

figure(14)
hold on;
plot(mybeta, BifuMax.I, 'b')
plot(mybeta, BifuMin.I, 'b')
xlabel('Beta, \beta')
ylabel('Concentration IP_3 [\mu]')

cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\15. Koe')





