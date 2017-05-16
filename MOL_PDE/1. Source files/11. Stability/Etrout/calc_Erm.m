function [L_Z, L_V, L_N] = calc_Erm(Z, V, N, mbeta)
%Enremtrout Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the open probability, and the membrain potential.
%   where beta is a spatially varying variable 

% Units that will work Z=[nM], V=[mV], N = [-] 0-1, 
%% Beta conversion to v_1   Between -20 and -27
% v_1 = -22.5;
v1_bounds = [-20, -27];
v1_bounds = [-13, -36];
v_1 = mbeta*(v1_bounds(2)- v1_bounds(1)) + v1_bounds(1);

%% Old parameters
F = 9.6485e-5; 
R = 8.314e-6; 
T = 310;
Cm = 1.9635e-14;
lil_z = 2;
my_gamma = F/(R*T);

%% parameteres
k_Ca = 1.3567537e2; %s^-1
malpha = 7.9976e15; %nMC^-1

% Cs^-1mV^-1
g_L = 7.854e-14;
g_k = 3.1415e-13;
g_Ca = 1.57e-13; 

% mV
v_L = -70;
v_k = -90;
v_Ca = 80;

% nM
K_d =1e3;
B_T = 1e5;

mphi_n = 2.664; % s^-1

% mV
v_2 = 25;
v_4 = 14.5;
v_5 = 8;
v_6 = -15;

% nM
Ca_3 = 400;
Ca_4 = 150;

v_3 = -v_5/2 * tanh((Z - Ca_3)./Ca_4) + v_6; %mV

%% Flux Equations
mrho = (K_d + Z).^2./((K_d + Z).^2 + K_d*B_T);
mlambda = mphi_n* cosh((V-v_3)./(2*v_4));

m_inf = 0.5*(1 + tanh((V- v_1)./v_2));
n_inf = 0.5*(1 + tanh((V-v_3)./v_4));

%% Partial derivatives
L_Z =  (-malpha.*g_Ca.*m_inf.*(V-v_Ca) - k_Ca.*Z).*mrho;
L_V =  (-g_L.*(V - v_L) - g_k*N.*(V - v_k) - g_Ca.*m_inf.*(V-v_Ca));
L_N =  mlambda.*(n_inf-N);

end

