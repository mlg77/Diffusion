function [ dydt ] = odefun_Sneyd( t, y , mbeta, Diff_type, D)
%Ode function for goldbeter Explicit
%   uses known values for dc/dx 

%% Constants
F = 9.6485e-5; 
R = 8.314e-6; 
T = 310;
Cm = 1.9635e-14;
lil_z = 2;
my_gamma = F/(R*T);

% Volume
radius_cell = 2.5e-4;
length_cell = 6e-3;
V_cell = pi*radius_cell^2*length_cell;
fraction_cyto = 0.55;
V_cyto = fraction_cyto*V_cell;


%% Split into Z, V, Y
M = length(y)/5;
C = y(1:M);    Ce = y(M+1:2*M);    N = y(2*M+1:3*M); P = y(3*M+1:4*M); V = y(4*M+1:5*M);

%% Find x 
dx = 1/(M-1);
% x = 0:dx:1;  
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';

%% Calculate Reaction diffusion equation
[L_C, L_Ce, L_N, L_P, L_V] = calc_L_ZYV(C, Ce, N, P, V, mbeta);

%% Calculate diffusion
if Diff_type == 1
    d2Zdx2 = D/dx^2*(-2*C + [C(2:end); 0] + [0; C(1:end-1)]);
elseif Diff_type == 2
    term1 = (-2*C + [C(2:end); 0] + [0; C(1:end-1)]);
    term2 = (my_gamma./4).*([0; C(3:end); 0] - [0; C(1:end-2);0]).*([0;V(3:end); 0] - [0; V(1:end-2);0]);
    term3 = my_gamma*C.*(-2*V + [V(2:end); 0] + [0; V(1:end-1)]);
    d2Zdx2 = D/dx^2*(term1 + term2 + term3);
else
    error('Not a correct Diff type')
end


%% Boundary conditions
if Diff_type == 1
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*C(2);
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*C(end-1);
elseif Diff_type == 2
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*(C(2)+ my_gamma*C(1)*V(2));
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*(C(end-1) + my_gamma*C(end)*V(end-1));
end

%% Find each component rate of change
dCdt = d2Zdx2 +L_C;
dCedt = L_Ce;
dNdt = L_N;
dPdt = L_P;
dVdt = 1/Cm*(F*V_cyto*lil_z*d2Zdx2 +L_V);

%% Output form
dydt = [dCdt; dCedt; dNdt; dPdt; dVdt];


end

