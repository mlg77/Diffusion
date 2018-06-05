function [ dydt , L_X, L_Y, d2Zdx2] = odefun_Toy3( t, y , mybeta, Diff_type, D, myxi)
%The Toy models that penetrate and dont

%% Split into X and Y 
M = length(y)/2;
X = y(1:M);    Y = y(M+1:2*M);  

%% Find x 
dx = 1/(M-1);

%% Calculate Reaction diffusion equation
[L_X, L_Y] = calc_Toy3(X, Y, mybeta, myxi);

%% Calculate diffusion
if Diff_type == 1
    d2Zdx2 = D/dx^2*(-2*X + [X(2:end); 0] + [0; X(1:end-1)]);
elseif Diff_type == 2
    error('Not for this one')
else
    error('Not a correct Diff type')
end


%% Boundary conditions
if Diff_type == 1 & length(d2Zdx2)>1
    d2Zdx2(1) = d2Zdx2(1) + D/dx^2*X(2);
    d2Zdx2(end) = d2Zdx2(end) + D/dx^2*X(end-1);
end

%% Find each component rate of change
dXdt = d2Zdx2 + L_X;
dYdt =  L_Y;

%% Output form
dydt = [dXdt; dYdt];


end

