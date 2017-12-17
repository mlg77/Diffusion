%% What I want to Generate an E profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Goldbeter unchecked!!!!

clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';
dir_run = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\10. CLean Up Of Run';

%% Step one load the bifurcation data
cd(dir_run)
t0 = 0;   t1 = 1000; dt = 0.01;
dx = 1e-3;  
t = t0:dt:t1;
mybeta = linspace(0,0.163, 500)';
Diff_type = 1; D =0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

X_0 = -1; Y_0 = 1; 
y0 = [mybeta*0+X_0, mybeta*0+Y_0];
[t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Z0D = y0D(:, 1:M)';
Y0D = y0D(:, M+1:2*M)';

SSZ = median(Z0D(:, floor(0.75*length(t)):end)')';
SSY = median(Y0D(:, floor(0.75*length(t)):end)')';


%% Purtibations to consider = 0:0.5
P = 0:0.005:0.5;
P = P*3;
%% Inital Conditions
t0 = 0;   t1 = 50; dt = 0.01;
Diff_type = 1; D=0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
y0SS = [SSZ', SSY'];

E_P_SS = [];
E_SS = [];
E = [];
flag = 0;
cd(dir_run)
tic
for pert = P
    y0 = y0SS;
    y0(1:length(SSZ)) = y0(1:length(SSZ)) + pert;
%     y0(length(SSZ)+1:2*length(SSY)) = y0(length(SSZ)+1:2*length(SSY)) + pert;

    [t, y0D] = ode45(@(t,y) odefun_Fitz(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';
        
    E_P_SS(1:500, end+1) = max(Z0D')';
    E_SS(1:500, end+1) = max(Z0D')' - pert;
    E(1:500, end+1) = max(Z0D')' - pert - SSZ;
    
%     E_P_SS(1:500, end+1) = max(Y0D')';
%     E_SS(1:500, end+1) = max(Y0D')' - pert;
%     E(1:500, end+1) = max(Y0D')' - pert - SSY;
    
    size(E, 2)
end
 runtime = toc;
 
 
E(find(E <= 1e-5)) = 0;



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
save('Fitz_E_W', 'E', 'P', 'mybeta')
savefig(1, ['E_Fitz_W.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Fitz_W'],'-dpng', '-r300')


return
cd(dir_save)
save('Fitz_E_U', 'E', 'P', 'mybeta')
savefig(1, ['E_Fitz_U.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Fitz_U'],'-dpng', '-r300')





