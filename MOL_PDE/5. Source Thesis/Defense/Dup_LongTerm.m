% Create the half beta image to view only the lower bifurcation region
% Have the ODE and only Fickian Diffusion * 10 different D

clear; clc; close all

%% Move to correct directory
dir_source = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\Defense';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\13. Defense';

cd(dir_source);

t0 = 0;   t1 = 100; dt = 0.01;
dx = 1e-3;  
x = 0:dx:1;   

LowestPt = 0;
LowerBi = 0.395;
mybeta = ((LowerBi- LowestPt)/0.5)*(x') + LowestPt;
mybeta = x';

D = 5*1e-6;
count = 0;

Diff_type = 1; 
tspan = [t0:dt: t1];
t = tspan;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

% Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5; V_0 = -40;
% y0 = [x*0+Z_0, x*0+A_0, x*0+Y_0, x*0+V_0];
Z_0 = 0.5; Y_0 = 0.5; V_0 = -40;
y0 = [x*0+Z_0, x*0+V_0 , x*0+Y_0];
     

timesteps = [0:400:4000];
% timesteps = [0:20:60];
run_time =1;
if run_time 
for ii = 2:length(timesteps)
    
    t0 = timesteps(ii-1);   t1 = timesteps(ii); dt = 0.01;
    tspan = [t0:dt: t1];
    t = tspan;
    M = length(x); 
    N = length(t); 
    mtol = 1e-6;
    odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

    if ii >2.5
        y0 = y0D(end, :);
    end
    
    
    display(['Gold D = ', num2str(D)])
    cd(dir_source)
    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 

    Z0D = y0D(:, 1:M)';

    cd([dir_save]) 
    count  = count + 1
    save(['Gold_Long_', num2str(ii)], 'Z0D', 't', 'x', 'mybeta', 'D')
        
end
end

display('Yay')
cd([dir_save]) 
Z = [];
tt = [];
count = 1;
for ii = 2:length(timesteps)
    M = length(x); 
    N = length(t); 
        
    load(['Gold_Long_', num2str(ii)])
    Z(1:M, count: count+length(t)-1) = Z0D;
    tt(1, count: count+length(t)-1) = t;
    count = count + length(t);
end

figure(ii);
    imagesc(tt,flipud(x),Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		colormap jet
        colorbar
		hold on
%         plot([t(1), t(end)], 0.5*[1,1],'k', 'linewidth', 2)
cd(dir_parent);

max_z = [];
min_z = [];
for ii = 1:M

    max_z(ii) = max(Z(ii, 500:end));
    min_z(ii) = min(Z(ii, 500:end));
end
figure(); hold on;
plot(mybeta, max_z, 'b')
plot(mybeta, min_z, 'b')
n = 10;
[SHORT,LONG] = movavg(max_z,n,n,0);
[SHORT2,LONG2] = movavg(min_z,n,n,0);
plot(mybeta(5:end-5), SHORT(10:end), 'r')
plot(mybeta(5:end-5), SHORT2(10:end), 'r')
