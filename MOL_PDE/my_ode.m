function [ dy ] = my_ode( t,y )
%The simple example ODE calculation
%   Detailed explanation goes here
%   Method of lines
%   Michelle Goodman
%   1/5/2015
dx = 0.1;
x = 0:dx:1;
M = length(x); 

% Z = y(1,:);
% Y = y(2,:);
Z = y(1:M,1);
Y = y(M+1:2*M,1);

non_dim = 0;
BC = 2;
D = 6e-6;
beta_changing = 0;


%% Set up inpulse
if beta_changing == 1
    beta = (0.2*(1+tanh((x-0.2)/0.01)))';
elseif beta_changing == 0
    beta = 0.3;
else
    error('beta_changing is a boolian, 1 = yes use tanh function  or 0 = use constant value')
end

%% set up coeff_u matrix
coeff_u = -2*eye(M) + diag(ones(M-1,1),1) + diag(ones(M-1,1),-1);
if BC == 1 % periodic
    coeff_u(1,end) = 1;
    coeff_u(end,1) = 1;
elseif BC == 2 % no flux
    coeff_u(1,2) = 2;
    coeff_u(end,end-1) = 2;
else
    error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
end
%% Find L
if non_dim == 0
    [L_Z,L_Y] = calc_L_phy_ex(Z, Y, beta);
elseif non_dim == 1
    [L_Z,L_Y] = calc_L_phy_ex2(Z, Y, beta);
else
    error('no_dim is a boolian, 1 = yesuse non dementioned  or 0 = use dementions')
end

%% Calculate the rate of changes
test = (D/dx^2)*coeff_u*Z;
dZ_dt = (D/dx^2)*coeff_u*Z + L_Z;
dY_dt = L_Y;
if max((D/dx^2)*coeff_u*Z)>0
    c = 5%error('Not same for all x')
end
dy = [];
dy(1:M,1) = dZ_dt;
dy(M+1:2*M,1) = dY_dt;


end

