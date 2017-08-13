%% Create the data for changing Xi

clear; clc; close all
% IC
t0 = 0;   t1 = 1000; dt = 0.01;
dx = 1e-3;  
x = (0:dx:1);    M = length(x); 
X_0 = -1.152; Y_0 = 3.6908; 
y0 = [x*0+X_0, x*0+Y_0];
Diff_type = 1; D =0;% 6e-6;%  0;%
M = length(x); 
mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

mybeta = ((x*0.6)*0.3+0.2)';

display('Toy3')

% myXi_list = [0.55:0.05:0.8]; % For Plotting
myXi_list = [0.55:0.01:0.65]; % For Plotting
count = 0;
for ii = myXi_list
    myxi = ii;
    count = count + 1;
    Diff_type = 1; D =0;
    display(['Diffusion = ', num2str(D)])
    [~, y0D] = ode45(@(t,y) odefun_ToyXi(t,y,mybeta,Diff_type, D, myxi), tspan, y0, odeoptions);
        
    y0 = [y0D(end, 400)+x*0, y0D(end, M + 400)+x*0];
    Diff_type = 1; D =0;
    display(['Diffusion = ', num2str(D)])
    [~, y0D] = ode45(@(t,y) odefun_ToyXi(t,y,mybeta,Diff_type, D, myxi), tspan, y0, odeoptions);
    Toy3.Z0D(:,:,count) = y0D(:, 1:M)';
    
    Diff_type = 1; D =6e-6;
    display(['Diffusion = ', num2str(D)])
    [t, yFD] = ode45(@(t,y) odefun_ToyXi(t,y,mybeta,Diff_type, D, myxi), tspan, y0, odeoptions);
    Toy3.ZFD(:,:,count) = yFD(:, 1:M)';
    
    Toy3.t = t;
    Toy3.x = x;

end