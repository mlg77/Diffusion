function [ dydt ] = odefun_Goldbeter( t, y )
%Ode function for goldbeter Explicit
%   uses known values for dc/dx 

%% Constants
F = 9.6485e-5; 
Cm = 1.9635e-14;
lil_z = 2;
D = 6e-6;
% Volume
radius_cell = 2.5e-4;
length_cell = 6e-3;
V_cell = pi*radius_cell^2*length_cell;
fraction_cyto = 0.55;
V_cyto = fraction_cyto*V_cell;

%% Split into Z, V, Y
M = length(y)/3;
Z = y(1:M);    V = y(M+1:2*M);    Y = y(2*M+1:3*M);

%% Find x and mybeta
dx = 1/(M-1);
x = 0:dx:1;  
mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';

%% Calculate Reaction diffusion equation
[L_Z, L_V, L_Y] = calc_L_ZYV(Z, V, Y, mybeta);

%% Calculate diffusion
difZ = D/dx^2*(-2*Z + [Z(2:end); 0] + [0; Z(1:end-1)]);

%% Boundary conditions
difZ(1) = difZ(1) + D/dx^2*Z(2);
difZ(end) = difZ(end) + D/dx^2*Z(end-1);

%% Find each component rate of change
dZdt = difZ +L_Z;
dVdt = 1/Cm*(F*V_cyto*lil_z*difZ +L_V);
dYdt = L_Y;

%% Output form
dydt = [dZdt; dVdt; dYdt];
end

