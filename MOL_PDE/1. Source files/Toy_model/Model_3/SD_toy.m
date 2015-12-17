function [ Z] = SD_toy( dt, dx, x, t, M, N, Z_0, V_0, D, B)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Choose boolian
% Choose Boundary condition
BC = 2; % 1 = periodic, 2 =  no flux

%% A Constants
A1_const = D*dt/dx^2;
A4_const = A1_const;

%% Start solver 
% Set up IC as a vector length M
Z = zeros(M, N);
V = zeros(M, N);
V(:,1) = ones(M,1) *V_0;
Z(:,1) = ones(M,1) *Z_0;


% create coeff u_i Matrix
AAA_21_matrix = (2*eye(M) - diag(ones(M-1,1),1) - diag(ones(M-1,1),-1));
A1            = A1_const * AAA_21_matrix + eye(M);
A2            = zeros(M);
A3            = zeros(M);
A4            = A4_const * AAA_21_matrix + eye(M);
% A4            = eye(M);


if BC == 1 % Periodic
    A1(1,end) = - A1_const; A1(end,1) = - A1_const;
    A4(1,end) = - A4_const; A4(end,1) = - A4_const;
elseif BC == 2 % No Flux
    A1(1,2) = - 2* A1_const; A1(end,end-1) = - 2* A1_const;
    A4(1,2) = - 2* A4_const; A4(end,end-1) = - 2* A4_const;
else
    error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
end

A = [A1,A2; A3, A4];
inv_A = inv(A);
inv_A = sparse(inv_A);
% Loop through time
for k = 1:N-1
    % Call function to calculate L for Z and Y
    [L_Z, L_V] = calc_L_ZYV_toy(B, Z(:,k), V(:,k));
    
    b = [Z(:,k) + dt*(L_Z);V(:,k) + dt*(L_V)];
    
    %% Before you continue test that everything is ok by refeeding
    res = inv_A*b;
    Z(:,k+1) = res(1:M);
    V(:,k+1) = res(M+1:end);
end
end

