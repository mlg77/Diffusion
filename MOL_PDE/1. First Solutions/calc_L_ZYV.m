function [L_Z,L_Y, L_V] = calc_L_ZYV(Z, Y, V, beta)
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

F = 9.6485e-5;

% Constants for erentrout
g_ca = 1.57e-13;
v_ca = -80;
V_v1 = -22.5; V_v2 = 25;
m_inf = 0.5*(1+tanh((V-V_v1)/V_v2));

k_ca = 1.3675e2;
B_T = 1e2;
rho = (K_2 + Z).^2./((K_2+Z).^2 + K_2*B_T);
% Volume
V_cyto = [6.47953484802895e-10];
my_alpha = 1/(2*V_cyto*F);

%% Origional Equations 
% LZ = @(Z, Y, V) v0 +v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z ;
% LY = @(Z, Y, V) V_m2*Z.^n./(K_2^n+Z.^n) - (V_m3*Y.^m./(K_R^m + Y.^m)).*(Z.^p./(K_a^p+Z.^p)) - k_f*Y;
% LV = @(Z, V) -g_ca*m_inf.*(V - v_ca );

% LZ = @(Z, Y, V) v0 +v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z ;
% LY = @(Z, Y, V) V_m2*Z.^n./(K_2^n+Z.^n) - (V_m3*Y.^m./(K_R^m + Y.^m)).*(Z.^p./(K_a^p+Z.^p)) - k_f*Y;
% LV = @(Z, V) 2*F*V_cyto*(v0  - k*Z)/13;

%% Include Eq 9 from Ermentrout
LZ = @(Z, Y, V) v0 +v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z; % - g_ca*m_inf.*(V - v_ca)*my_alpha.*rho;
LY = @(Z, Y, V) V_m2*Z.^n./(K_2^n+Z.^n) - (V_m3*Y.^m./(K_R^m + Y.^m)).*(Z.^p./(K_a^p+Z.^p)) - k_f*Y;
LV = @(Z, V) -  g_ca*m_inf.*(V - v_ca); 

%%
% LZ = @(Z, Y, V) v0 +v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z - g_ca*m_inf.*(V - v_ca)*my_alpha.*rho;
% LY = @(Z, Y, V) V_m2*Z.^n./(K_2^n+Z.^n) - (V_m3*Y.^m./(K_R^m + Y.^m)).*(Z.^p./(K_a^p+Z.^p)) - k_f*Y;
% LV = @(Z, V)  2*F*V_cyto*(v0 +v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z)-  g_ca*m_inf.*(V - v_ca); 

%% Using Equation From Tim Paper
% LZ = @(Z, Y, V) v0 +v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y - k*Z ;
% LY = @(Z, Y, V) V_m2*Z.^n./(K_2^n+Z.^n) - (V_m3*Y.^m./(K_R^m + Y.^m)).*(Z.^p./(K_a^p+Z.^p)) - k_f*Y;
% LV = @(Z, V) F*V_cyto*(v0-k*Z);
% LV = @(Z, V) -g_ca*m_inf.*(V - v_ca );
% LV = @(Z, V)  F*V_cyto*(v0+v1*beta - V_m2*Z.^n./(K_2^n+Z.^n) + (V_m3*Y.^m./(K_R^m +Y.^m)).*(Z.^p./(K_a^p+Z.^p)) + k_f*Y-k*Z) - g_ca*m_inf.*(V - v_ca);

L_Z = LZ(Z,Y, V);
L_Y = LY(Z,Y, V);
L_V = LV(Z, V);
end

