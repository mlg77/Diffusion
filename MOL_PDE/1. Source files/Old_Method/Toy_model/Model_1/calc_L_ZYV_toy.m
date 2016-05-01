function [L_Z] = calc_L_ZYV_toy(x, t, A)
%Linear 'Toy model' Equation set
%   Calculates the linear concentration rates for the calcium in the
%   cytocol, phi.


my_alpha = 2*pi;
%% Model 2 uses a zeros region
indx_xtop = find(x>=0.2, 1);
indx_xbot = find(x>=0.8, 1);
x_new = zeros(size(x));
x_new(indx_xtop:indx_xbot) = linspace(0,1, abs(indx_xtop-indx_xbot)+1);


% Equations For different models
L_Z1 =  (A*x.*cos(my_alpha*x*t))';
L_Z2 =  (A.*x_new.*cos(my_alpha*x_new*t))';
% L_Z3 = i*x*u


L_Z = L_Z2;
end

