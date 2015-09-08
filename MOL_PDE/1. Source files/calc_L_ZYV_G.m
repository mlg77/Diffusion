function [L_Z, L_V, L_Y] = calc_L_ZYV_G(Z, V, Y, beta)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

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

%% From Goldbeter
L_Z =  v_0 + v_1*beta - v_2 + v_3 + k_f*Y - k*Z;
L_V =  F* V_cyto*(v_0 - k*Z + v_1*beta);
L_Y =  v_2 - v_3 - k_f*Y;

end

