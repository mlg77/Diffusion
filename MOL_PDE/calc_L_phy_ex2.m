function [L_Z,L_Y] = calc_L_phy_ex2(Z, Y, beta)
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




% L equations in terms of Z and Y 
LZ = @(Z, Y) a0 +a1*beta - a2*Z.^n./(a3+Z.^n) + (a4*Y.^m./(1 +Y.^m)).*(Z.^p./(a5+Z.^p)) + Y - a6*Z;
LY = @(Z, Y) a2*Z.^n./(a3+Z.^n) - (a4*Y.^m./(1 + Y.^m)).*(Z.^p./(a5+Z.^p)) - Y;

L_Z = LZ(Z,Y);
L_Y = LY(Z,Y);

end

