function [L_X, L_Y] = calc_ToyXi(X, Y, mybeta, myXi)
%Toy Xi changing fh Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

a = 0.2;
	
L_X = mybeta.*Y - X.^3/3 + myXi.*X;
L_Y = -(mybeta.*X + a);



end

