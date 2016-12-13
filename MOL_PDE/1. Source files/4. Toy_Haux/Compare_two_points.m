% compare two points

clear; clc;
close all
clf
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';

AllDir.SourceDir = '1. Source files\4. Toy_Haux';
AllDir.SaveDir = '4. Output files\ODE45_solver';

addpath([AllDir.ParentDir, AllDir.SourceDir, '\Analysis'])


% xpairs = ([-1,1; -1, 0.5; 0.5, 1; -0.5, 0.5; 0.25, 1]);
xpairs = ([-0.5,0.5; -0.5, 0.25; 0.25, 0.5; -0.25, 0.25; 0.1, 1]);
xpairs = (xpairs+1)/2;
% xpairs = (xpairs+1)/2;
for ii = 1:size(xpairs, 1)
    x = xpairs(ii,:);
    %%
    t0 = 0;   t1 = 2000; dt = 0.01;
    tspan = [t0:dt: t1];
    
    M = length(x);
    % mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
    mybeta = x';
    % mybeta = 2*(x'-0.5);
    x = mybeta';
    
    X_0 = -2; Y_0 = -2;
    X_0 = 0.5; Y_0 = 0.1;
    y0 = [x*0+X_0, x*0+Y_0];
    
    %% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion
    Diff_type = 1; D =0;% 6e-6;%  0;%
    display(['Diffusion = ', num2str(D)])
    
    mtol = 1e-6;
    odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
    [t, y0D] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    
    
    
    %% Diffusion type 1 =(SD) Fickian, 2= (ED)Electro Diffusion
    Diff_type = 1; D = 6e-6;%  0;%
    display(['Diffusion = ', num2str(D)])
    
    mtol = 1e-6;
    odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
    [t, yFD] = ode45(@(t,y) odefun_ToyH(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    % yFD = y0D;
    ZFD = yFD(:, 1:M)';
    VFD = yFD(:, M+1:2*M)';
    
    figure(1)
    
%     subplot(5,2,ii*2-1)
    subplot(5,4,ii*4-1)
        plot(t, (Z0D(1,:)- ZFD(1,:)))%./Z0D(1,:))
        xlabel('Time'); ylabel('\Delta [ion] ')
        title(['Cell 1: ', num2str(x(1))])
        grid on
%         ylim([-5, 5])
%     subplot(5,2,ii*2)
    subplot(5,4,ii*4)
        plot(t, (Z0D(2,:)- ZFD(2,:)))%./Z0D(2,:))
        xlabel('Time'); ylabel('\Delta [ion] ')
        grid on
        title(['Cell 2: ', num2str(x(2))])
%     figure(2)
%     subplot(5,2,ii*2-1)
    subplot(5,4,ii*4-3)
        hold on
        plot(t, Z0D(1,:))
        plot(t, ZFD(1,:))
        title(['Cell 1: ', num2str(x(1))]); xlabel('Time'); ylabel(' [ion] ')
%     subplot(5,2,ii*2)
    subplot(5,4,ii*4-2)
        hold on
        plot(t, Z0D(2,:))
        plot(t, ZFD(2,:))
        title(['Cell 2: ', num2str(x(2))]); xlabel('Time'); ylabel(' [ion] ')
end