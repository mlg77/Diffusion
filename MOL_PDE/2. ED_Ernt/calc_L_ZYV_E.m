function [L_Z, L_V, L_NO] = calc_L_ZYV(Z, V, NO, beta)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

K_d = 1;

k_ca = 1.3675e2;
g_ca = 1.57e-13;
v_ca = 80;
g_L = 7.854e-14;
v_L = -70;
g_K = 3.1416e-13;
v_K = -90;

Ca_3 = 0.4;
Ca_4 = 0.15;

F = 9.6485e-5;
phi = 2.664;
%%
v_1_top = -15;%-18; 
v_1_bot = -35;%-30;
%beta = flipud(beta);
v_1 = (v_1_top-v_1_bot)*beta + v_1_bot;
if v_1(1) == v_1(end)
    v_1 = v_1*0 -22.5;
end

%
v_2 = 25;
v_4 = 14.5;
v_5 = 8;
v_6 = -15;
v_3 = @(Z) -v_5/2*tanh((Z-Ca_3)/Ca_4) + v_6;

B_T = 1e2;

% Volume
V_cyto = [6.47953484802895e-10];
my_alpha = 1/(2*V_cyto*F);

rho= @(Z) (K_d + Z).^2./((K_d+Z).^2 + K_d*B_T);
my_lamba = @(V,Z) phi * cosh((V -v_3(Z))/(2*v_4));
n_inf = @(V, Z) 0.5*(1+tanh((V-v_3(Z))/v_4));
m_inf = @(V) 0.5*(1+tanh((V-v_1)/v_2));

%% From Ermentrout
LZ = @(Z, V, NO) (-my_alpha*g_ca*m_inf(V).*(V-v_ca) - k_ca*Z).*rho(Z);
LV = @(Z, V, NO) -g_L*(V-v_L) - g_K*NO.*(V-v_K) -  g_ca*m_inf(V).*(V - v_ca); 
LNO = @ (Z, V, NO) my_lamba(V,Z).*(n_inf(V, Z) - NO);

L_Z = LZ(Z, V, NO);
L_V = LV(Z, V, NO);
L_NO = LNO(Z, V, NO);
end

