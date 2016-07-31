function [ Z, V, dX_dx, gZdV_dx ] = Gold_Electro_Diffusion_fluxes( dt, dx, x, t, M, N, Z_0, V_0, Y_0, beta, D)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
%% Choose boolian
% Choose Boundary condition
reallycont = 0;
if exist('mid_run_ED.mat') == 2
    prompt = 'Do you really want to continue? yes=1/no=0: ';
    reallycont = input(prompt);
    if reallycont == 1
        load('mid_run_ED');
        ini_perc_com = perc;
        h = waitbar(perc, ['Continuing: ',num2str(perc*100), '% complete ETA: ', num2str(floor(length_left/60)), 'm ',num2str(round(rem(length_left, 60))) ' s']);
        perc = perc+0.05;
        tic
        mid_start = FYI_k;
    end
end
if reallycont == 0
    tic
    h = waitbar(0, 'Electro Diffusion');
    perc = 0.05;

    BC = 2; % 1 = periodic, 2 =  no flux
    % Choose dimentionless

    F = 9.6485e-5; 
    R = 8.314e-6; 
    T = 310;
    Cm = 1.9635e-14;
    lil_z = 2;
    k_B = 1.38e-20;
    my_alpha = 7.9976e12;
    my_gamma = F/(R*T);

    % Volume
    radius_cell = 2.5e-4;
    length_cell = 6e-3;
    V_cell = pi*radius_cell^2*length_cell;
    fraction_cyto = 0.55;
    V_cyto = fraction_cyto*V_cell;


    %% Now after Moler correction!!!
    A3_const = D*dt*V_cyto*F*lil_z/(Cm*dx^2);
    A4_const = A3_const*lil_z*my_gamma;
    A1_const = D*dt/dx^2;
    A2_const = A1_const*lil_z*my_gamma;

    b1_const = D*lil_z*my_gamma/(dx^2);
    b2_const = D*V_cyto*F*lil_z*lil_z*my_gamma/(Cm*dx^2);

    %% Start solver 
    % Set up IC as a vector length M
    Z = zeros(M, N);  V = zeros(M, N); Y = zeros(M, N);
    Z(:,1) = ones(M,1) *Z_0;
    V(:,1) = ones(M,1) * V_0;
    Y(:,1) = ones(M,1) * Y_0;
    dX_dx = zeros(M-2,N);
    gZdV_dx = zeros(M-2,N);

    % create coeff u_i Matrix
    AAA_21_matrix = (2*eye(M) - diag(ones(M-1,1),1) - diag(ones(M-1,1),-1));
    A1                  = A1_const * AAA_21_matrix + eye(M);
    A2_missZ            = A2_const * AAA_21_matrix;
    A3                  = A3_const * AAA_21_matrix;
    A4_missZ_missI      = A4_const * AAA_21_matrix;
    A5 = diag(ones(M-1,1),1) + diag(-ones(M-1,1),-1);
    if BC == 1 % Periodic
        A1(1,end) = - A1_const; A1(end,1) = - A1_const;
        A2_missZ (1,end) = - A2_const; A2_missZ (end,1) = - A2_const;
        A3(1,end) = - A3_const; A3(end,1) = - A3_const;
        A4_missZ_missI(1,end) = - A4_const; A4_missZ_missI(end,1) = - A4_const;
        A5(1,end) = -1; A5(end, 1) = 1;
    elseif BC == 2 % zero flux
        A1(1,2) = - 2* A1_const; A1(end,end-1) = - 2* A1_const;
        A2_missZ (1,2) = - 2* A2_const; A2_missZ (end,end-1) = - 2* A2_const;
        A3(1,2) = - 2* A3_const; A3(end,end-1) = - 2* A3_const;
        A4_missZ_missI(1,2) = - 2*A4_const; A4_missZ_missI(end,end-1) = - 2*A4_const;
        A5(1,2) = 0; A5(end, end-1) = 0;
    else
        error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
    end
    mid_start = 1;
    ini_perc_com = 0;
    % Sparse that shit
    sA1 = sparse(A1);
    sA2_missZ = sparse(A2_missZ);
    sA3 = sparse(A3);
    sA4_missZ_missI = sparse(A4_missZ_missI);
    sA5 = sparse(A5);
end
%% loop for all time
for k = mid_start:N-1
    % Call function to calculate L for Z and Y
    [L_Z, L_V, L_Y] = calc_L_ZYV_G(Z(:,k), V(:,k), Y(:,k), beta);
    mysigma = [Z(:,k);V(:,k);Y(:,k)];
    
    sA2 = sA2_missZ.*(Z(:,k)*ones(1,M));
    sA4 = sA4_missZ_missI.*(Z(:,k)*ones(1,M))+sparse(eye(M));

    b5 = (sA5*Z(:,k)/2).*(sA5*V(:,k)/2);
    
    b1 = Z(:,k) + dt*(b1_const*b5 + L_Z);
    b2 = V(:,k) + dt*(b2_const*b5 + (1/Cm)*L_V);
    b3 = Y(:,k) + dt*L_Y;
    
    % Use Backward Euler Ax = b thus x = inv(A)*b
    b = [b1;b2;b3];
    sA_to = [sA1, sA2; sA3, sA4];
    sA = [sA_to, zeros(2*M, M); zeros(M, 2*M), sparse(eye(M))];
    
    ZVY_k0 = Solve_noinv( sA, b, mysigma ); 
        %% Before you continue test that everything is ok by refeeding
    for testing = 1:1:30
        mid_Z = ZVY_k0(1:M);
        mid_V = ZVY_k0(M+1:2*M);
        mid_Y = ZVY_k0(2*M+1:3*M);
        mysigma = [ mid_Z; mid_V; mid_Y];
        
        sA2 = sA2_missZ.*(mid_Z*ones(1,M));
        sA4 = sA4_missZ_missI.*(mid_Z*ones(1,M))+sparse(eye(M));
        
        b5 = (sA5*mid_Z/2).*(sA5*mid_V/2);
        [L_Z, L_V, L_Y] = calc_L_ZYV_G(mid_Z, mid_V, mid_Y, beta);
        b1 = Z(:,k) + dt*(b1_const*b5 + L_Z);
        b2 = V(:,k) + dt*(b2_const*b5 + (1/Cm)*L_V);
        b3 = Y(:,k) + dt*L_Y;
        b = [b1;b2;b3];
        sA_to = [sA1, sA2; sA3, sA4];
        sA = [sA_to, zeros(2*M, M); zeros(M, 2*M), sparse(eye(M))];
        ZVY_k1 = Solve_noinv( sA, b, mysigma ); 
                
        if max(abs(ZVY_k1 - ZVY_k0)./ZVY_k1) < 1e-3
            break
        else
            ZVY_k0 = ZVY_k1;
        end
    end
    if testing>29
        error('Need more testing loops')
    end
    
    %% Save it 
    Z(:,k+1) = ZVY_k1(1:M);
    V(:,k+1) = ZVY_k1(M+1:2*M);
    Y(:,k+1) = ZVY_k1(2*M+1:3*M);
    
    dX_dx(:,k+1) = (Z(3:end,k+1)-Z(1:end-2,k+1))/(2*dx);
    gZdV_dx(:,k+1) = my_gamma*Z(2:end-1,k+1).*(V(3:end,k+1)-V(1:end-2,k+1))/(2*dx); 
    %% Print timer 
    if t(k) > perc * t(end)
        close(h)
        end_time = toc
        length_left = end_time*(1-ini_perc_com)/(perc-ini_perc_com)-end_time;
        FYI_k = k+1;
        save('mid_run_ED')
        h = waitbar(perc, [num2str(perc*100), '% complete ETA: ', num2str(floor(length_left/60)), 'm ',num2str(round(rem(length_left, 60))) ' s']);
        perc = perc+0.05;
    end
end
delete('mid_run_ED.mat')
close(h)
end

