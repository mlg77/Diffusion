function [L_C, L_Ct, L_P, L_H] = calc_L_ZYV_S(C, Ct, P, H, mbeta);
%Sneyd Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, C, the calcium in the stores
%   where beta is a spatially varying variable 
%   Book Equations!!! Ex 9 pg 344

Ce = Ct;
N = H;
v = mbeta;
malpha_2 = mbeta;
%% Constants
mdelta = 0.01; 
mgamma = 5.405;
malpha = 0;
malpha_1 = 1;
% malpha_2 = 0.2;
mbeta = 0.08;
tou_n = 12.5; % I made this up based on other

k_flux = 6.0;
V_p = 24;
k_p = 0.4;
V_e = 20;
k_e = 0.06;

k_1 = 1.1;
k_2 = 0.7;
k_mu = 4;
mu_0 = 0.567;
mu_1 = 0.433;
b = 0.111;
V_1 = 0.889;
k_4 = 1.1;

% %% Fluxes
J_release = (k_flux.*(mu_0 + mu_1*P./(k_mu+P)).*N.*(b+ V_1*C./(k_1 + C))).*(Ce-C);
J_serca = V_e* C./(k_e+C);
% J_in = malpha_1+v.*malpha_2./mbeta;
J_in = malpha_1+malpha_2.*P;
J_pm = V_p*(C.^2./(k_p^2+C.^2));
 
%% Differential Equations
L_C = J_release - J_serca + mdelta*(J_in - J_pm);
L_Ce = mgamma*(J_serca - J_release);
L_N = (1/tou_n).*((k_2^2)./(k_2^2+C.^2)-N);
L_P = v.*((C+(1-malpha)*k_4)./(C+k_4))-mbeta.*P;


L_H = L_N;
L_Ct = L_Ce;

end

