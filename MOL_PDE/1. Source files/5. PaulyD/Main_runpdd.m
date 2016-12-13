clear; clc;
close all
clf

t0 = 0;   t1 = 2000; dt = 0.05;
tspan = [t0:dt: t1];
dx = 1e-3;
x = (0:dx:1);    M = length(x);
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
mybeta = x';
% mybeta = 2*(x'-0.5);

X_0 = 0.5; Y_0 = 0.1;
y0 = [x*0+X_0, x*0+Y_0];


%% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion
Diff_type = 1; D = 6e-6;%  0;%
display(['Diffusion = ', num2str(D)])

mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
[t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
% yFD = y0D;
ZFD = yFD(:, 1:M)';
VFD = yFD(:, M+1:2*M)';

save('outcomes.mat','ZFD','VFD','t')

% load outcome.mat

bin=[zeros(1001,2) diff(heaviside(diff(ZFD,1,2)),1,2)];
for i=1:1001
    xx=[1 find(bin(i,:)==1) length(ZFD)];
    for j=1:length(xx)-1
    P(i,xx(j):xx(j+1))=xx(j+1)-xx(j);
    end
end

subplot(1,2,1);imagesc(t,flipud(x),ZFD)
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title(['[Ca^2^+]_{Cytosol} FD (6x10^{-6}), [\muM]'])
colormap jet
colorbar
subplot(1,2,2);imagesc(t,flipud(x),P,prctile(P(:),[10 90]))
set(gca,'YDir','normal')
xlabel('Time, [s]')
ylabel('Position, x')
title(['[Ca^2^+]_{Cytosol} FD (6x10^{-6}), [\muM]'])
colormap jet
colorbar
