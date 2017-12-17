%% What I want to Generate an E profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Goldbeter unchecked!!!!

clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';

%% Step one load the bifurcation data
t0 = 0;   t1 = 1000; dt = 0.01;
dx = 1e-3;  
t = t0:dt:t1;
mybeta = linspace(0,0.299, 500)';
Diff_type = 1; D =0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

Z_0 = 300; V_0 = -40; N_0 = 0.5;
y0 = [mybeta*0+Z_0, mybeta*0+V_0, mybeta*0+N_0];
[t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    NO0D = y0D(:, 2*M+1:3*M)';

SSZ = median(Z0D(:, floor(0.75*length(t)):end)')';
SSV = median(V0D(:, floor(0.75*length(t)):end)')';
SSN = median(NO0D(:, floor(0.75*length(t)):end)')';

%% Purtibations to consider = 0:0.5
P = 0:0.005:0.5;
P = P*80;
%% Inital Conditions
t0 = 0;   t1 = 30; dt = 0.01;
Diff_type = 1; D=0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
y0SS = [SSZ', SSV', SSN'];

E_P_SS = [];
E_SS = [];
E = [];
tic
for pert = P
    y0 = y0SS;
    y0(1:length(SSZ)) = y0(1:length(SSZ)) + pert;
%     y0(length(SSZ)+1:2*length(SSZ)) = y0(length(SSZ)+1:2*length(SSZ)) + pert;

    [t, y0D] = ode45(@(t,y) odefun_Erm(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
        
    E_P_SS(1:500, end+1) = max(Z0D')';
    E_SS(1:500, end+1) = max(Z0D')' - pert;
    E(1:500, end+1) = max(Z0D')' - pert - SSZ;
    
%     E_P_SS(1:500, end+1) = max(Z0D')';
%     E(1:500, end+1) = max(Z0D')' - SSZ;
    
%         E_P_SS(1:500, end+1) = max(V0D')';
%     E_SS(1:500, end+1) = max(V0D')' - pert;
%     E(1:500, end+1) = max(V0D')' - pert - SSV;
    
    size(E, 2)
end
 runtime = toc;
 
 
E(find(E <= 1e-5*1000)) = 0;


figure()
 imagesc(P,mybeta, E/1000)
    set(gca,'YDir','normal')
		xlabel('Perturbations to V, P_V')
		ylabel('Beta, \beta')
		colormap jet
        myColorMap = summer; 
%         myColorMap(ceil(size(myColorMap, 1)/2+1), :) = [1 1 1];
        myColorMap(1, :) = [1 1 1];
        colormap(myColorMap); colorbar
        
        
figure()
 imagesc(P,mybeta, E/1000)
    set(gca,'YDir','normal')
		xlabel('Perturbations to Z, P_Z')
		ylabel('Beta, \beta')
		colormap jet
        myColorMap = summer; 
        myColorMap(ceil(size(myColorMap, 1)/2+1), :) = [1 1 1];
%         myColorMap(1, :) = [1 1 1];
        colormap(myColorMap); colorbar
        
        
return        
cd(dir_save)
save('Ern_E_Z', 'E', 'P', 'mybeta')
savefig(1, ['E_Ern_Z.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Ern_Z'],'-dpng', '-r300')


return
cd(dir_save)
save('Ern_E_V', 'E', 'P', 'mybeta')
savefig(1, ['E_Ern_V.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Ern_V'],'-dpng', '-r300')





