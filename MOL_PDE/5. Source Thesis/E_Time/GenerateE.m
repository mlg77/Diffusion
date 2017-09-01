%% What I want to Generate an E profile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Goldbeter unchecked!!!!

clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';

%% Step one load the bifurcation data
cd(dir_load)
load('Data0D_Gold.mat')
cd(dir_parent)

SSZ = median(Z0D(1:500, floor(0.75*length(t)):end)')';
SSY = median(Y0D(1:500, floor(0.75*length(t)):end)')';
SSV = median(V0D(1:500, floor(0.75*length(t)):end)')';

x = x(1:500);
mybeta = mybeta(1:500);

%% Purtibations to consider = 0:0.5
P = 0:0.005:0.5;

%% Inital Conditions
t0 = 0;   t1 = 10; dt = 0.001;
Diff_type = 1; D=0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
Z_0 = 0.5; V_0 = -40; Y_0 = 0.5;
y0SS = [SSZ', SSV', SSY'];

E_P_SS = [];
E_SS = [];
E = [];
flag = 0;
tic
for pert = P
    y0 = y0SS;
    y0(1:length(SSZ)) = y0(1:length(SSZ)) + pert;

    [t, y0D] = ode45(@(t,y) odefun_Goldbeter(t,y,mybeta,Diff_type, D, flag), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';
    V0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';
    
    E_P_SS(1:500, end+1) = max(Z0D')';
    E_SS(1:500, end+1) = max(Z0D')' - pert;
    E(1:500, end+1) = max(Z0D')' - pert - SSZ;
    
    size(E, 2)
end
 runtime = toc;
 
 imagesc(mybeta,P, E)

 cd(dir_save) 
   
 tic
 P_i = 0.2;
 f1 = 0.2;
 P_array = nan(1, 500);
 for ii = 1:length(x)
     x_i = x(end+1-ii);
     % E
     E_i = E(end+1-ii, find(P_i<=P,1));
     P_i = (E_i+P_i)*f1;
     
     if isempty(P_i)
         ii
         break
     end
     
     P_array(501-ii) = P_i;
 end
 
toc 
hold on
plot(P_array, x, 'k', 'linewidth', 2)




