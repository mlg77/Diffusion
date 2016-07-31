function [ C, Ct, P, H ] = Sneyd_Simple( dt, dx, x, t, M, N, CCtPH_0, mbeta, check);
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%% Start solver 
% Set up IC as a vector length M
C = zeros(M, N);  Ct = zeros(M, N); P = zeros(M, N); H = zeros(M, N);
C(:,1) = ones(M,1) *CCtPH_0(1);
Ct(:,1) = ones(M,1) * CCtPH_0(2);
P(:,1) = ones(M,1) * CCtPH_0(3);
H(:,1) = ones(M,1) * CCtPH_0(4);


%% loop for all time
for k = 1:N-1
    % Call function to calculate L for Z and Y
    [L_C, L_Ct, L_P, L_H] = calc_L_ZYV_S(C(:,k), Ct(:,k), P(:,k), H(:,k), mbeta);
    
    C(:,k+1) = C(:,k) + dt*(L_C);
    Ct(:,k+1) = Ct(:,k)+ dt*(L_Ct);
    P(:,k+1) = P(:,k) + dt*(L_P);
    H(:,k+1) = H(:,k) + dt*(L_H);
    
    CCtPH_k0 = [C(:,k+1);Ct(:,k+1); P(:,k+1); H(:,k+1)];
    if check ==1
        for testing = 1:1:10
            mid_C = CCtPH_k0(1:M);
            mid_Ct = CCtPH_k0(M+1:2*M);
            mid_P = CCtPH_k0(2*M+1:3*M);
            mid_H = CCtPH_k0(3*M+1:4*M);
            
            [L_C, L_Ct, L_P, L_H] = calc_L_ZYV_S(mid_C, mid_Ct, mid_P, mid_H, mbeta);
            b1 = C(:,k) + dt*(L_C);
            b2 = Ct(:,k) + dt*(L_Ct);
            b3 = P(:,k) + dt*(L_P);
            b4 = H(:,k) + dt*L_H;
            CCtPH_k1 = [b1;b2;b3;b4];
            if max(abs(CCtPH_k1 - CCtPH_k0)./CCtPH_k1) < 1e-5
                break
            else
                CCtPH_k0 = CCtPH_k1;
            end
        end
    else
        CCtPH_k1 = CCtPH_k0;
    end
    C(:,k+1) = CCtPH_k1(1:M);
    Ct(:,k+1) = CCtPH_k1(M+1:2*M);
    P(:,k+1) = CCtPH_k1(2*M+1:3*M);
    H(:,k+1) = CCtPH_k1(3*M+1:4*M);

end

end

