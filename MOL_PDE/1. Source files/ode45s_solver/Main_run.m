% ODE45s solver 
% Author: Michelle Goodman
% Date: 5/4/16

clear;  clc;  close all;
tic

t0 = 0;   t1 = 100;
tspan = [t0, t1];

dx = 1e-3;  
x = 0:dx:1;   M = length(x); 
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
y0 = [x*0+Z_0, x*0+V_0, x*0+Y_0];

odeoptions = odeset('RelTol',1e-8);
[t, y] = ode45(@odefun_Goldbeter, tspan, y0, odeoptions);

Z = y(:, 1:M)';

figure(3)
    subplot(1,2,2)
        plot(mybeta,x)
        ylabel('Position, x')
        xlabel('beta, [-]')
    subplot(1,2,1)
        imagesc(t,flipud(x),Z)
        set(gca,'YDir','normal')
        xlabel('Time, [s]')
        ylabel('Position, x')
        title('Z, Calcium Concentration in the Cytosol 6e-6 diffusion, [\muM]')
        colormap jet

toc