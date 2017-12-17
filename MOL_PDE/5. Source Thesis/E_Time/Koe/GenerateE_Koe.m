%% What I want to Generate an E profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Goldbeter unchecked!!!!

clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';


%% Inital Conditions to eaisly change
t0 = 0;   t1 = 4000; dt = 0.02;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
mybeta = linspace(0.853,1,500)';
Diff_type = 1; D =0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
y0 = [mybeta*0+Z_0, mybeta*0+Y_0, mybeta*0+V_0, mybeta*0+N_0, mybeta*0+I_0];
[t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
Z0D = y0D(:, 1:M)';
Y0D = y0D(:, M+1:2*M)';
V0D = y0D(:, 2*M+1:3*M)';
NO0D = y0D(:, 3*M+1:4*M)';
I0D = y0D(:, 4*M+1:5*M)';

SSZ = median(Z0D(1:500, floor(0.75*length(t)):end)')';
SSY = median(Y0D(1:500, floor(0.75*length(t)):end)')';
SSV = median(V0D(1:500, floor(0.75*length(t)):end)')';
SSN = median(NO0D(1:500, floor(0.75*length(t)):end)')';
SSI = median(I0D(1:500, floor(0.75*length(t)):end)')';


%% Purtibations to consider = 0:0.5
P = 0:0.005:0.5;
% P = P*80;

%% Inital Conditions
t0 = 0;   t1 = 50; dt = 0.01;
Diff_type = 1; D=0;
M = length(mybeta); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
y0SS = [SSZ', SSY', SSV', SSN', SSI'];

E_P_SS = [];
E_SS = [];
E = [];
flag = 0;
tic
for pert = P
    y0 = y0SS;
    y0(1:length(SSZ)) = y0(1:length(SSZ)) + pert;
%     y0(2*length(SSZ)+1:3*length(SSZ)) = y0(2*length(SSZ)+1:3*length(SSZ)) + pert;

    [t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';
    Y0D = y0D(:, M+1:2*M)';
    V0D = y0D(:, 2*M+1:3*M)';
    
    E_P_SS(1:500, end+1) = max(Z0D')';
    E_SS(1:500, end+1) = max(Z0D')' - pert;
    E(1:500, end+1) = max(Z0D')' - pert - SSZ;
    
%     E_P_SS(1:500, end+1) = max(Z0D')';
%     E(1:500, end+1) = max(Z0D')' - SSZ;
    
    size(E, 2)
end
 runtime = toc;
  E(find(E <= 1e-5)) = 0;


figure()
imagesc(P,mybeta, E)
    set(gca,'YDir','normal')
		xlabel('Perturbations to Z, P_Z')
		ylabel('Beta, \beta')
		colormap jet
        myColorMap = summer; 
%         myColorMap(ceil(size(myColorMap, 1)/2+1), :) = [1 1 1];
        myColorMap(1, :) = [1 1 1];
        colormap(myColorMap); colorbar
    
figure()
imagesc(P,mybeta, E)
    set(gca,'YDir','normal')
		xlabel('Perturbations to V, P_V')
		ylabel('Beta, \beta')
		colormap jet
        myColorMap = summer; 
%         myColorMap(ceil(size(myColorMap, 1)/2+1), :) = [1 1 1];
        myColorMap(1, :) = [1 1 1];
        colormap(myColorMap); colorbar
        
return        
cd(dir_save)
save('Koe_E_Z', 'E', 'P', 'mybeta')
savefig(1, ['E_Koe_Z.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Koe_Z'],'-dpng', '-r300')

return        
cd(dir_save)
save('Koe_E_V', 'E', 'P', 'mybeta')
savefig(1, ['E_Koe_V.fig'])
cd([dir_save, '\Images']) 
set(gcf,'PaperPositionMode','auto')
print(['Koe_V'],'-dpng', '-r300')
   





