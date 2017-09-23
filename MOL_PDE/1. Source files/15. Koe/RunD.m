%%%%%% Doesn't Work
% Widen the range of beta
% The increase in period is towards the upper bifurcation point. 
% Electro Diffusion doesn't work!!!!!!!!!

clear; clc; close all

%% 0 D full
% Inital Conditions to eaisly change
t0 = 0;   t1 = 1500; dt = 0.01;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
x = 0:dx:1;   
mybeta = x';

% Inital Conditions dont change
Diff_type = 1; D =0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

% Run Simulation

Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
display(['Koe '])
tic
[t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
runtime = toc;
Sol.Z = y0D(:, 1:M)';
Sol.Y = y0D(:, M+1:2*M)';
Sol.V = y0D(:, 2*M+1:3*M)';
Sol.N0 = y0D(:, 3*M+1:4*M)';
Sol.I = y0D(:, 4*M+1:5*M)';

% Plot
figure();
    imagesc(t,flipud(x),Sol.Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
        
%% Fickian D full
% Inital Conditions to eaisly change
t0 = 0;   t1 = 1500; dt = 0.01;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
x = 0:dx:1;   
mybeta = x';

% Inital Conditions dont change
Diff_type = 1; D =6e-6;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

% Run Simulation

Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
display(['Koe '])
tic
[t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
runtime = toc;
Sol.Z = y0D(:, 1:M)';
Sol.Y = y0D(:, M+1:2*M)';
Sol.V = y0D(:, 2*M+1:3*M)';
Sol.N0 = y0D(:, 3*M+1:4*M)';
Sol.I = y0D(:, 4*M+1:5*M)';

% Plot
figure();
    imagesc(t,flipud(x),Sol.Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Fickian diffusion')
		colormap jet
		hold on

%% Electro Diffusion Full
% Inital Conditions to eaisly change
t0 = 0;   t1 = 1500; dt = 0.01;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
x = 0:dx:1;   
mybeta = x';

% Inital Conditions dont change
Diff_type = 2; D =6e-6;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

% Run Simulation

Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
display(['Koe '])
tic
[t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
runtime = toc;
Sol.Z = y0D(:, 1:M)';
Sol.Y = y0D(:, M+1:2*M)';
Sol.V = y0D(:, 2*M+1:3*M)';
Sol.N0 = y0D(:, 3*M+1:4*M)';
Sol.I = y0D(:, 4*M+1:5*M)';

% Plot
figure();
    imagesc(t,flipud(x),Sol.Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Electro diffusion')
		colormap jet
		hold on

%% HALF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% 0 D full
% Inital Conditions to eaisly change
t0 = 0;   t1 = 1500; dt = 0.01;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
x = 0:dx:1;   
mybeta = (x*0.7440-0.209)';

% Inital Conditions dont change
Diff_type = 1; D =0;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

% Run Simulation

Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
display(['Koe '])
tic
[t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
runtime = toc;
Sol.Z = y0D(:, 1:M)';
Sol.Y = y0D(:, M+1:2*M)';
Sol.V = y0D(:, 2*M+1:3*M)';
Sol.N0 = y0D(:, 3*M+1:4*M)';
Sol.I = y0D(:, 4*M+1:5*M)';

% Plot
figure();
    imagesc(t,flipud(x),Sol.Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Zero diffusion')
		colormap jet
		hold on
        
%% Fickian D full
% Inital Conditions to eaisly change
t0 = 0;   t1 = 1500; dt = 0.01;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
x = 0:dx:1;   
mybeta = (x*0.7440-0.209)';

% Inital Conditions dont change
Diff_type = 1; D =6e-6;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

% Run Simulation

Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
display(['Koe '])
tic
[t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
runtime = toc;
Sol.Z = y0D(:, 1:M)';
Sol.Y = y0D(:, M+1:2*M)';
Sol.V = y0D(:, 2*M+1:3*M)';
Sol.N0 = y0D(:, 3*M+1:4*M)';
Sol.I = y0D(:, 4*M+1:5*M)';

% Plot
figure();
    imagesc(t,flipud(x),Sol.Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Fickian diffusion')
		colormap jet
		hold on

%% Electro Diffusion Full
% Inital Conditions to eaisly change
t0 = 0;   t1 = 1500; dt = 0.01;
tspan = [t0:dt: t1];
t = tspan;
dx = 1e-3;  
x = 0:dx:1;   
mybeta = (x*0.7440-0.209)';

% Inital Conditions dont change
Diff_type = 2; D =6e-6;
M = length(x); 
N = length(t); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

% Run Simulation

Z_0 = 2; Y_0 = 0.2; V_0 = -40; N_0 = 0.5; I_0 = 0.5;
y0 = [x*0+Z_0, x*0+Y_0, x*0+V_0, x*0+N_0, x*0+I_0];
display(['Koe '])
tic
[t, y0D] = ode45(@(t,y) odefun_Koe(t,y,mybeta,Diff_type, D), tspan, y0, odeoptions);
runtime = toc;
Sol.Z = y0D(:, 1:M)';
Sol.Y = y0D(:, M+1:2*M)';
Sol.V = y0D(:, 2*M+1:3*M)';
Sol.N0 = y0D(:, 3*M+1:4*M)';
Sol.I = y0D(:, 4*M+1:5*M)';

% Plot
figure();
    imagesc(t,flipud(x),Sol.Z)
        set(gca,'YDir','normal')
		xlabel('Time, [s]')
		ylabel('Position, x')
		title('Electro diffusion')
		colormap jet
		hold on