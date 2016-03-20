function [ C, Ct, P, H ] = Sneyd_Simple_Diffusion_sp( dt, dx, x, t, M, N, CCtPH_0, mbeta, D)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Choose boolian
% Choose Boundary condition
BC = 2; % 1 = periodic, 2 =  no flux

%Voltage stuff
% F = 9.6485e-5; 
% Cm = 1.9635e-14;
% lil_z = 2;

% Volume
% radius_cell = 2.5e-4;
% length_cell = 6e-3;
% V_cell = pi*radius_cell^2*length_cell;
% fraction_cyto = 0.55;
% V_cyto = fraction_cyto*V_cell;


%% Now after Moler correction!!!
A1_const = D*dt/dx^2;
A2_const = 0;
A3_const = A1_const;
A4_const = 1;
% Book Sneyd
A1_const = D*dt/dx^2;
A2_const = 0;
A3_const = 0;%A1_const;
A4_const = 1;

%% Start solver 
% Set up IC as a vector length M
C = zeros(M, N);  Ct = zeros(M, N); P = zeros(M, N); H = zeros(M, N);
C(:,1) = ones(M,1) *CCtPH_0(1);
Ct(:,1) = ones(M,1) * CCtPH_0(2);
P(:,1) = ones(M,1) * CCtPH_0(3);
H(:,1) = ones(M,1) * CCtPH_0(4);

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
% A = [A1, A2; A3, A4];
% inv_A = inv(A);
% inv_A(2*M+1:4*M,2*M+1:4*M) = eye(2*M);
% inv_A = sparse(inv_A);
factor = 0.01;
%% Sneyd Book
inv_A1 = inv(A1);
inv_A = eye(2*M);
inv_A(3*M+1:4*M, 3*M+1:4*M) = eye(M);
inv_A(2*M+1:3*M, 2*M+1:3*M) = inv_A1; % Diffuse IP3 only
inv_A = sparse(inv_A);

%% loop for all time
% tic
check = 0;
for k = 1:N-1
    % Call function to calculate 
    [L_C, L_Ct, L_P, L_H] = calc_L_ZYV_S(C(:,k), Ct(:,k), P(:,k), H(:,k), mbeta);
    
    b1 = C(:,k) + dt*(L_C);
    b2 = Ct(:,k)+ dt*(L_Ct);
    b3 = P(:,k) + dt*(L_P);
    b4 = H(:,k) + dt*(L_H);
    
    
    % Use Backward Euler Ax = b thus x = inv(A)*b
    b = [b1;b2;b3;b4];
    
    %% Before you continue test that everything is ok by refeeding
    CCtPH_k0 = inv_A*b;
    if check == 1
        for testing = 1:1:120
            mid_C = CCtPH_k0(1:M);
            mid_Ct = CCtPH_k0(M+1:2*M);
            mid_P = CCtPH_k0(2*M+1:3*M);
            mid_H = CCtPH_k0(3*M+1:4*M);

            [L_C, L_Ct, L_P, L_H] = calc_L_ZYV_S(mid_C, mid_Ct, mid_P, mid_H, mbeta);
            b1 = C(:,k) + dt*(L_C);
            b2 = Ct(:,k)+ dt*(L_Ct);
            b3 = P(:,k) + dt*(L_P);
            b4 = H(:,k) + dt*(L_H);
            b = [b1;b2;b3;b4];
            CCtPH_k1 = inv_A*b;
            if max(abs((CCtPH_k1 - CCtPH_k0)./CCtPH_k1)) < 1e-5
                break
            else
    %             max(abs((CCtPH_k1 - CCtPH_k0)./CCtPH_k1))
                CCtPH_k0 = CCtPH_k1;
            end
        end
        if testing>119
            error('Need more testing loops')
        end
    else
        CCtPH_k1 = CCtPH_k0;
    end
%     clc
    if k>factor*N
%         factor = factor+0.01
%         toc
    end
    %% Save it 
    C(:,k+1) = CCtPH_k1(1:M);
    Ct(:,k+1) = CCtPH_k1(M+1:2*M);
    P(:,k+1) = CCtPH_k1(2*M+1:3*M);
    H(:,k+1) = CCtPH_k1(3*M+1:4*M);
    
end
end

