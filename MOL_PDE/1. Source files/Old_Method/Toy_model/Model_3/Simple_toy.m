function [ Z] = Simple_toy( dt, dx, x, t, M, N, Z_0, V_0, B);
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

D  = 0;

%% Start solver 
% Set up IC as a vector length M
% x_grope = [-3:6/(M-1):3];
% normZ = normpdf(x_grope,0,1)-0.0044;
Z = zeros(M, N); 
V = zeros(M, N); 
Z(:,1) = ones(M,1) .*Z_0;
V(:,1) = ones(M,1) .*V_0;

%% loop for all time
% A1= eye(M);
% A2 = diag(-dt*x);
% A4 = diag(dt*x);
% 
% A = [A1,A2; A1, A4];
% inv_A = inv(A)
for k = 1:N-1
    % Call function to calculate L for Z and Y
    [L_Z, L_V] = calc_L_ZYV_toy(B, Z(:,k), V(:,k));
    
    Z(:,k+1) = Z(:,k) + dt*(L_Z);
    V(:,k+1) = V(:,k) + dt*(L_V);
end

end

