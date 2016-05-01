function [L_C, L_Ct, L_P, L_H] = calc_L_ZYV_S(C, Ct, P, H, mbeta);
%Sneyd Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, C, the calcium in the stores
%   where beta is a spatially varying variable 
%   Note P is Rho 

%% Varriable constants
malpha = 0; % Ip3 Dynamics turned off.
mdelta = 1; % Delta is 0 means it is a closed cell model

%% Constants
K_a = 0.227;
K_p = 0.3;
K_s = 0.1;
K_pm = 0.12;
K_PLC = 0.16;
K_i = 0.1;

K_IPR = 2;
K = 2.13e-5;
V_s = 0.9;
V_pm = 0.01;
V_PLC = 2;
V_deg = 0.66;

mgamma = 0.185;
tou_h = 12.5;
v_0 = 0.004; %%%%%%%%%    RUA EDIT
v_1 = mbeta*0.004;%*0 + 0.045;

%% Calculations
c_e = (Ct-C)/mgamma;
h_inf = (K_i.^2./(K_i.^2 + C.^2));


%% Fluxes
J_ipr = K_IPR*(C.^3./(K_a^3 + C.^3)).*(P.^2./(K_p^2 + P.^2)).*H;
J_serca = V_s* (C.^2 - K*c_e.^2)./(K_s^2+C.^2);
J_in = v_0+v_1.*P ;
J_pm = V_pm*(C.^2./(K_pm^2+C.^2));

%% Differential Equations
L_C = (c_e-C).*J_ipr - J_serca + mdelta*(J_in - J_pm);
L_Ct = mdelta*(J_in - J_pm);
L_P = V_PLC*((1-malpha)*K_PLC^2 + C.^2)./(K_PLC^2 + C.^2) - V_deg*P;
% L_H = (1/tou_h).*(h_inf-H)./(h_inf);
L_H = (1/tou_h).*(h_inf-H);

end

