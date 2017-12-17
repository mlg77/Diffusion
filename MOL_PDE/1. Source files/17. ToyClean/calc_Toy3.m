function [L_X, L_Y] = calc_Toy3(X, Y, mybeta, myxi)
%Toy 3
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

% my beta is 0 to 1 so make myI that
myalpha = 0.2;
L_X = mybeta.*Y - X.^3/3 + myxi* X;
L_Y = -(mybeta.*X + myalpha);

end

