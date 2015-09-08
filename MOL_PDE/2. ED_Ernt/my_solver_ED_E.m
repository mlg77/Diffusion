% Start of my MOL code including electro diffusion
% Michelle Goodman
% 19/05/2015

clear; clc; close all
tic
h = waitbar(0);
perc = 0.01;
% Set x and t
dt = 0.005;
dx = 2e-3;
t_end = 100;
%% 
x = 0:dx:1;
t = 0:dt:t_end;
% Number of elements in x = M
M = length(x); 
N = length(t);

%% Choose boolian
% Choose Boundary condition
BC = 1; % 1 = periodic, 2 =  no flux
% Choose dimentionless
non_dim = 0; % or 0 for no
% Choose beta
beta_changing = 1;

%% Inital Condition
Z_0 = 0.3;
V_0 = -40;
ON_0 = 1;

%% Diffusion Constant
D_choice  = 4;
if D_choice == 1
    D = 0;
elseif D_choice == 2;
    D = 1e-6;
elseif D_choice == 3;
    D = 6e-6;
elseif D_choice == 4;
    D =  10e-4;
end

if D == 0
    error('D = 0 use my_solver instead')
end
%% Initalise Electro Diffusion parameters
F = 9.6485e-5; 
R = 8.314e-6; 
T = 310;
%A = 1.9635e-5; 
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
b2_const = D*V_cyto*F*lil_z^2*my_gamma/(Cm*dx^2);


%% Set up inpulse
if beta_changing == 1
    beta = (0.5*(1+tanh((x-0.5)/0.2)))';
elseif beta_changing == 0
    beta = 0.3;
else
    error('beta_changing is a boolian, 1 = yes use tanh function  or 0 = use constant value')
end

%% Start solver 
% Set up IC as a vector length M
Z = zeros(M, N);  V = zeros(M, N); ON = zeros(M, N);
Z(:,1) = ones(M,1) *Z_0;
V(:,1) = ones(M,1) * V_0;
ON(:,1) = ones(M,1) * ON_0;

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

%% loop for all time
for k = 1:N-1
    % Call function to calculate L for Z and Y
    if non_dim == 0
        [L_Z, L_V, L_ON] = calc_L_ZYV_E(Z(:,k), V(:,k), ON(:,k), beta);
    elseif non_dim == 1
        [L_Z, L_V, L_ON] = calc_L_ZYV2_E(Z(:,k), V(:,k), ON(:,k), beta);
        K_R = 2;
    else
        error('no_dim is a boolian, 1 = yes use non dementioned  or 0 = use dementions')
    end
   
    A2 = A2_missZ.*(Z(:,k)*ones(1,M));
    A4 = A4_missZ_missI.*(Z(:,k)*ones(1,M))+eye(M);

    b5 = (A5*Z(:,k)).*(A5*V(:,k));
    
    b1 = Z(:,k) + dt*(b1_const*b5/4 + L_Z);
    b2 = V(:,k) + dt*(b2_const*b5/4 + (1/Cm)*L_V);
    b3 = ON(:,k) + dt*L_ON;
    
    % Use Backward Euler Ax = b thus x = inv(A)*b
    b = [b1;b2;b3];
    A_to = [A1, A2; A3, A4];
    inv_A = inv(A_to);
    inv_A(2*M+1:3*M,2*M+1:3*M) = eye(M);

    ZVY_k1 = inv_A*b;
    
    % Save it 
    Z(:,k+1) = ZVY_k1(1:M);
    V(:,k+1) = ZVY_k1(M+1:2*M);
    ON(:,k+1) = ZVY_k1(2*M+1:3*M);

    if max(isnan(ZVY_k1)) == 1
        'Huston we have a problem'
        break
    end
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
imagesc(t,flipud(x),flipud(Z))  
xlabel('Time, [s]')
ylabel('Position, x')
%title('Z, Calcium Concentration in the Cytosol, [\muM]')
colormap jet
if beta_changing
    v_1_top = -18; 
    v_1_bot = -30;
    v_1 = (v_1_top-v_1_bot)*beta + v_1_bot;
    figure(2)
    plot(v_1,x)
    ylabel('Position, x')
    xlabel('V_1, [-]')
    set(gca,'YDir','reverse');
else
    figure(2)
    plot(t, Z(10,:), t, ON(10,:), t, V(10,:))
    xlabel('Time, [s]')
    ylabel('Calcium Concentration [\muM]')
    legend('Z', 'ON', 'V')
end

figure(3)
imagesc(t,flipud(x),flipud(V))  
xlabel('Time, [s]')
ylabel('Position, x')
colormap jet
