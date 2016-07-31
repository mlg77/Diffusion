function [ Z, V ] = Gold_Simple( dt, dx, x, t, M, N, Z_0, V_0, Y_0, beta, check);
%Solve Goldbeter et al with zero diffusion
%   No inverse needed

D  = 0;
Cm = 1.9635e-14;

%% Start solver 
% Set up IC as a vector length M
Z = zeros(M, N);  V = zeros(M, N); Y = zeros(M, N);
Z(:,1) = ones(M,1) *Z_0;
V(:,1) = ones(M,1) * V_0;
Y(:,1) = ones(M,1) * Y_0;


%% loop for all time
for k = 1:N-1
    % Call function to calculate L for Z and Y
    [L_Z, L_V, L_Y] = calc_L_ZYV(Z(:,k), V(:,k), Y(:,k), beta);
    
    Z(:,k+1) = Z(:,k) + dt*(L_Z);
    V(:,k+1) = V(:,k)+ dt*(L_V/Cm);
    Y(:,k+1) = Y(:,k) + dt*(L_Y);
    
    ZVY_k0 = [Z(:,k+1);V(:,k+1); Y(:,k+1)];
    if check ==1
        for testing = 1:1:10
            mid_Z = ZVY_k0(1:M);
            mid_V = ZVY_k0(M+1:2*M);
            mid_y = ZVY_k0(2*M+1:3*M);

            [L_Z, L_V, L_Y] = calc_L_ZYV(mid_Z, mid_V, mid_y, beta);
            b1 = Z(:,k) + dt*(L_Z);
            b2 = V(:,k) + dt*((1/Cm)*L_V);
            b3 = Y(:,k) + dt*L_Y;
            ZVY_k1 = [b1;b2;b3];
            if max(abs(ZVY_k1 - ZVY_k0)./ZVY_k1) < 1e-5
                break
            else
                ZVY_k0 = ZVY_k1;
            end
        end
    else
        ZVY_k1 = ZVY_k0;
    end
    Z(:,k+1) = ZVY_k1(1:M);
    V(:,k+1) = ZVY_k1(M+1:2*M);
    Y(:,k+1) = ZVY_k1(2*M+1:3*M);

end

end

