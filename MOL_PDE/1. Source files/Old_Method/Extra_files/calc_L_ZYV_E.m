function [L_Z, L_V, L_Y] = calc_L_ZYV_E(Z, V, Y, beta)
%Ernemtrout Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

% beta is actually v1
% let Y be n
v_1 = beta*16-33;

myalpha = 7.9976e15;
g_ca = 1.57e-13;
v_ca = 80;
k_ca = 1.3567537e2;

g_l = 7.854e-14;
v_l = -70;
g_k = 3.1416e-13;
v_k = -90;

K_d = 1e3;
B_t = 1e5;
phi_n = 2.664;

v_4 = 14.5;
v_2 = 25;
v_5 = 8;
ca_3 = 400;
ca_4 = 150;
v_6 = -15;

v_3 = -v_5/2*tanh((Z-ca_3)/ca_4) +v_6;

rho = (K_d+Z).^2./((K_d+Z).^2 + K_d.*B_t);
m_inf = 0.5*(1+ tanh((V-v_1)/v_2));
n_inf = 0.5*(1+tanh((V-v_3)/v_4));
lambda_n = phi_n*cosh((V-v_3)/(2*v_4));



%%  reduction
L_Z =  (-myalpha*g_ca*m_inf.*(V-v_ca)-k_ca*Z).*rho;
L_V =  -g_l*(V-v_l) - g_k*Y.*(V-v_k) - g_ca*m_inf.*(V-v_ca);
L_Y =  lambda_n.*(n_inf-Y) ;
end

