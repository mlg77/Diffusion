% Start of my MOL code
% Michelle Goodman
% 29/04/2015

clear; clc; close all
tic
% Set x and t
dt = 0.005;
dx = 2e-3;
t_end = 100;

%% Choose boolian
% Choose Boundary condition
BC = 2; % 1 = periodic, 2 =  no flux
% Choose dimentionless
non_dim = 0; % or 0 for no
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
    D = 6e-12;
elseif D_choice == 3;
    D = 6e-6;
elseif D_choice == 4;
    D = 6e-4;
end
% % % % %% Guii
% % % % prompt = {'Enter time step:','Enter time end:', 'Enter x step', 'Enter Diffusion Constant' };
% % % % dlg_title = 'Input';
% % % % num_lines = 1;
% % % % def = {num2str(dt), num2str(t_end), num2str(dx), num2str(D)};
% % % % answer = inputdlg(prompt,dlg_title,num_lines,def);
% % % % for i = 1:length(answer)
% % % %     answer2(i) = str2num(answer{i});
% % % % end
% % % % dt = answer2(1); t_end = answer2(2); dx = answer2(3); D = answer2(4);
% % % % 
% % % % prompt = {'Choose BC 1= periodic, 2= no flux:','Choose 0= dimention 1= non-dimentionalised:', 'Choose changing beta 1 = yes:' };
% % % % dlg_title = 'Choice';
% % % % num_lines = 1;
% % % % def = {num2str(BC), num2str(non_dim), num2str(beta_changing)};
% % % % answer = inputdlg(prompt,dlg_title,num_lines,def);
% % % % for i = 1:length(answer)
% % % %     answer2(i) = str2num(answer{i});
% % % % end
% % % % BC = answer2(1); non_dim = answer2(2); beta_changing = answer2(3);

%%
x = 0:dx:1;
t = 0:dt:t_end;
%% Set up inpulse
if beta_changing == 1
    beta = (0.5*(1+tanh((x-0.5)/0.5)))';
elseif beta_changing == 0
    beta = 0.6;%0.3;
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
coeff_u = -2*eye(M) + diag(ones(M-1,1),1) + diag(ones(M-1,1),-1);
if BC == 1 
    coeff_u(1,end) = 1;
    coeff_u(end,1) = 1;
elseif BC == 2
    coeff_u(1,2) = 2;
    coeff_u(end,end-1) = 2;
else
    error('Boundry condition not specified, Choose 1; periodic or 2; No flux')
end

%% loop for all time
for k = 1:length(t)-1
    % Call function to calculate L for Z and Y
    if non_dim == 0
        [L_Z,L_Y] = calc_L_phy_ex(Z(:,k), Y(:,k), beta);
    elseif non_dim == 1
        [L_Z,L_Y] = calc_L_phy_ex2(Z(:,k), Y(:,k), beta);
    else
        error('no_dim is a boolian, 1 = yes use non dementioned  or 0 = use dementions')
    end
    % Calculate the rate of changes
    dZ_dt = (D/dx^2)*coeff_u*Z(:,k) + L_Z;
    % dZ_dt = L_Z;
    dY_dt = L_Y;
% % %     % Put Diffusion in only once every sec
% % %     if ~mod(t(k),1)
% % %         dZ_dt = dZ_dt + (D/dx^2)*coeff_u*Z(:,k);
% % %     end
    % Calculate the solution at that time
    Z_k1 = Z(:,k) + dt*dZ_dt;
    Y_k1 = Y(:,k) + dt*dY_dt;
    % Save it 
    Z(:,k+1) = Z_k1;
    Y(:,k+1) = Y_k1;
end
end_time = toc;
display(['Simulation Complete in ',num2str(end_time), ' seconds'])

figure(1)
imagesc(t,flipud(x),flipud(Y))   
colormap jet
if beta_changing
    figure(2)
    plot(beta,x)
    set(gca,'YDir','reverse');
else
    figure(2)
    plot(t, Z(10,:), t, Y(10,:))
    legend('Z', 'Y')
end
