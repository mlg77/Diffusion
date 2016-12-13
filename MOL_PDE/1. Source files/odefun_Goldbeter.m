function [ dydt , L_Z, L_Y, d2Zdx2, v_2, v_3] = odefun_Goldbeter( t, y , mybeta, Diff_type, D)
%Ode function for goldbeter Explicit
%   uses known values for dc/dx 

if length(mybeta) ~= 1 && length(mybeta)*3 ~= length(y)
    mybeta = mybeta(1);
end
%% Constants
F = 9.6485e-5; 
R = 8.314e-6; 
T = 310;
Cm = 1.9635e-14;
lil_z = 2;
my_gamma = F/(R*T);

% Volume
radius_cell = 2.5e-4;
length_cell = 6e-3;
V_cell = pi*radius_cell^2*length_cell;
fraction_cyto = 0.55;
V_cyto = fraction_cyto*V_cell;


%% Split into Z, V, Y
M = length(y)/3;
Z = y(1:M);    V = y(M+1:2*M);    Y = y(2*M+1:3*M);

%% Find x 
dx = 1/(M-1);
% x = 0:dx:1;  
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';

%% Calculate Reaction diffusion equation
[L_Z, L_V, L_Y, v_2, v_3] = calc_L_ZYV(Z, V, Y, mybeta);

%% Calculate diffusion
if Diff_type == 1
    d2Zdx2 = D/dx^2*(-2*Z + [Z(2:end); 0] + [0; Z(1:end-1)]);
elseif Diff_type == 2
    term1 = (-2*Z + [Z(2:end); 0] + [0; Z(1:end-1)]);
    term2 = (my_gamma./4).*([0; Z(3:end); 0] - [0; Z(1:end-2);0]).*([0;V(3:end); 0] - [0; V(1:end-2);0]);
    term3 = my_gamma*Z.*(-2*V + [V(2:end); 0] + [0; V(1:end-1)]);
    d2Zdx2 = D/dx^2*(term1 + term2 + term3);
else
    error('Not a correct Diff type')
end


%% Boundary conditions
if Diff_type == 1 & length(d2Zdx2)>1
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*Z(2);
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*Z(end-1);
elseif Diff_type == 2
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*(Z(2)+ my_gamma*Z(1)*V(2));
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*(Z(end-1) + my_gamma*Z(end)*V(end-1));
end

%% Find each component rate of change
dZdt = d2Zdx2 +L_Z;
dVdt = 1/Cm*(F*V_cyto*lil_z*d2Zdx2 +L_V);
dYdt = L_Y;

%% Output form
dydt = [dZdt; dVdt; dYdt];

% if rem(round(t)/50, 1)== 0
%     display([num2str(t), ' ', toc])
% end
end

