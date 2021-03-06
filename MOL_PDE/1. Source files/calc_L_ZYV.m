function [L_Z, L_V, L_Y, v_2, v_3] = calc_L_ZYV(Z, V, Y, beta)
%Goldbeter Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 
F = 9.6485e-5; 
R = 8.314e-6; 
T = 310;
Cm = 1.9635e-14;
lil_z = 2;
my_gamma = F/(R*T);

K_r = 2;
K_2 = 1;
K_a = 0.9;

V_m2 = 65; 
V_m3 = 500;

% Volume
V_cyto = [6.47953484802895e-10];
F = 9.6485e-5;

k =  10;
k_f = 1;

n = 2;
m = n;
p = 4;

v_0 = 1;
v_1 = 7.3;
v_2 = V_m2*Z.^n./(K_2^n + Z.^n);
v_3 = V_m3.*(Y.^n./(K_r^n + Y.^n)).*(Z.^p./(K_a^p + Z.^p));

%% VOCC
% G_Ca = 1.29e-3;
% V_Ca_1 = 100;
% V_Ca_2 = -24;
% R_Ca = 8.5;
% VOCC =G_Ca *(V - V_Ca_1)./(1+ exp(-(V-V_Ca_2)/R_Ca));

VOCC = 0;
%% New L equations
L_Z =  v_0 + v_1*beta - v_2 + v_3 + k_f*Y - k*Z - VOCC;
L_V =  F* V_cyto*(v_0 - k*Z + v_1*beta-VOCC);
L_Y =  v_2 - v_3 - k_f*Y;


%% From Goldbeter
% L_Z =  v_0 + v_1*beta - v_2 + v_3 + k_f*Y - k*Z;
% L_V =  F* V_cyto*(v_0 - k*Z + v_1*beta);
% L_Y =  v_2 - v_3 - k_f*Y;

end

