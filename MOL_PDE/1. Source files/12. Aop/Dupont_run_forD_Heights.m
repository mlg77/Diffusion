function [ D_WvaeNo_Depth, Heights ] = Dupont_run_forD_Heights( D )
%Goldbeter_run_forD Take the diffusion and run the program for that
%diffusion
%   The give the Heights of the first 5 waves plotting once No need to
%   pause as second run
%   Author: Michelle Goodman
%   Date: 8/5/2017

%% Inital Conditions
t0 = 0;   t1 = 70; dt = 1e-3;
dx = 1e-3;  
x = 0:dx:1;    
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];
Diff_type = 1; 
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
mybeta = x'*0.792;

%% Run Goldbeter

%% Temp test for first wave
start_at_zero = 1;
st_zero = 2; % First wave start point
if start_at_zero
    st_zero = 0;
    display(['Diffusion = ', num2str(0)])
    [t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, 0), tspan, y0, odeoptions);
    Goldbeter.Z0D = y0D(:, 1:M)';
    Goldbeter.V0D = y0D(:, M+1:2*M)';
    Goldbeter.Y0D = y0D(:, 2*M+1:3*M)';

    startidx = floor(length(t)*0.8);
    [maxZpoint, idxmaxZpoint] = max(Goldbeter.Z0D(:, startidx:end)');

    matchingV = []; matchingY = [];
    for kk = 1:length(x)
        matchingV(kk) = Goldbeter.V0D(kk, idxmaxZpoint(kk)+startidx-1);
        matchingY(kk) = Goldbeter.Y0D(kk, idxmaxZpoint(kk)+startidx-1);
    end

    y0 =  [maxZpoint, matchingV, matchingY]  ;
end
%%
display(['Diffusion = ', num2str(D)])
[t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
ZFD = yFD(:, 1:M)';

%% Plot
figure(); 
imagesc(t, x, ZFD);
hold on;

%% Follow first 5 waves
% If the first point is a null point
[ wave_data ] = Follow_wave( ZFD, x, t, 0.50, 1, [st_zero, 2] );
starter = 0;
if wave_data.po(end) == 0.5
    starter = 1;
    [ wave_data ] = Follow_wave( ZFD, x, t, 0.50, 2, [st_zero, 2] );
end
Heights = zeros(length(0:dx:0.5), 10);
Heights(1:length(wave_data.mag), 1) = wave_data.mag;

D_WvaeNo_Depth(1, 1:3) = [D, 1, wave_data.po(end)];
plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)

for jj = 2:10
    [ wave_data ] = Follow_wave( ZFD, x, t, 0.50, jj+starter, [0, 2] );
    Heights(1:length(wave_data.mag), jj) = wave_data.mag;
    
    D_WvaeNo_Depth(jj, 1:3) = [D, jj, wave_data.po(end)];
    plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)
end

% pause()
end

