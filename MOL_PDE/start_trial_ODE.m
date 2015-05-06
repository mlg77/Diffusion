% Start of my MOL code
% Michelle Goodman
% 1/05/2015

clear; clc; close all
start = cputime;
% Set x and t
dt = 0.001;
dx = 0.1;
t_end = 10;

%% Inital Condition
Z_0 = 0;
Y_0 = 0;

%%
x = 0:dx:1;
t = 0:dt:t_end;

%% Start solver 
% Number of elements in x = M
M = length(x); 
% Set up IC as a vector length M
Z(:,1) = ones(M,1) *Z_0;
Y(:,1) = ones(M,1) * Y_0;

% create coeff u_i Matrix

%% Use ODE Solver
% ode45(odefun, tspan, y0)
y0(1:M) = Z; y0(M+1:2*M) = Y;

options = odeset('RelTol',1e-10,'AbsTol',1e-10*ones(1,2*M));
[T,Soln] = ode45(@my_ode, [0, t_end], y0,options);


display(['Simulation Complete in ',num2str(cputime - start), ' seconds'])

figure(1)
imagesc(T,x,Soln(:, 1:M)' ) 
colormap jet

figure(2)
plot(T, Soln(:,1))
title('Z')
    
    
