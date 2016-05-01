function [ Z] = Simple_toy( dt, dx, x, t, M, N, Z_0);
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

D  = 0;

%% Start solver 
% Set up IC as a vector length M
Z = zeros(M, N); 
Z(:,1) = ones(M,1) *Z_0;

%% loop for all time
A= Z_0;
for k = 1:N-1
    % Call function to calculate L for Z and Y
    [L_Z] = calc_L_ZYV_toy(x, t(k), A);
    
    Z(:,k+1) = Z(:,k) + dt*(L_Z);
    
end

end

