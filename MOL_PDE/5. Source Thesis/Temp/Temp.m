%% Temp file check what happens if keep excited
% clear; clc; close all

%% Move to correct directory
dir_parent = 'C:\Temp\Diffusion\MOL_PDE\5. Source Thesis\E_Time';
dir_save = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\7. Generate E';
dir_load = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\3. HalfFiles';

%% Step one load the bifurcation data
x = 0.3;
mybeta = x;

%% Inital Conditions
t0 = 0;   t1 = 40; dt = 0.001;
tspan = [t0:dt: t1];
t = tspan;

Diff_type = 1; D=0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );

Z_0 = 0.5; A_0 = 0.5; Y_0 = 0.5;
y0 = [Z_0', A_0', Y_0'];

    [t, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions); 
    
    Z0D = y0D(:, 1:M)';
    A0D = y0D(:, M+1:2*M)';
    Y0D = y0D(:, 2*M+1:3*M)';
    

figure(1)
hold on
rectangle('Position',[20 Z0D(end) 20, 0.3], 'FaceColor',[1 1 0], 'EdgeColor', [1 1 0])
% rectangle('Position',[19 Z0D(end) 2, 0.3], 'FaceColor',[1 1 0], 'EdgeColor', [1 1 0])
plot(t, Z0D, 'b', 'linewidth', 2)


idx_20 = find(t>=20,1);
y0 = y0D(idx_20,:)+0.3;
tspan2 = tspan(idx_20:end);
[t2, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan2, y0, odeoptions); 
    
    ZP_Half = y0D(:, 1:M)';
    AP = y0D(:, M+1:2*M)';
    YP = y0D(:, 2*M+1:3*M)';

    
plot(t, [Z0D(1:idx_20-1), ZP_Half], 'r', 'linewidth', 2)    
legend('No Purtibations', 'Impulse Purt')

%% Constant addition
% y0 = y0D(idx_20,:)+0.3;
% ZP = y0(1);
% for ii = 1:length(tspan2)-1
%     tspan3 = tspan(idx_20+ii-1:idx_20+ii);
%     [t3, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan3, y0, odeoptions); 
% 
%     ZP_Piece = y0D(:, 1:M)';
%     ZP(ii+1) = ZP_Piece(2);
%     
%     y0 = y0D(end, :);
%     y0(1) = y0(1)+0.3;
% end
% 
% plot(t, [Z0D(1:idx_20-1), ZP], 'g', 'linewidth', 2)    
% legend('No Purtibations', 'Impulse Purt', 'Constant Purt')

%% COnstant addition
break
idx_20 = find(t>=20,1);
y0 = y0D(idx_20,:);
tspan2 = tspan(idx_20:end);
[t2, y0D] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan2, y0, odeoptions); 
    
    ZP_Half = y0D(:, 1:M)';
    AP = y0D(:, M+1:2*M)';
    YP = y0D(:, 2*M+1:3*M)';

    
plot(t, [Z0D(1:idx_20-1), ZP_Half], 'g', 'linewidth', 2)    
legend('No Purtibations', 'Impulse Purt', 'Constant flux')
