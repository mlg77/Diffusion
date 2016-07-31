function [ dydt , L_Z, L_V, d2Zdx2] = odefun_Toy( t, y , mybeta, Diff_type, D)
%Ode function for goldbeter Explicit
%   uses known values for dc/dx 

%% Split into Z, V
M = length(y)/2;
Z = y(1:M);    V = y(M+1:2*M);   
%% Find x 
dx = 1/(M-1);
% x = 0:dx:1;  
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';

%% Calculate Reaction diffusion equation
[L_Z, L_V] = calc_L_ZYV(Z, V, mybeta);

%% Calculate diffusion
if Diff_type == 1
    d2Zdx2 = D/dx^2*(-2*Z + [Z(2:end); 0] + [0; Z(1:end-1)]);
elseif Diff_type == 2
    term1 = (-2*Z + [Z(2:end); 0] + [0; Z(1:end-1)]);
    term2 = (my_gamma./4).*([0; Z(3:end); 0] - [0; Z(1:end-2);0]).*([0;V(3:end); 0] - [0; V(1:end-2);0]);
    term3 = my_gamma*Z.*(-2*V + [V(2:end); 0] + [0; V(1:end-1)]);
    d2Zdx2 = D/dx^2*(term1 + term2 + term3);
else
    error('Not a correct Diff type')
end


%% Boundary conditions
if Diff_type == 1
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*Z(2);
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*Z(end-1);
elseif Diff_type == 2
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*(Z(2)+ my_gamma*Z(1)*V(2));
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*(Z(end-1) + my_gamma*Z(end)*V(end-1));
end

%% Find each component rate of change
dZdt = d2Zdx2 +L_Z;
dVdt = L_V;

%% Output form
dydt = [dZdt; dVdt];
end

