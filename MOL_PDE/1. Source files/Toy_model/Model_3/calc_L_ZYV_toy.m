function [L_Z, L_V] = calc_L_ZYV_toy(B, Z, V)
%Linear 'Toy model' Equation set
%   Calculates the linear concentration rates for the calcium in the
%   cytocol, phi.



L_Z = - B.*V;
L_V = + B.*Z;


end

