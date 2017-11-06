function [ dydt ] = odefun_Goldbeter( t, y , mybeta, D, MeshM)
%Ode function for goldbeter Explicit
%   uses known values for dc/dx 

%% Split into Z, V, Y
M = length(y)/2;
Z = y(1:M);   Y = y(M+1:2*M);

%% Find x 
dx = 1/(M-1);

%% Calculate Reaction diffusion equation
[L_Z, L_Y] = calc_Gold(Z, Y, mybeta);

%% Calculate diffusion
d2Zdx2 = D/dx^2*(MeshM*Z);

%% Find each component rate of change
dZdt = d2Zdx2 +L_Z;
dYdt = L_Y;

%% Output form
dydt = [dZdt; dYdt];

end

