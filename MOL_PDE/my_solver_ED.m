% Start of my MOL code
% Michelle Goodman
% 29/04/2015

clear; clc; close all
tic
h = waitbar(0);
perc = 0.01;
% Set x and t
dt = 0.01;
dx = 2e-3;
t_end = 100;
%%
x = 0:dx:1;
t = 0:dt:t_end;
% Number of elements in x = M
M = length(x); 


%% Choose boolian
% Choose Boundary condition
BC = 1; % 1 = periodic, 2 =  no flux
% Choose dimentionless
non_dim = 0; % or 0 for no
% Choose beta
beta_changing = 1;

fast = 0;

if fast == 1;
    A1_index = ones(M,1)*[1:2:2*M-1] + M*[0:4:4*M-1]'*ones(1,M);
    A2_index = ones(M,1)*[2:2:2*M] + M*[0:4:4*M-1]'*ones(1,M);
    A3_index = ones(M,1)*[1:2:2*M-1] + M*[2:4:4*M-1]'*ones(1,M);
    A4_index = ones(M,1)*[2:2:2*M] + M*[2:4:4*M-1]'*ones(1,M);
    A1_idx = reshape(A1_index.',1,[]);  A2_idx = reshape(A2_index.',1,[]);
    A3_idx = reshape(A3_index.',1,[]);  A4_idx = reshape(A4_index.',1,[]);
    
    b1_idx = 1:2:2*M-1;
    b2_idx = 2:2:2*M;
end

%% Inital Condition
Z_0 = 1;
Y_0 = 1;
V_0 = 60;

%% Diffusion Constant
D_choice  = 4;
if D_choice == 1
    D = 0;
elseif D_choice == 2;
    D = 1e-6;
elseif D_choice == 3;
    D = 6e-6;
elseif D_choice == 4;
    D1 = 6e-12;
    D =  6e-6;
end

D = D1;
if D == 0
    error('D = 0 use my_solver instead')
end
%% Initalise Electro Diffusion parameters
F = 9.6485e-2; 
R = 8.314e-3; 
T = 310;
A = 1.9635e-5; 
Cm = 1.9635e-14;
lil_z = 2;

my_gamma = F/(R*T);

%% Attempt 1
% A3_const = A*F*D*lil_z*dt/(Cm*dx^2);
% A4_const = A3_const*my_gamma;
% A1_const = D*dt/dx^2;
% A2_const = A1_const*my_gamma;

% b1_const = D*my_gamma/(2*dx)^2;
% b2_const = (lil_z*A*F/Cm)*b1_const;

%% Attempt 2
A3_const = F*D1*lil_z*dt/(Cm*dx^2);
A4_const = A3_const*lil_z*my_gamma;
A1_const = D*dt/dx^2;
A2_const = A1_const*lil_z*my_gamma;

b1_const = D*lil_z*my_gamma/(dx^2);
b2_const = (lil_z^2*F*D1*my_gamma)/(Cm*dx^2);

%% Attempt 3
% A3_const = F*D*lil_z*dt/(dx^2);
% A4_const = A3_const*lil_z*my_gamma;
% A1_const = D*dt/dx^2;
% A2_const = A1_const*lil_z*my_gamma;
% 
% b1_const = D*lil_z*my_gamma/(dx^2);
% b2_const = (lil_z^2*F*D*my_gamma)/(dx^2);

%% Set up inpulse
if beta_changing == 1
    beta = (0.5*(1+tanh((x-0.5)/0.5)))';
elseif beta_changing == 0
    beta = 0.3;
else
    error('beta_changing is a boolian, 1 = yes use tanh function  or 0 = use constant value')
end

%% Start solver 
% Set up IC as a vector length M
Z(:,1) = ones(M,1) *Z_0;
Y(:,1) = ones(M,1) * Y_0;
V(:,1) = ones(M,1) * V_0;

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
elseif BC == 2
    A1(1,2) = 2*A1(1,2); A1(end,end-1) = 2*A1(end,end-1);
    A2_missZ (1,2) = 2*A2_missZ (1,2); A2_missZ (end,end-1) = 2*A2_missZ (end,end-1);
    A3(1,2) = 2*A3(1,2); A3(end,end-1) = 2*A3(end,end-1);
    A4_missZ_missI(1,2) = 2*A4_missZ_missI(1,2); A4_missZ_missI(end,end-1) = 2*A4_missZ_missI(end,end-1);
    A5(1,2) = 0; A5(end, end-1) = 0;
else
    error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
end


% find inverse of coeff_u

%% loop for all time
for k = 1:length(t)-1
    % Call function to calculate L for Z and Y
    if non_dim == 0
        [L_Z,L_Y, L_V] = calc_L_ZYV(Z(:,k), Y(:,k), V(:,k), beta);
    elseif non_dim == 1
        [L_Z,L_Y, L_V] = calc_L_ZYV2(Z(:,k), Y(:,k), V(:,k), beta);
        K_R = 2;
    else
        error('no_dim is a boolian, 1 = yes use non dementioned  or 0 = use dementions')
    end
   
    A2 = A2_missZ.*(Z(:,k)*ones(1,M));
    A4 = A4_missZ_missI.*(Z(:,k)*ones(1,M))+eye(M);
    % A4 = A4_missZ_missI.*(Z(:,k)*ones(1,M))+eye(M)/Cm;
    
    b5 = (A5*Z(:,k)).*(A5*V(:,k));
    
    b1 = Z(:,k) + dt*(b1_const*b5/4 + L_Z);
    b2 = V(:,k) + dt*(b2_const*b5/4 + (1/Cm)*L_V);
    %b2 = V(:,k)/Cm + dt*(b2_const*b5/4 + L_V);
    b3 = Y(:,k) + dt*L_Y;
    % Attempt to make faster to solve
    Fast_A = zeros(1, (2*M)^2);
    if fast == 1
        Fast_A(A1_idx) = reshape(A1.',1,[]);
        Fast_A(A2_idx) = reshape(A2.',1,[]);
        Fast_A(A3_idx) = reshape(A3.',1,[]);
        Fast_A(A4_idx) = reshape(A4.',1,[]);
        Fast_A = (reshape(Fast_A, [2*M,2*M]))';
        inv_A = inv(Fast_A);
        
        Fast_b(b1_idx) = b1;
        Fast_b(b2_idx) = b2;
        b = [Fast_b';b3];
    else
        % Use Backward Euler Ax = b thus x = inv(A)*b
        b = [b1;b2;b3];
        A_to = [A1, A2; A3, A4];
        inv_A = inv(A_to);
    end
    inv_A(2*M+1:3*M,2*M+1:3*M) = eye(M);

    ZVY_k1 = inv_A*b;
    
    % Save it 
    if fast == 1
        Z(:,k+1) = ZVY_k1(1:2:2*M-1);
        V(:,k+1) = ZVY_k1(2:2:2*M);
    else
        Z(:,k+1) = ZVY_k1(1:M);
        V(:,k+1) = ZVY_k1(M+1:2*M);
    end
    Y(:,k+1) = ZVY_k1(2*M+1:3*M);
%     hll = round(M/2);
%     check = [Z(1,k+1),Z(hll,k+1),Z(M,k+1);V(1,k+1),V(hll,k+1),V(M,k+1);Y(1,k+1),Y(hll,k+1),Y(M,k+1)]
    if max(isnan(ZVY_k1)) == 1
        'Huston we have a problem'
        break
    end
%     if min(Z(:,k+1)) < 0
%         t(k)
%         error('negative con')
%     end
    if t(k) > perc * t_end
        close(h)
        end_time = toc;
        length_left = end_time/perc-end_time;
        h = waitbar(perc, [num2str(perc*100), '% complete ETA: ', num2str(floor(length_left/60)), 'm ',num2str(round(rem(length_left, 60))) ' s']);
        perc = perc+0.01;
    end
end
end_time = toc;
display(['Simulation Complete in ',num2str(end_time), ' seconds'])
close(h)
if non_dim == 1
    Z = Z*K_R;
    Y = Y*K_R;
end

figure(1)
imagesc(t,flipud(x),flipud(Y))  
xlabel('Time, [s]')
ylabel('Position, x')
%title('Z, Calcium Concentration in the Cytosol, [\muM]')
colormap jet
if beta_changing
    figure(2)
    plot(beta,x)
    ylabel('Position, x')
    xlabel('Beta, [-]')
    set(gca,'YDir','reverse');
else
    figure(2)
    plot(t, Z(10,:), t, Y(10,:), t, V(10,:))
    xlabel('Time, [s]')
    ylabel('Calcium Concentration [\muM]')
    legend('Z', 'Y', 'V')
end
