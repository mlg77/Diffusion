%% Effect of InvA vs sp_inv on time taken to solve


clear; clc; close all; 
%% Where am I
AllDir.ParentDir = 'C:\Temp\Diffusion\MOL_PDE\';
AllDir.SourceDir = '1. Source files';
AllDir.InitalDataDir = '2. Inital Data';
AllDir.SaveDir = '4. Output files';

Z_0 = 0.3; V_0 = -40; Y_0 = 0.5;
D = 6e-6;

% Change [time; dt; dx]
% Changing_values = [5, 10, 15, 20; 2e-3, 1e-3, 0.5e-3, 1e-4; 1e-3, 2e-3, 5e-3, 10e-3];
% Changing_values = [5, 10, 15, 20, 60; 2e-3,0,0,0 0,; 1e-3,0,0,0,0];
Changing_dx = [ 1e-3, 2e-3, 5e-3, 10e-3];
Changing_dt = [ 2e-3, 1e-3, 0.5e-3, 1e-4];

% time_sp = zeros(size(Changing_values));
% time_inv  = zeros(size(Changing_values));
for i = 1:length(Changing_dx)% size(Changing_values, 1)
    for j = 1:length(Changing_dt)%size(Changing_values, 2)
        % Vary variables i determines row (which variable) and j determines
        % its size
        display(['[',num2str(i),',',num2str(j),']'])
        dt = Changing_dt(j);
        dx = Changing_dx(i);
        
        t_end = 5;
        x = 0:dx:1;   M = length(x); 
        t = 0:dt:t_end;   N = length(t);
        mybeta = (0.5*(1+tanh((x-0.5)/0.5)))';
        % No inv tims method
        tic
        [ Z, V ] = Gold_Simple_Diffusion_noinv( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
        time_sp(i,j) = toc
        % inv_A found
        tic
        [ Z1, V1 ] = Gold_Simple_Diffusion_sp( dt, dx, x, t, M, N, Z_0, V_0, Y_0, mybeta, D);
        time_inv(i,j) = toc
%         figure(1); subplot(3,3,j+(i-1)*3)
%             imagesc(t,flipud(x),Z)
%             set(gca,'YDir','normal')
%             xlabel('Time, [s]')
%             ylabel('Position, x')
%             colormap jet
%             colorbar
%         figure(2); subplot(3,3,j+(i-1)*3)
%             imagesc(t,flipud(x),Z1)
%             set(gca,'YDir','normal')
%             xlabel('Time, [s]')
%             ylabel('Position, x')
%             colormap jet
%             colorbar
    end
end

%% Plot for Changing 3 variables
% changing = {'Length of time computed','dt', 'dx'};
% for i = 1:3
%     figure(i)
%     plot(Changing_values(i,:), time_sp(i,:), '-bx', Changing_values(i,:), time_inv(i,:), '-rx')
%     ylabel('Time to compute result, [s]')
%     xlabel(changing{i})
%     legend('Sparse Matrix with Conjugate Gradient Method', 'Simple finding the inverse prior')
% end

%% Plot for Grid of possibilities

figure;hold on
colormap([1 0 0;0 0 1]) %red and blue
surf(Changing_dt, Changing_dx, time_sp,ones(4,4)); %first color (red)
surf(Changing_dt, Changing_dx, time_inv,ones(4,4)+1); %second color(blue)
view(17,22)
grid on
xlabel('dt, [s]'); ylabel('dx'); zlabel('Time to compute result')
legend('Sparse Matrix with Conjugate Gradient Method', 'Simple finding the inverse prior')
