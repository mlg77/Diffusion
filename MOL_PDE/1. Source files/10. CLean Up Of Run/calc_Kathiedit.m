function [L_Z, L_V, L_Y, Fluxes ] = calc_Kathiedit(Z, V, Y, beta)
%Kathi Paper edits only calcium Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, Y, and the membrain potential, V.
%   where beta is a spatially varying variable 
% Date: 3/3/2017
% Author Michelle Goodman

% Convert beta to IP3
IP3 = 0.02*beta;
% lemon et al 2003 Inital concentration IP3 is 0.01 muM

v_2 = 0;
v_3 = 0;

% Membrain potential constants
F = 9.6485e-5; 
R = 8.314e-6; 
T = 310;
Cm = 1.9635e-14;
lil_z = 2;
my_gamma = F/(R*T);

% Constants
V_cyto = [6.47953484802895e-10]; % Volume ? 
VR_ERcyt = 0.185;
B_cyt = 0.0244;



%% Fluxes
% Extresion Kathi 2015 A.45
D_i = 0.24; 	% s^-1
V_d = -100; 	% mV
R_di = 250; 	% mV 

% Combination to get v at -70ish
% V_d = -50; 	% mV
% R_di = 26; 	% mV 


J_ext = D_i.*Z.*(1+(V-V_d)/R_di);
% IP3 Recptors Kathi 2015 A.42
F_i = 0.23; 	% muMs^-1
K_ri = 1;		% muM
J_ip3r = F_i*(IP3.^2./(K_ri^2 + IP3.^2));
% Calcium Induced Calcium Release Kathi 2015 A.44
C_i = 55; 		% muM
S_ci = 2.0; 	% muM
C_ci = 0.9;		% muM
J_cicr = C_i * (Y.^2./(S_ci^2 + Y.^2)) .* (Z.^4./(C_ci^4 + Z.^4));
% Serca Pump Kathi 2015 A.43
B_bi = 2.025;	% muMs^-1
C_bi = 1;		% muM
J_serca = B_bi .*(Z.^2./(C_bi^2 + Z.^2));
% Voltage operated calcium channel Kathi 2015 A.47
G_cai = 1.29e-3;	% muMmV^-1s^-1
V_ca1 = 100;	% mV
V_ca2 = -24;	% mV
R_cai = 8.5;	% mV
J_vocc = -G_cai *((V-V_ca1)./(1+exp(-(V-V_ca2)./R_cai))); % Note the negative thanks to kathis paper?
% Potential second leak from stores Currently not used
L_i = 0.025; 	% s^-1
J_srleak = L_i * Y;
% J_srleak = L_i * (Y*VR_ERcyt - Z);


%% Additions
G_NaCa =  3.16e-3; %uM mV^-1 s^-1
c_NaCa =  0.5; %uM
v_NaCa =  -30; %mV
J_NaCa = G_NaCa * Z ./ (Z + c_NaCa) .* (V - v_NaCa);
% J_NaCa = 0;

F_NaK_i = 4.32e-2; %uM s^-1
J_NaK = F_NaK_i;
% J_NaK = 0;

G_Cl =  1.34e-3; %uM mV^-1 s^-1
v_Cl =  -25; %mV
J_Cl = G_Cl * (V - v_Cl);
% J_Cl = 0;

J_NEW = 7.3*beta;
% J_NEW = 0;

B_cyt = 1;
% VR_ERcyt = 1;


Fluxes = [J_ext, J_ip3r,J_cicr,J_serca,J_vocc,J_srleak,J_NaCa+ J_ext*0, J_NaK + J_ext*0, J_Cl+ J_ext*0];

% differential equations
L_Z =  - J_ext + J_ip3r + J_cicr - J_serca + J_vocc + J_srleak + J_NaCa + J_NEW;
L_Y =  (B_cyt/VR_ERcyt)*(J_serca - J_cicr  - J_srleak  - J_ip3r  ); %    
L_V =  (J_vocc - J_ext- J_NaCa - J_NaK - J_Cl + J_ip3r + J_NEW); % Note Cm is on outside
%% Note 
% currently VOCC (Fine)and SRLeak (Makes Sence) are 10 times smaller in magnatude than the
% other 4 fluxes
% Also The voltage is at -350??!!??


% %% differential equations
% L_Z =  - J_ext + J_ip3r + J_cicr - J_serca + J_vocc + J_srleak;
% L_V =  (2*J_vocc - J_ext); % Note Cm is on outside
% L_Y =  (1/VR_ERcyt)*(J_serca - J_cicr  - J_srleak  - J_ip3r ); %    


end

