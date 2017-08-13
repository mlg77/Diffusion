function [ D_WvaeNo_Depth ] = Dupont_run_forD( D )
%Goldbeter_run_forD Take the diffusion and run the program for that
%diffusion
%   The give the depths of the first 10 waves plotting once and pausing to
%   see if correct depth is reached before giving output
%   Author: Michelle Goodman
%   Date: 8/5/2017

%% Inital Conditions
t0 = 0;   t1 = 70; dt = 1e-3;
dx = 1e-3;  
x = 0:dx:1;    
Diff_type = 1; 
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
mybeta = x'*0.792;
Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
y0 = [Z_0+ x*0, A_0+ x*0, Y_0+ x*0];

%% Run Goldbeter
[t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
ZFD = yFD(:, 1:M)';

%% Plot
figure(); 
imagesc(t, x, ZFD);
hold on;

%% Follow first 10 waves
% If the first point is a null point
[ wave_data ] = Follow_wave( ZFD, x, t, 0.50, 1, [2, 2] );
starter = 0;
if wave_data.po(end) == 0.5
    starter = 1;
    [ wave_data ] = Follow_wave( ZFD, x, t, 0.50, 2, [2, 2] );
end

D_WvaeNo_Depth(1, 1:3) = [D, 1, wave_data.po(end)];
plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)

for jj = 2:10
    [ wave_data ] = Follow_wave( ZFD, x, t, 0.50, jj+starter, [2, 2] );
    D_WvaeNo_Depth(jj, 1:3) = [D, jj, wave_data.po(end)];
    
    plot(wave_data.t, wave_data.po, 'k', 'linewidth', 2)
end
D_WvaeNo_Depth
% pause()

end

