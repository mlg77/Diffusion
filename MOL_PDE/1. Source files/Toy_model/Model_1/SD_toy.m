function [ Z] = SD_toy( dt, dx, x, t, M, N, Z_0, D)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Choose boolian
% Choose Boundary condition
BC = 2; % 1 = periodic, 2 =  no flux

%% A Constants
A1_const = D*dt/dx^2;


%% Start solver 
% Set up IC as a vector length M
Z = zeros(M, N);
Z(:,1) = ones(M,1) *Z_0;

% create coeff u_i Matrix
AAA_21_matrix = (2*eye(M) - diag(ones(M-1,1),1) - diag(ones(M-1,1),-1));
A1            = A1_const * AAA_21_matrix + eye(M);

if BC == 1 % Periodic
    A1(1,end) = - A1_const; A1(end,1) = - A1_const;
elseif BC == 2 % No Flux
    A1(1,2) = - 2* A1_const; A1(end,end-1) = - 2* A1_const;
else
    error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
end

A = [A1];
inv_A = inv(A);
inv_A = sparse(inv_A);
% Loop through time
for k = 1:N-1
    % Call function to calculate L for Z and Y
    [L_Z] = calc_L_ZYV_toy(x, t(k), Z_0);
    
    b = Z(:,k) + dt*(L_Z);
    
    %% Before you continue test that everything is ok by refeeding
    Z(:,k+1) = inv_A*b;
        
end
end

