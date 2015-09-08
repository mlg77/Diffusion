function [L_Z,L_Y, L_V] = calc_L_ZYV2(Z, Y, V, beta)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

n = 2;
m = n;
p = 4;

a0 = 0.5;
a1 = 3.65;
a2 = 32.5;
a4 = 250;
a6 = 10;
a3 = 0.5;
a5 = 0.45;

error('Havent finished V')


% L equations in terms of Z and Y 
LZ = @(Z, Y) a0 +a1*beta - a2*Z.^n./(a3^n+Z.^n) + (a4*Y.^m./(1 +Y.^m)).*(Z.^p./(a5^p+Z.^p)) + Y - a6*Z;
LY = @(Z, Y) a2*Z.^n./(a3^n+Z.^n) - (a4*Y.^m./(1 + Y.^m)).*(Z.^p./(a5^p+Z.^p)) - Y;
LV = @(Z) F/C_m*(v0-k*Z);

L_Z = LZ(Z,Y);
L_Y = LY(Z,Y);
L_V = LV(Z);

end

