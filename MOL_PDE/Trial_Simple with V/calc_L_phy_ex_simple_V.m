function [L_Z,L_Y, L_V] = calc_L_phy_ex(Z, Y,V, beta)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

v0 = 1;
v1 = 7.3;
V_m2 = 65;
V_m3 = 500;

n = 2;
m = n;
p = 4;

K_2 = 1;
K_R = 2;
K_a =  0.9;

k_f = 1;
k = 10;

Cm = 1.9635e-14;
g_ca = 1.57e-13;
v_ca = -60;
V_v1 = -22.5; V_v2 = 25;
m_inf = 0.5*(1+tanh((V-V_v1)/V_v2));
F = 9.6485e-2;

my_alpha = 7.9976e12;
k_ca = 1.3675e2;
B_T = 1e2;
rho = (K_2 + Z).^2./((K_2+Z).^2 + K_2*B_T);

% L equations in terms of Z and Y 
LZ = @(Z, Y) v0 +v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z +my_alpha* (- g_ca*m_inf.*(V - v_ca)).*rho;
LY = @(Z, Y) V_m2*Z.^n./(K_2^n+Z.^n) - (V_m3*Y.^m./(K_R^m + Y.^m)).*(Z.^p./(K_a^p+Z.^p)) - k_f*Y;
LV = @(Z, V)  + (1/my_alpha)*(v0 +v1*beta- V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z )/Cm - g_ca*m_inf.*(V - v_ca)/Cm;
% - g_ca*m_inf.*(V - v_ca)/Cm

L_Z = LZ(Z,Y);
L_Y = LY(Z,Y);
L_V = LV(Z, V);

end
