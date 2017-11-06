% Run the 2d Model
clear; clc; close all

t0 = 0;   t1 = 20; dt = 0.01;
dx1 = 0.5e-2;  
x1 = 0:dx1:1;
x2 = x1;
M = length(x1);

LowerBi = 0.2760;
linear_beta = (LowerBi/0.5)*(x1');

% add more
linear_beta = [flipud(linear_beta); zeros(10, 1)];
x1 = [x1,[1+dx1:dx1:1+dx1*10]];
M = length(x1);
x2 = x1;

[ x, mybetagrid, mybeta, MeshM ] = Create2D( x1, x2, linear_beta );


mtol = 1e-6;
odeoptions = odeset('RelTol',mtol, 'AbsTol', mtol );
tspan = [t0:dt: t1];

%% Run D = 0 Simulation
% D =0;
% Z_0 = 0.5; Y_0 = 0.5;
% y0 = [mybeta*0+Z_0; mybeta*0+Y_0];
% display(['Goldbeter 2D D=0'])
% tic
% [t, y0D] = ode45(@(t,y) odefun_Goldbeter( t, y , mybeta, D, MeshM), tspan, y0, odeoptions); 
% toc
% Z = y0D(:, 1:length(y0D)/2)';
% Y = y0D(:, length(y0D)/2+1:end)';

%% Run D = 0 Simulation
D =6e-6;
Z_0 = 0.5; Y_0 = 0.5;
y0 = [mybeta*0+Z_0; mybeta*0+Y_0];
display(['Goldbeter 2D D=6e-6'])
tic
[t, yFD] = ode45(@(t,y) odefun_Goldbeter( t, y , mybeta, D, MeshM), tspan, y0, odeoptions); 
toc
ZF = yFD(:, 1:length(yFD)/2)';
YF = yFD(:, length(yFD)/2+1:end)';


cd('C:\Temp\Diffusion\MOL_PDE\4. Output files\Temp_2D')

if D ==0
    save('Data_2D_0D')
else
    save(['Data_2D_D', num2str(6)])
end


    
    
    
    