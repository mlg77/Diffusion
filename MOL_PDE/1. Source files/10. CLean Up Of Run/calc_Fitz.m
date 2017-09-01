function [L_X, L_Y] = calc_Fitz(X, V, mybeta)
%FitzHugh Nagumo Model Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

% my beta is 0 to 1 so make myI that
myI = mybeta;


mya = 0.7;
myb = 0.8;
mtou = 12.5;

L_X = (V + mya - myb.*X)./mtou;
L_V = V - V.^3./3 - X + myI;

L_Y = L_V;
end

