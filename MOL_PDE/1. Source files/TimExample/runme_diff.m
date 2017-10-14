%The runme file for the Goldbeter equations
%using the format recomended by Richard
clc
clear
close all


xlim = [0 1];
y0 = [-1,-1];
%diffusion = repmat({0}, 2, 1); 
diffusion = {6e-6,0};
%diffusion = {0,0};
varnames = {'Z', 'Y'};

%  a = 1;
%  b = 0;
%  beta = @(x) a + (b - a) * x;
% beta = @(x) 0.5+ 0.4*(1.0+tanh((x-0.5)/0.25));
beta = @(x) 0.2*(1+tanh((x-0.5)/0.4));
x_data = xlim(1):0.001:xlim(2);
figure()
plot(x_data,beta(x_data))

% fn = Goldbeter_diff(beta);
fn = Toy(beta);


sim = ReactionDiffusion('kinetics_fcn', fn, ...
    'xlim', xlim', ...
    'diffusion', diffusion, ...
    'varnames', varnames, ...
    'method', 'fd', ...
    'solver', @ode15s, ...
    'n', 3000, ...
    'y0', y0);

sim.Tspan = linspace(0, 1000, 1000/1e-2);
tic
sim.simulate();
time = toc

% sim.animation_framerate = 7;
% sim.animate()
figure()
sim.image(1,true)
