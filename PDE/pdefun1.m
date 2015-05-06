function [ c,f,s ] = pdefun1( x,t,u,du_dx )
%pdefun1 the partial differential equations
%   Attempt 1 
%   Michelle Goodman
%   21/4/2015

% There is a Z and a Y; Let Z=u(1) and Y = u(2)
%% constants
v0 = 1e-6;
v1 = 7.3e-6;
beta = 0.2*(1+tanh((x-0)/0.01));
V_m2 = 65e-6;
V_m3 = 500e-6;

n = 2;
m = n;
p = 4;

K_2 = 1e-6;
K_R = 2e-6;
K_a =  0.9e-6;

k_f = 10;
k = 1;

D_z  = 6e-12;


% L equations in terms of Z and Y 
LZ = @(Z, Y) v0 +v1*beta - V_m2*Z^n/(K_2^n+Z^n) + (V_m3*Y^m/(K_R^m +Y^m))*(Z^p/(K_a^p+Z^p)) + k_f*Y - k*Z;
LY = @(Z, Y) V_m2*Z^n/(K_2^n+Z^n) - (V_m3*Y^m/(K_R^m + Y^m))*(Z^p/(K_a^p+Z^p)) - k_f*Y;

% Z Equations
c1 = 1;
f1 = D_z*du_dx(1);
s1 = LZ(u(1), u(2));
% Y Equations
c2 = 1;
f2 = 0;
s2 = LY(u(1), u(2));
% Combine for pde format
c = [c1;c2];
f = [f1;f2];
s = [s1;s2];

end

