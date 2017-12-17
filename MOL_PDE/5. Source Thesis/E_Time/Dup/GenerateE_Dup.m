%% What I want to Generate an E profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Goldbeter unchecked!!!!

clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time\Dup';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';


%% Step one load the bifurcation data
  

%% Inital Conditions to eaisly change
t0 = 0;   t1 = 100; dt = 0.001;
mybeta = linspace(0,0.395, 500)';    
Diff_type = 1; D_Array =0:10e-6/4:10e-6;
M = length(mybeta); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5; V_0 = -40;
y0 = [mybeta*0+Z_0, mybeta*0+A_0, mybeta*0+Y_0, mybeta*0+V_0];
display(['Dupont 0D'])
D = D_Array(1);
[t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Z0D = y0D(:, 1:M)';
A0D = y0D(:, M+1:2*M)';
Y0D = y0D(:, 2*M+1:3*M)';
V0D = y0D(:, 3*M+1:4*M)';




SSZ = median(Z0D(:, floor(0.75*length(t)):end)')';
SSA = median(Y0D(:, floor(0.75*length(t)):end)')';
SSY = median(Y0D(:, floor(0.75*length(t)):end)')';
SSV = median(Y0D(:, floor(0.75*length(t)):end)')';


%% Purtibations to consider = 0:0.5
P = 0:0.001:0.5;

%% Inital Conditions
t0 = 0;   t1 = 15; dt = 0.001;
Diff_type = 1; D=0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
y0SS = [SSZ', SSA', SSY',  SSV'];

E_P_SS = [];
E_SS = [];
E = [];
flag = 0;
  
tic
for pert = P
    y0 = y0SS;
    y0(1:length(SSZ)) = y0(1:length(SSZ)) + pert;

    [t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';

    
    E_P_SS(1:500, end+1) = max(Z0D')';
    E_SS(1:500, end+1) = max(Z0D')' - pert;
    E(1:500, end+1) = max(Z0D')' - pert - SSZ;
    
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
 
%  imagesc(P,mybeta, E)
%  set(gca,'YDir','normal')
% 		xlabel('Perturbations, P')
% 		ylabel('Beta, \beta')
% 		colormap jet
        
return        
cd(dir_save)
save('Dupont_E', 'E', 'P', 'mybeta')
savefig(1, ['E_Dup.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Dupont'],'-dpng', '-r300')


   





