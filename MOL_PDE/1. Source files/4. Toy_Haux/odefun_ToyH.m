function [ dydt , L_X, L_Y, d2Zdx2] = odefun_ToyH( t, y , mybeta, Diff_type, D)
%Ode function for Hauxong Explicit
%   uses known values for dc/dx 

%% Split into Z, V, Y
M = length(y)/2;
X = y(1:M);    Y = y(M+1:2*M);  

%% Find x 
dx = 1/(M-1);
% x = 0:dx:1;  
% mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';

%% Calculate Reaction diffusion equation
[L_X, L_Y] = calc_L_ZYV(X, Y, mybeta);

%% Calculate diffusion
if Diff_type == 1
    d2Zdx2 = D/dx^2*(-2*X + [X(2:end); 0] + [0; X(1:end-1)]);
elseif Diff_type == 2
    error('Not for this one')
    term1 = (-2*X + [X(2:end); 0] + [0; X(1:end-1)]);
    term2 = (my_gamma./4).*([0; X(3:end); 0] - [0; X(1:end-2);0]).*([0;Y(3:end); 0] - [0; Y(1:end-2);0]);
    term3 = my_gamma*X.*(-2*Y + [Y(2:end); 0] + [0; Y(1:end-1)]);
    d2Zdx2 = D/dx^2*(term1 + term2 + term3);
else
    error('Not a correct Diff type')
end


%% Boundary conditions
if Diff_type == 1 & length(d2Zdx2)>1
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*X(2);
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*X(end-1);
elseif Diff_type == 2
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*(X(2)+ my_gamma*X(1)*Y(2));
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*(X(end-1) + my_gamma*X(end)*Y(end-1));
end

%% Find each component rate of change
dXdt = d2Zdx2 +L_X;
% dXdt = L_X;
dYdt = L_Y;

%% Output form
dydt = [dXdt; dYdt];

% if rem(round(t)/50, 1)== 0
%     display([num2str(t), ' ', toc])
% end
end

