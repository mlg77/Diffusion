% Models in order are 
% 1 = Gold
% 2 = Dupont
% 3 = Ern
% 4 = FHN U
% 5 = FHN W
% 6 = Koe
% 7 = Toy 1
% 8 = Toy 2
clear; clc; close all

%bifurcations - a little
bif(1) = 0.3; dt(1)= 0.002; t1(1) = 30;     perp(1) = 0.02;  myaxis(1,:) = [11.45,11.8,0.2,1.4];% 1 = Gold
bif(2) = 0.43; dt(2)= 0.002; t1(2) = 30;    perp(2) = 0.02;  myaxis(2,:) = [12,12.5,0.3,1.9];% 2 = Dupont
bif(3) = 0.31; dt(3)= 0.001; t1(3) = 200;   perp(3) = 0.05;  myaxis(3,:) = [66,69,50,400];% 3 = Ern
bif(4) = 0.17*2; dt(4)= 0.01; t1(4) = 1000; perp(4) = 0.1;  % 4 = FHN U
bif(5) = 0.17*2; dt(5)= 0.01; t1(5) = 1000; perp(5) = 0.1;  % 5 = FHN W
bif(6) = 0.8; dt(6)= 0.01; t1(6) = 1000;    perp(6) = 0.04;  myaxis(6,:) = [296,311,0.2,0.85];% 6 = Koe
bif(7) = 0.6; dt(7)= 0.001; t1(7) = 300;    perp(7) = 0.1;  % 7 = Toy 1
bif(8) = 0.6; dt(8)= 0.01; t1(8) = 1000;    perp(8) = 0.1;  myaxis(8,:) = [0,0,0,0];% 8 = Toy 2

Solution = [];

for ii = 1:8
    mybeta = bif(ii);
    Diff_type = 1; D =0;
    t = 0:dt(ii):t1(ii);
    N = length(t); 
    tspan = t;
    mtol = 1e-6;
    odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
    if ii == 1
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run');
        Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
        y0 = [Z_0, V_0, Y_0];
        [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
        Z = y0D(:, 1)';
    elseif ii == 2
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run');
        Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5; V_0 = -40;
        y0 = [Z_0,A_0,Y_0, V_0];
        [t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z = y0D(:, 1)';
    elseif ii == 3
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run');
        Z_0 = 300; V_0 = -40; N_0 = 0.5;
        y0 = [Z_0, V_0, N_0];
        [t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z = y0D(:, 1)';
    elseif ii == 4 %U
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run');
        X_0 = -1; Y_0 = 1; 
        y0 = [X_0, Y_0];
        [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z = y0D(:, 1)';
    elseif ii == 5 %W
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run');
        X_0 = -1; Y_0 = 1; 
        y0 = [X_0, Y_0];
        [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z = y0D(:, 2)';
    elseif ii == 6
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\15. Koe')
        Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
        y0 = [Z_0, Y_0, V_0, N_0, I_0];
        [t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z = y0D(:, 1)';
    elseif ii == 7
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\17. ToyClean')
        X_0 = -1; Y_0 = 1; 
        y0 = [X_0, Y_0];
        [t, y0D] = ode45(@(t,y) odefun_Toy1(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z = y0D(:, 1)';
    elseif ii == 8
        cd('C:\Temp\Diffusion\MOL_PDE\1. Source files\17. ToyClean')
        X_0 = -1; Y_0 = 1; 
        y0 = [X_0, Y_0];
        [t, y0D] = ode45(@(t,y) odefun_Toy2(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
        Z = y0D(:, 1)';
    end
    Solution(1,1:length(Z),1) = Z;
    
    Z = Z(floor(length(Z)/2):end);
    t = t(floor(length(Z)/2):end);
    [Troughs,LOCS] = findpeaks(-Z);
    Z = Z(LOCS(2):LOCS(3)); 
    t = t(LOCS(2):LOCS(3));
    periodT = t(end)-t(1);
    
    figure(); hold on
    plot(t - perp(ii)*periodT, Z, ':k', 'linewidth', 2)
    plot(t + perp(ii)*periodT, Z, ':b', 'linewidth', 2)
    plot(t, Z, 'r', 'linewidth', 3)
    title(num2str(ii))
    
    if myaxis(ii,1:4) == [0,0,0,0]
    else
        axis(myaxis(ii,1:4))
    end
    
end

cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\6. WaveShape')
for i = 1:8
figure(i)
set(gcf,'PaperPositionMode','auto')
print(['waveshapematlab_', num2str(i)],'-dpng', '-r300')
end
