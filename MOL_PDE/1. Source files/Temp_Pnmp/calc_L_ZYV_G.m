function [L_Z, L_V, L_Y] = calc_L_ZYV_G(Z, V, Y, beta)
%Goldbeter Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

per = 3.64/4;

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
m = 2;
p = 4*per;

v_0 = 1;
v_1 = 7.3;
v_2 = V_m2*Z.^n./(K_2^n + Z.^n);
% v_2 = V_m2*per;
% v_3 = V_m3.*(Y.^m./(K_r^m + Y.^m)).*(Z.^p./(K_a^p + Z.^p));
v_3_pt1 = (Y.^m./(K_r^m + Y.^m));
v_3_pt2 = (Z.^p./(K_a^p + Z.^p));
v_3 = V_m3.*v_3_pt1.*v_3_pt2;

%% From Goldbeter
L_Z =  v_0 + v_1*beta - v_2 + v_3 + k_f*Y - k*Z;
L_V =  F* V_cyto*(v_0 - k*Z + v_1*beta);
L_Y =  v_2 - v_3 - k_f*Y;

end

