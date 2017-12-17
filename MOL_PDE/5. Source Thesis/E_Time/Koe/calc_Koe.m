function [L_Z, L_Y, L_V, L_N, L_I] = calc_Koe(Z, Y, V, N, I, mbeta)

topJ_PLC = 0.05;
botJ_PLC = 0.17;
J_PLC = mbeta*(topJ_PLC - botJ_PLC) + botJ_PLC;

F = 0.23; %T
K_r = 1; %T
v_ca1 = 100; %T
v_ca2 = -24; %T
R_ca = 8.5;%T
G_ca = 0.00129; %T
G_naca = 0.00316; %T
c_naca = 0.5; %T
v_naca = -40; %T range
B = 2.025; %T
c_b = 1; %T
C = 55; %T
s_c = 2; %T
c_c = 0.9; %T 2?
D = 0.24; %T
v_d = -100; %T
R_d = 250; %T
L = 0.025; %T
F_nak = 0.0432; %T
G_cl = 0.00134; %T
v_cl = -25; %T
G_k = 0.00446; %T
v_k = -94; %T
E = 0; % 0.01;
K_ca = 0.3; %T
k = 0.1; %T
c_w = 0; %T
a_beta = 0.13; %T
v_ca3 = -27; %T
R_k = 12; %T

gamma_con = 1970; %T
mylambda = 45; %T



K_act = (Z+c_w).^2./((Z+c_w).^2 + a_beta*exp(-(V-v_ca3)./R_k));

%% Flux Equations
J_ip3 = F * I.^2 ./ (K_r^2 + I.^2);
J_vocc = G_ca * (V- v_ca1)./(1 + exp(-(V-v_ca2)/R_ca));
J_naca = G_naca*Z.*(V-v_naca)./(Z+c_naca);
J_SRup =B*(Z.^2)./(Z.^2 + c_b^2);
J_CICR = C*(Y.^2./(Y.^2 + s_c^2)).*(Z.^4./(c_c^4 + Z.^4));
J_ext = D*Z.*(1+(V-v_d)/R_d);
J_leak = L*Y; 
J_nak = F_nak;
J_cl = G_cl*(V-v_cl);
J_k = G_k*N.*(V-v_k);
J_plc_delta = E*Z.^2./(K_ca^2 + Z.^2);
J_degrad = k*I;

%% Partial derivatives
L_Z = J_ip3 -J_vocc + J_naca - J_SRup + J_CICR - J_ext +J_leak; 
L_Y = + J_SRup - J_CICR - J_leak;
L_V =  gamma_con*(-J_nak - J_cl -2*J_vocc - J_naca - J_k);
L_N =  mylambda*(K_act - N);
L_I = J_PLC + J_plc_delta - J_degrad;

end




























