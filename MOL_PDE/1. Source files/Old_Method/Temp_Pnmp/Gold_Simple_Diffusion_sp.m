function [ Z, V ] = Gold_Simple_Diffusion_sp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, beta, D)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Choose boolian
% Choose Boundary condition
BC = 2; % 1 = periodic, 2 =  no flux

F = 9.6485e-5; 
Cm = 1.9635e-14;
lil_z = 2;

% Volume
radius_cell = 2.5e-4;
length_cell = 6e-3;
V_cell = pi*radius_cell^2*length_cell;
fraction_cyto = 0.55;
V_cyto = fraction_cyto*V_cell;


%% Now after Moler correction!!!
A3_const = D*dt*V_cyto*F*lil_z/(Cm*dx^2);
A4_const = 1;
A1_const = D*dt/dx^2;
A2_const = 0;


%% Start solver 
% Set up IC as a vector length M
Z = zeros(M, N);  V = zeros(M, N); Y = zeros(M, N);
Z(:,1) = ones(M,1) *Z_0;
V(:,1) = ones(M,1) * V_0;
Y(:,1) = ones(M,1) * Y_0;

% create coeff u_i Matrix
AAA_21_matrix = (2*eye(M) - diag(ones(M-1,1),1) - diag(ones(M-1,1),-1));
A1            = A1_const * AAA_21_matrix + eye(M);
A2            = A2_const * AAA_21_matrix;
A3            = A3_const * AAA_21_matrix;
A4            = A4_const*eye(M);

if BC == 1 % Periodic
    A1(1,end) = - A1_const; A1(end,1) = - A1_const;
    A2 (1,end) = - A2_const; A2 (end,1) = - A2_const;
    A3(1,end) = - A3_const; A3(end,1) = - A3_const;
elseif BC == 2
    A1(1,2) = - 2* A1_const; A1(end,end-1) = - 2* A1_const;
    A2(1,2) = - 2* A2_const; A2(end,end-1) = - 2* A2_const;
    A3(1,2) = - 2* A3_const; A3(end,end-1) = - 2* A3_const;
else
    error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
end

A = [A1, A2; A3, A4];
inv_A = inv(A);
inv_A(2*M+1:3*M,2*M+1:3*M) = eye(M);
inv_A = sparse(inv_A);
factor = 0.01;
%% loop for all time
% tic
for k = 1:N-1
    % Call function to calculate L for Z and Y
    [L_Z, L_V, L_Y] = calc_L_ZYV_G(Z(:,k), V(:,k), Y(:,k), beta);
    
    b1 = Z(:,k) + dt*(L_Z);
    b2 = V(:,k) + dt*((1/Cm)*L_V);
    b3 = Y(:,k) + dt*L_Y;
    
    % Use Backward Euler Ax = b thus x = inv(A)*b
    b = [b1;b2;b3];
    
    %% Before you continue test that everything is ok by refeeding
    ZVY_k0 = inv_A*b;
    for testing = 1:1:300
        mid_Z = ZVY_k0(1:M);
        mid_V = ZVY_k0(M+1:2*M);
        mid_y = ZVY_k0(2*M+1:3*M);

        [L_Z, L_V, L_Y] = calc_L_ZYV_G(mid_Z, mid_V, mid_y, beta);
        b1 = Z(:,k) + dt*(L_Z);
        b2 = V(:,k) + dt*((1/Cm)*L_V);
        b3 = Y(:,k) + dt*L_Y;
        b = [b1;b2;b3];
        ZVY_k1 = inv_A*b;
        if max(abs((ZVY_k1 - ZVY_k0)./ZVY_k1)) < 1e-3
            break
        else
            ZVY_k0 = ZVY_k1;
        end
    end
    if testing>299
        error('Need more testing loops')
    end
    if k>factor*N
%         factor = factor+0.01
%         toc
    end
    %% Save it 
    Z(:,k+1) = ZVY_k1(1:M);
    V(:,k+1) = ZVY_k1(M+1:2*M);
    Y(:,k+1) = ZVY_k1(2*M+1:3*M);
    
end
end

