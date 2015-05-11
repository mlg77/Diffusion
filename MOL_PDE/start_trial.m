% Start of my MOL code
% Michelle Goodman
% 29/04/2015

clear; clc; close all
tic
% Set x and t
dt = 0.01;
dx = 1e-3;
t_end = 100;

%% Choose boolian
% Choose Boundary condition
BC = 2; % 1 = periodic, 2 =  no flux
% Choose dimentionless
non_dim = 1; % or 0 for no
% Choose beta
beta_changing = 1;

%% Inital Condition
Z_0 = 0;
Y_0 = 0;
% Diffusion Constant
D_choice  = 3;
if D_choice == 1
    D = 0;
elseif D_choice == 2;
    D = 1e-6;
elseif D_choice == 3;
    D = 6e-6;
elseif D_choice == 4;
    D = 6e-4;
end

%%
x = 0:dx:1;
t = 0:dt:t_end;
%% Set up inpulse
if beta_changing == 1
    beta = (0.5*(1+tanh((x-0.5)/0.5)))';
elseif beta_changing == 0
    beta = 0.3;
else
    error('beta_changing is a boolian, 1 = yes use tanh function  or 0 = use constant value')
end

%% Start solver 
% Number of elements in x = M
M = length(x); 
% Set up IC as a vector length M
Z(:,1) = ones(M,1) *Z_0;
Y(:,1) = ones(M,1) * Y_0;

% create coeff u_i Matrix
alp = dx^2/(D*dt);
coeff_u = -(2+alp)*eye(M) + diag(ones(M-1,1),1) + diag(ones(M-1,1),-1);
if BC == 1 
    coeff_u(1,end) = 1;
    coeff_u(end,1) = 1;
elseif BC == 2
    coeff_u(1,2) = 2;
    coeff_u(end,end-1) = 2;
else
    error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
end
% find inverse of coeff_u
inv_A = inv(coeff_u);

%% loop for all time
for k = 1:length(t)-1
    % Call function to calculate L for Z and Y
    if non_dim == 0
        [L_Z,L_Y] = calc_L_phy_ex(Z(:,k), Y(:,k), beta);
    elseif non_dim == 1
        [L_Z,L_Y] = calc_L_phy_ex2(Z(:,k), Y(:,k), beta);
        K_R = 2;
    else
        error('no_dim is a boolian, 1 = yes use non dementioned  or 0 = use dementions')
    end
    % Use Backward Euler Ax = b thus x = inv(A)*b
    b = -alp*(Z(:,k)+dt*L_Z);
    Z_k1 = inv_A*b;
    if D == 0
        Z_k1 = Z(:,k) + dt*L_Z;
    end
    Y_k1 = Y(:,k) + dt*L_Y;
    % Save it 
    Z(:,k+1) = Z_k1;
    Y(:,k+1) = Y_k1;
end
end_time = toc;
display(['Simulation Complete in ',num2str(end_time), ' seconds'])

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
    plot(t, Z(10,:), t, Y(10,:))
    xlabel('Time, [s]')
    ylabel('Calcium Concentration [\muM]')
    legend('Z', 'Y')
end
