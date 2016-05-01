function [L_Z, L_V] = calc_L_ZYV_toy(B, Z, V, al)
%Linear 'Toy model' Equation set
%   Calculates the linear concentration rates for the calcium in the
%   cytocol, phi.



L_Z = - B.*V - Z.^3/3+Z;
L_V = + B.*Z + al;


end

