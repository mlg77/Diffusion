%% For Rua
% Date: 12/6/17
% Author Michelle Goodman
clear; clc; close all
dirs.this_file = 'C:\Temp\Diffusion\MOL_PDE\1. Source files\12. Aop';
dirs.save_file = 'C:\Temp\Diffusion\MOL_PDE\4. Output files\Stability\Dupont';
cd(dirs.save_file)
load('sen_perts_data_full')
cd(dirs.this_file)
position_x = 0:1e-3:0.5;
Aop = [];
for ii = 1:length(position_x)
    Aop(ii, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end
betas_coll = position_x*0.792;
Aop(find(Aop <= 1e-7)) = 0;
lastpertcare = find(perts >=0.5, 1);


%% Most sensitive AoP
for ii = [1,2]
     figure(); hold on
    myColorMap = summer; 
    myColorMap(1, :) = [1 1 1];
     if ii == 1
         subplot(2,3,1)
     end
    [C,h1] = contourf(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20); hold on;
    [C,h2] = contour(perts(1:lastpertcare), position_x, Aop(:, 1:lastpertcare), 20);
    axis([0,0.5,0,0.5])
    xlabel('Pertibations'); ylabel('Position, x [cm]');
    colormap(myColorMap); colorbar
    set(gca,'YDir','normal'); set(gca,'layer','top');
    grid on
    hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
 end
a1a2a3a4 = [-0.025573737362939, -0.01278638174584, 0.063408766383566, 0.067664806911860];
a = (a1a2a3a4(1)*log(6) + a1a2a3a4(2));
b = (a1a2a3a4(3)*log(6) + a1a2a3a4(4));
f_1 =  a*log(1) + b;
[ x_P, P ] = predict_depth_ex6( Aop, perts, position_x, 0.5, f_1, 1 );
idx_end = find(P<=1e-6,1);
figure(1); subplot(2,3,1); plot(P(2:idx_end), x_P(2:idx_end)); title('dx = 1e-3 , dP = 5e-4')
figure(2); plot(P(2:idx_end), x_P(2:idx_end));

%% reduce P
mstep = 10;
perts2 = perts(1:mstep:end); 
for ii = 1:length(position_x)
    Aop2(ii, :) = max_Z(ii,1:mstep:end)-BaseZ(ii,1:mstep:end)-perts2;
end
Aop2(find(Aop2 <= 1e-7)) = 0;
[ x_P, P ] = predict_depth_ex6( Aop2, perts2, position_x, 0.5, f_1, 1 );
idx_end = find(P<=1e-6,1);
figure(1); subplot(2,3,2); hold on
[C,h1] = contourf(perts2, position_x, Aop2, 20); hold on;
[C,h2] = contour(perts2, position_x, Aop2, 20);
axis([0,0.5,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
plot(P(2:idx_end), x_P(2:idx_end)); title('dx = 1e-3 , dP = 3e-3')
figure(2); plot(P(2:idx_end), x_P(2:idx_end)); 

%% reduce x
position_x2 = position_x(1:2:end);
Aop3 = [];
for ii = 1:2:length(position_x)
    Aop3(end+1, :) = max_Z(ii,:)-BaseZ(ii,:)-perts;
end
Aop3(find(Aop3 <= 1e-7)) = 0;
[ x_P, P ] = predict_depth_ex6( Aop3, perts, position_x2, 0.5, f_1, 1 );
idx_end = find(P<=1e-6,1);
figure(1); subplot(2,3,4); hold on
[C,h1] = contourf(perts, position_x2, Aop3, 20); hold on;
[C,h2] = contour(perts, position_x2, Aop3, 20);
axis([0,0.5,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
plot(P(2:idx_end), x_P(2:idx_end)); title('dx = 2e-3 , dP = 5e-4')
figure(2); plot(P(2:idx_end), x_P(2:idx_end)); 

%% reduce Both
mstep = 10;
perts4 = perts(1:mstep:end);
position_x4 = position_x(1:2:end);
Aop4 = [];
for ii = 1:2:length(position_x)
    Aop4(end+1, :) = max_Z(ii,1:mstep:end)-BaseZ(ii,1:mstep:end)-perts4;
end


Aop4(find(Aop4 <= 1e-7)) = 0;
[ x_P, P ] = predict_depth_ex6( Aop4, perts4, position_x4, 0.5, f_1, 1 );
idx_end = find(P<=1e-6,1);
figure(1); subplot(2,3,5); hold on
[C,h1] = contourf(perts4, position_x4, Aop4, 20); hold on;
[C,h2] = contour(perts4, position_x4, Aop4, 20);
axis([0,0.5,0,0.5])
xlabel('Pertibations'); ylabel('Position, x [cm]');
colormap(myColorMap); colorbar
set(gca,'YDir','normal'); set(gca,'layer','top');
grid on
hasbehavior(h1, 'legend', false);  hasbehavior(h2, 'legend', false); 
plot(P(2:idx_end), x_P(2:idx_end)); title('dx = 2e-3 , dP = 3e-3')
figure(2); plot(P(2:idx_end), x_P(2:idx_end)); 

pause()
%% Plot sol dx 1e-3
% Inital Conditions
t0 = 0;   t1 = 50; dt = 1e-3;
dx = 1e-3;  
x = 0:dx:1;    
Diff_type = 1; 
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
mybeta = x'*0.792;
Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
y0 = [Z_0+ x*0, A_0+ x*0, Y_0+ x*0];
D = 6e-6;

% Run Goldbeter
[t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
ZFD = yFD(:, 1:M)';

figure(1); subplot(2,3,3); imagesc(t,flipud(x),ZFD)
set(gca,'YDir','normal')
xlabel('Time, [s]'); ylabel('Position, x'); title('dx = 1e-3'); colormap jet

%% Plot sol dx 2e-3
% Inital Conditions
t0 = 0;   t1 = 50; dt = 1e-3;
dx = 2e-3;  
x = 0:dx:1;    
Diff_type = 1; 
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];
mybeta = x'*0.792;
Z_0 = 0.5; A_0 = 0.1; Y_0 = 0.5;
y0 = [Z_0+ x*0, A_0+ x*0, Y_0+ x*0];
D = 6e-6;

% Run Goldbeter
[t, yFD] = ode45(@(t,y) odefun_Dupont(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
ZFD = yFD(:, 1:M)';

figure(1); subplot(2,3,6); imagesc(t,flipud(x),ZFD)
set(gca,'YDir','normal')
xlabel('Time, [s]'); ylabel('Position, x'); title('dx = 2e-3'); colormap jet

