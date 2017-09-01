function [ dydt , L_Z, L_Y,  v_2, v_3] = odefun_Dupont( t, y , mybeta, Diff_type, D)
%Ode function for goldbeter Explicit
%   uses known values for dc/dx 


%% Split into Z, V, Y
M = length(y)/3;
Z = y(1:M);    V = y(M+1:2*M);    Y = y(2*M+1:3*M);

%% Calculate Reaction diffusion equation
[L_Z, L_A, L_Y, v_2, v_3] = calc_Dupont(Z, V, Y, mybeta);

dt = 1e-3;
%% Find each component rate of change
% dZdt = L_Z;
dZdt = L_Z + 0.3/dt;
dAdt = L_A;
dYdt = L_Y;

%% Output form
dydt = [dZdt; dAdt; dYdt];

end

