% Michelle's PDE Code attempt 1
% 21/04/2015

clear; clc; close all



m = 0; % for slab, 1=cylindrical, 2 = spherical (To change this change the general equation)
% xmesh = linspace(0,1,100);
% tspan = linspace(1,200,200);


% xmesh = [0 0.005 0.01 0.05 0.1 0.2 0.5 0.7 0.9 0.95 0.99 0.995 1];
% tspan = [0 0.005 0.01 0.05 0.1 0.5 1 1.5 2];

xmesh = linspace(0,1,100);
tspan = linspace(1,100,200);


% So there is a pde solver
sol = pdepe(m,@pdefun1, @icfun1, @bcfun1, xmesh, tspan);

u1 = sol(:,:,1);
u2 = sol(:,:,2);

% A surface plot is often a good way to study a solution.
figure
surf(tspan, xmesh,u1')
title('u1(x,t)')
ylabel('Distance x')
xlabel('Time t')

figure
imagesc(tspan, xmesh,u2')
title('u2(x,t)')
ylabel('Distance x')
xlabel('Time t')

Z = u1';
figure(3)
plot(tspan, max(Z(5:95, :)), tspan, min(Z(5:95, :)))


