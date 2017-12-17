function [ dydt , L_Z, L_Y, d2Zdx2, v_2, v_3] = odefun_Goldbeter( t, y , mybeta, Diff_type, D)
%Ode function for goldbeter Explicit
%   uses known values for dc/dx 
% global flag
% if flag == 1
%     dydt = y*0;
%     L_Z = zeros(length(y)/3,1);
%     L_Y = L_Z;
%     d2Zdx2 = L_Z;
%     v_2 = L_Z;
%     v_3 = L_Z;
%     return
% end

%% Constants
Cm = 1.9635e-14;

%% Split into Z, V, Y
M = length(y)/3;
Z = y(1:M);    V = y(M+1:2*M);    Y = y(2*M+1:3*M);

%% Calculate Reaction diffusion equation
[L_Z, L_V, L_Y, v_2, v_3] = calc_Gold(Z, V, Y, mybeta);

%% Find each component rate of change
dZdt = L_Z;
dVdt = 1/Cm*(L_V);
dYdt = L_Y;

if dZdt <=0
    flag = 1;
end

%% Output form
dydt = [dZdt; dVdt; dYdt];

end

