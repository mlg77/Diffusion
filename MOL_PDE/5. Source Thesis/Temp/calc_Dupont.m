function [L_Z, L_A, L_Y, v_2, v_3] = calc_Dupont(Z, A, Y, beta)
%Goldbeter Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

% Z = Z +0.3;
% pert = 0.3;
pert = 0;

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
v_3 = beta.*V_m3.*(Y.^n./(K_r^n + Y.^n)).*(Z.^p./(K_a^p + Z.^p)); % one pool model

VR_ERcyt = 0.185;
VR_ERcyt = 1;
B_cyt = 0.0244;
B_cyt = 1;
VOCC = 0;
%% A specific
R2 = 0.05;
v_p = 2/60; % 2 muM/min = /sec
k_d =  1/60;

% one pool model
L_Z =  B_cyt*(v_0 + v_1*beta - v_2 + v_3 + k_f*Y - k*Z + pert);
L_A =  v_p*R2 - k_d*A;
L_Y =  (B_cyt/VR_ERcyt)*(v_2 - v_3 - k_f*Y ); %


end
