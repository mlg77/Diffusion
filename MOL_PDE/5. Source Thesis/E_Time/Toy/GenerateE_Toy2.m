%% What I want to Generate an E profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Goldbeter unchecked!!!!

clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time\Toy';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';


t0 = 0;   t1 = 2000; dt = 0.01;
dx = 1e-3;  
t = t0:dt:t1; 
% mybeta = [0:0.001:1]';
mybeta = linspace(0,0.5,500)';
Diff_type = 1; D =0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
X_0 = -1.2; Y_0 = 0.1; 
y0 = [mybeta*0+X_0, mybeta*0+Y_0];

[t, y0D] = ode45(@(t,y) odefun_Toy2(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
X0D = y0D(:, 1:M)';
Y0D = y0D(:, M+1:2*M)';


SSX = median(X0D(:, floor(0.75*length(t)):end)')';
SSY = median(Y0D(:, floor(0.75*length(t)):end)')';

%% Purtibations to consider = 0:0.5
P = 0:0.001:0.5;
P = P*3;

%% Inital Conditions
t0 = 0;   t1 = 60; dt = 0.01;
Diff_type = 1; D=0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
y0SS = [SSX', SSY'];

E_P_SS = [];
E_SS = [];
E = [];
flag = 0;

tic
for pert = P
    y0 = y0SS;
    y0(1:length(SSX)) = y0(1:length(SSX)) + pert;

    [t, y0D] = ode45(@(t,y) odefun_Toy2(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    
    X0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';
        
    E_P_SS(1:500, end+1) = max(X0D')';
    E_SS(1:500, end+1) = max(X0D')' - pert;
    E(1:500, end+1) = max(X0D')' - pert - SSX;
    
    size(E, 2)
end
 runtime = toc;

mybeta = mybeta*0.2+0.1;
 
 figure()
 imagesc(P,mybeta, E)
    set(gca,'YDir','normal')
		xlabel('Perturbations, P')
		ylabel('Beta, \beta')
		colormap jet
        myColorMap = summer; 
%         myColorMap(ceil(size(myColorMap, 1)/2+1), :) = [1 1 1];
        myColorMap(1, :) = [1 1 1];
        colormap(myColorMap); colorbar
         
        
% return        
cd(dir_save)
save('Toy2_E', 'E', 'P', 'mybeta')
return
savefig(1, ['E_Toy2.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Toy_2'],'-dpng', '-r300')


   





