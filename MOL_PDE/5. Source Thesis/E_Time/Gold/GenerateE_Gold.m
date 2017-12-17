%% What I want to Generate an E profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Goldbeter unchecked!!!!

clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time\Gold';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';

%% Step one load the bifurcation data
cd(dir_parent)
x = 0:1e-3:1;
x = x(1:500);
mybeta = [x*2*0.2874]';
t0 = 0;   t1 = 500; dt = 0.01;
Diff_type = 1; D=0;
M = length(mybeta); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0 = [Z_0*x, V_0*x, Y_0*x];


[t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
Z0D = y0D(:, 1:M)';
V0D = y0D(:, M+1:2*M)';
Y0D = y0D(:, 2*M+1:3*M)';

SSZ = median(Z0D(1:500, floor(0.75*length(t)):end)')';
SSY = median(Y0D(1:500, floor(0.75*length(t)):end)')';
SSV = median(V0D(1:500, floor(0.75*length(t)):end)')';



%% Purtibations to consider = 0:0.5
P = 0:0.001:0.5;

%% Inital Conditions
t0 = 0;   t1 = 10; dt = 0.001;
Diff_type = 1; D=0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0SS = [SSZ', SSV', SSY'];

global flag
E_P_SS = [];
E_SS = [];
E = [];
tic
for pert = P
    flag = 0;
    y0 = y0SS;
    y0(1:length(SSZ)) = y0(1:length(SSZ)) + pert;

    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';
    
    E_P_SS(1:500, end+1) = max(Z0D')';
    E_SS(1:500, end+1) = max(Z0D')' - pert;
    E(1:500, end+1) = max(Z0D')' - pert - SSZ;
    
    size(E, 2)
end
 runtime = toc;
 
 
 imagesc(P,mybeta, E)
    set(gca,'YDir','normal')
		xlabel('Perturbations, P')
		ylabel('Beta, \beta')
		colormap jet
        myColorMap = summer; 
%         myColorMap(ceil(size(myColorMap, 1)/2+1), :) = [1 1 1];
        myColorMap(1, :) = [1 1 1];
        colormap(myColorMap); colorbar
        
return        
cd(dir_save)
save('Goldbeter_E', 'E', 'P', 'mybeta')
savefig(1, ['E_Gold.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Gold'],'-dpng', '-r300')


   





