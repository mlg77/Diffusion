function [L_Z, L_V] = calc_L_ZYV(Z, V, mbeta)
%Toy Model Equations Set
%   Calculates the non linear concentration rates for the calciun in the
%   cytocol, Z, the calcium in the stores, and the membrain potential.
%   where beta is a spatially varying variable 

phi = Z;
psi = V;


u = mbeta+0.0000001;
g =@(u) u;
h =@(u) 1;
f =@(u) 1;

dphi_dt = (phi- g(u)).*(1-u.^2 - (phi - g(u)).^2 - (psi - h(u)).^2)-(psi-h(u)).*f(u);
dpsi_dt = (psi- h(u)).*(1-u.^2 - (phi - g(u)).^2 - (psi - h(u)).^2)+(phi-g(u)).*f(u);

L_Z = dphi_dt;
L_V = dpsi_dt;

end

