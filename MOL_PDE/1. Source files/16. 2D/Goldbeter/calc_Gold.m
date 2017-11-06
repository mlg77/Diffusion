function [L_Z, L_Y] = calc_Gold(Z, Y, mybeta)
%Goldbeter Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 
F = 9.6485e-5; 
R = 8.314e-6; 
T = 310;

K_r = 2;
K_2 = 1;
K_a = 0.9;

V_m2 = 65; 
V_m3 = 500;


k =  10;
k_f = 1;

n = 2;
m = n;
p = 4;

v_0 = 1;
v_1 = 7.3;
v_2 = V_m2*Z.^n./(K_2^n + Z.^n);
v_3 = V_m3.*(Y.^n./(K_r^n + Y.^n)).*(Z.^p./(K_a^p + Z.^p));


VOCC = 0;
%% New L equations
L_Z =  (v_0 + v_1.*mybeta - v_2 + v_3 + k_f*Y - k*Z );
L_Y =  (v_2 - v_3 - k_f*Y ); 


end

